import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const requestVVAR = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=VVAR3.SAO&apikey=X0KLX0CI9BQBNGFR";
const requestFLRY = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=FLRY3.SAO&apikey=X0KLX0CI9BQBNGFR";
const requestSQIA = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=SQIA3.SAO&apikey=X0KLX0CI9BQBNGFR";
const requestOIBR = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=OIBR4.SAO&apikey=X0KLX0CI9BQBNGFR";

void main() async {
  http.Response responseVVAR = await http.get(requestVVAR);
  http.Response responseFLRY = await http.get(requestFLRY);
  http.Response responseSQIA = await http.get(requestSQIA);
  http.Response responseOIBR = await http.get(requestOIBR);

  var _vvar = {
    "price": json.decode(responseVVAR.body)["Global Quote"]["05. price"],
  };

  var _flry = {
    "price": json.decode(responseFLRY.body)["Global Quote"]["05. price"],
  };

  var _sqia = {
    "price": json.decode(responseSQIA.body)["Global Quote"]["05. price"],
  };

  var _oibr = {
    "price": json.decode(responseOIBR.body)["Global Quote"]["05. price"],
  };

  var _total = (70 * double.parse(_vvar['price'])) 
    + (21 * double.parse(_flry['price']))
    + (25 * double.parse(_sqia['price']))
    + (100 * double.parse(_oibr['price']));

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Material(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 15.0, right: 15.0),
                  decoration: new BoxDecoration(
                    color: (_total - 2508.68) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853), 
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  child:
                    Text(
                      "R\$ ${(_total - 2508.68).toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Color(0XFFFFFFFF),
                        fontSize: 50,
                      ),
                    ),
                ),
              ],
            ),
          ),
      ),
    )
  ));
}