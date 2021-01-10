import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import 'builder.dart';

void main() async {
  print("Sera antes");
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    )
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Future<Map> _getTotalizer() async {
  return await totalizer();
}

class _HomeState extends State<Home> {

  var _totalizer = _getTotalizer();

  var _total = 0;

  var initialInvestment = 2230.95;

  var stocksNames = ['ALZR11', 'BCFF11', 'HGLG11', 'ALSO3', 'BBAS3', 'BIDI11',
    'BRFS3', 'CYRE3', 'ENEV3', 'GMAT3', 'GOAU4', 'ITUB4', 'LAME4', 'LREN3', 'LWSA3',
    'MGLU3', 'NTCO3', 'PETR4', 'PSSA3', 'RLOG3', 'TOTS3', 'VALE3', 'VIVT3'];

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color(0xFFFAFAFA),
          child: FutureBuilder<Map>(
            future: _getTotalizer(),
            builder: (context, snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text("Carregando dados"),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro"),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(right: 10, left: 10, bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 80, left: 20),
                                child: Text(
                                  "Carteira \nde investimentos",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      color: Color(0XFF333333),
                                      fontSize: 36,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20, bottom: 40)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: RichText(
                                  text: TextSpan(
                                    text: "R\$ ${(snapshot.data['total'] - initialInvestment).toStringAsFixed(2)}",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: (snapshot.data['total'] - initialInvestment) < 0 ? Color(0xFFE94375) : Color(0xFF00B071),
                                        fontSize: 35,
                                      ),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '\nSaldo', style: GoogleFonts.inter(
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
                                    text: "${(((snapshot.data['total'] * 100) / initialInvestment) - 100).toStringAsFixed(2)}%",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                        color: Color(0XFF333333),
                                        fontSize: 35,
                                      ),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '\nValorização', style: GoogleFonts.inter(
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
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data['stocks'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: Card(
                                          shape: Border(
                                            left: BorderSide(
                                              color: snapshot.data['stocks'][stocksNames[index]]['change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
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
                                                    text: stocksNames[index],
                                                    style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                      color: Color(0xFF2A2B2D),
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: "\n ${snapshot.data['stocks'][stocksNames[index]]['change_percent'].toStringAsFixed(2)}%",
                                                        style: GoogleFonts.inter(
                                                          textStyle: TextStyle(
                                                            color: snapshot.data['stocks'][stocksNames[index]]['change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: "R\$ ${snapshot.data['stocks'][stocksNames[index]]['price'].toStringAsFixed(2)}",
                                                    style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                      color: Color(0xFF2A2B2D),
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: "\nValor do papel",
                                                        style: GoogleFonts.inter(
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
                                                    text: "R\$ ${snapshot.data['stocks'][stocksNames[index]]['amount_invested'].toStringAsFixed(2)}",
                                                    style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                      color: Color(0xFF2A2B2D),
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: "\nQtd investida",
                                                        style: GoogleFonts.inter(
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
                                );
                              },
                            )
                          ),
                        ],
                      ),
                    );
                  }
              }
            }
          )
      );
  }
}