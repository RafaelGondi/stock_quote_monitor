import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

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
    "symbol": json.decode(responseVVAR.body)["Global Quote"]["01. symbol"].replaceAll('.SAO', ''),
    "price": json.decode(responseVVAR.body)["Global Quote"]["05. price"],
    "change_percent": json.decode(responseVVAR.body)["Global Quote"]["10. change percent"].replaceAll('%', ''),
  };

  var _flry = {
    "symbol": json.decode(responseFLRY.body)["Global Quote"]["01. symbol"].replaceAll('.SAO', ''),
    "price": json.decode(responseFLRY.body)["Global Quote"]["05. price"],
    "change_percent": json.decode(responseFLRY.body)["Global Quote"]["10. change percent"].replaceAll('%', ''),
  };

  var _sqia = {
    "symbol": json.decode(responseSQIA.body)["Global Quote"]["01. symbol"].replaceAll('.SAO', ''),
    "price": json.decode(responseSQIA.body)["Global Quote"]["05. price"],
    "change_percent": json.decode(responseSQIA.body)["Global Quote"]["10. change percent"].replaceAll('%', ''),
  };

  var _oibr = {
    "symbol": json.decode(responseOIBR.body)["Global Quote"]["01. symbol"].replaceAll('.SAO', ''),
    "price": json.decode(responseOIBR.body)["Global Quote"]["05. price"],
    "change_percent": json.decode(responseOIBR.body)["Global Quote"]["10. change percent"].replaceAll('%', ''),
  };

  var _total = (70 * double.parse(_vvar['price'])) 
    + (21 * double.parse(_flry['price']))
    + (25 * double.parse(_sqia['price']))
    + (100 * double.parse(_oibr['price']));

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Color(0xFFFAFAFA),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 80, left: 20, bottom: 30),
                    child: Text(
                      "Balance",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Color(0XFF333333),
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
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
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Color(0XFFFFFFFF),
                              fontSize: 50,
                            ),
                          ),
                        ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20, bottom: 20)),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              _vvar['symbol'],
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "R\$ ${(70 * double.parse(_vvar['price'])).toStringAsFixed(2)}",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              double.parse(_vvar['price']).toStringAsFixed(2),
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "${_vvar['change_percent']}%",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: double.parse((_vvar['price'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              _flry['symbol'],
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "R\$ ${(70 * double.parse(_flry['price'])).toStringAsFixed(2)}",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              double.parse(_flry['price']).toStringAsFixed(2),
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "${_flry['change_percent']}%",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: double.parse((_flry['price'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              _sqia['symbol'],
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "R\$ ${(70 * double.parse(_sqia['price'])).toStringAsFixed(2)}",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              double.parse(_sqia['price']).toStringAsFixed(2),
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "${_sqia['change_percent']}%",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: double.parse((_sqia['price'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              _oibr['symbol'],
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "R\$ ${(70 * double.parse(_oibr['price'])).toStringAsFixed(2)}",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              double.parse(_oibr['price']).toStringAsFixed(2),
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Color(0xFF2A2B2D),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              "${_oibr['change_percent']}%",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: double.parse((_oibr['price'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      )
    )
  );
}