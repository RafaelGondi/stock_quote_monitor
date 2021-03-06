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
                    padding: EdgeInsets.only(top: 80, left: 20),
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
              Padding(padding: EdgeInsets.only(top: 20, bottom: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: RichText(
                      text: TextSpan(
                        text: "R\$ ${(_total - 2508.68).toStringAsFixed(2)}",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: (_total - 2508.68) < 0 ? Color(0xFFE94375) : Color(0xFF00B071),
                            fontSize: 35,
                          ),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '\nDaily gain', style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Color(0XFF777777),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  Container(height: 100, child: VerticalDivider(color: Color(0XFF777777))),
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: RichText(
                      text: TextSpan(
                        text: "${(_total < 2508.68 ? ((_total * 100) / 2508.68) - 100 : (_total * 100) / 2508.68).toStringAsFixed(2)}%",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Color(0XFF333333),
                            fontSize: 35,
                          ),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '\nEquity rise', style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Color(0XFF777777),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 20, bottom: 20)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Card(
                        shape: Border(
                          left: BorderSide(
                            color: double.parse((_vvar['price'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                            width: 5
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: _vvar['symbol'],
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 25,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\n ${double.parse(_vvar['change_percent']).toStringAsFixed(2)}%",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: double.parse((_vvar['change_percent'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "R\$ ${(70 * double.parse(_vvar['price'])).toStringAsFixed(2)}",
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 20,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\nAmount invested",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "R\$ ${double.parse(_vvar['price']).toStringAsFixed(2)}",
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 20,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\nStock quote",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Card(
                        shape: Border(
                            left: BorderSide(
                              color: double.parse((_flry['price'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                              width: 5
                            )
                          ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: _flry['symbol'],
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 25,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\n ${double.parse(_flry['change_percent']).toStringAsFixed(2)}%",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: double.parse((_flry['change_percent'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "R\$ ${(21 * double.parse(_flry['price'])).toStringAsFixed(2)}",
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 20,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\nAmount invested",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "R\$ ${double.parse(_flry['price']).toStringAsFixed(2)}",
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 20,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\nStock quote",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Card(
                        shape: Border(
                            left: BorderSide(
                              color: double.parse((_sqia['price'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                              width: 5
                            )
                          ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: _sqia['symbol'],
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 25,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\n ${double.parse(_sqia['change_percent']).toStringAsFixed(2)}%",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: double.parse((_sqia['change_percent'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "R\$ ${(25 * double.parse(_sqia['price'])).toStringAsFixed(2)}",
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 20,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\nAmount invested",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "R\$ ${double.parse(_sqia['price']).toStringAsFixed(2)}",
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 20,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\nStock quote",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Card(
                        shape: Border(
                            left: BorderSide(
                              color: double.parse((_oibr['price'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                              width: 5
                            )
                          ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: _oibr['symbol'],
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 25,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\n ${double.parse(_oibr['change_percent']).toStringAsFixed(2)}%",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: double.parse((_oibr['change_percent'])) < 0 ? Color(0xFFe8505a) : Color(0xFF34a853),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "R\$ ${(100 * double.parse(_oibr['price'])).toStringAsFixed(2)}",
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 20,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\nAmount invested",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "R\$ ${double.parse(_oibr['price']).toStringAsFixed(2)}",
                                  style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Color(0xFF2A2B2D),
                                    fontSize: 20,
                                  ),
                                ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "\nStock quote",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Color(0xFF777777),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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