import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'indicator.dart';
import 'package:flutter/services.dart';

import 'builder.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(
        storage: Storage(),
      ),
    )
  );
}

class Home extends StatefulWidget {
  final Storage storage;

  Home({Key key, @required this.storage}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Future<Map> _getTotalizer() async {
  return await totalizer();
}

class _HomeState extends State<Home> {

  var _totalizer;
  int touchedIndex;

  List<PieChartSectionData> showingSections(fii_pct, stock_pct) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff1B88DF),
            value: double.parse(stock_pct),
            title: '${stock_pct}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xffFBAA32),
            value: double.parse(fii_pct),
            title: '${fii_pct}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   widget.storage.readData().then((String value) {
  //     setState(() {
  //       print("OPAAAAAA");
  //       _totalizer = json.decode(value);
  //       print(_totalizer);
  //       print('---------------------------------');
  //       print(_totalizer['total']);
  //       print('---------------------------------');
  //     });

  //   });
  // }

  // var _totalizer = _getTotalizer();

  var _total = 0;

  var initialInvestment = 2230.95;
  var stocksInitialInvestment = 1613.83;
  var fiisInitialInvestment = 617.12;

  var stocksNames = ['ALSO3', 'BBAS3', 'BIDI11',
    'BRFS3', 'CYRE3', 'ENEV3', 'GMAT3', 'GOAU4', 'ITUB4', 'LAME4', 'LREN3', 'LWSA3',
    'MGLU3', 'NTCO3', 'PETR4', 'PSSA3', 'RLOG3', 'TOTS3', 'VALE3', 'VIVT3'];

  var fiisNames = ['ALZR11', 'BCFF11', 'HGLG11'];

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color(0xFFFAFAFA),
          child: FutureBuilder<Map>(
            // future: widget.storage.readData().then((value) => value),
            future: _getTotalizer(),
            builder: (context, snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Carregando dados...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )
                          ),
                        ),
                      ],
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro"),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(right: 10, left: 10, bottom: 20),
                      child:
                          DefaultTabController(
                            length: 3,
                            child: Scaffold(
                              backgroundColor: Colors.white,
                              appBar: PreferredSize(
                                child: AppBar(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  bottom: PreferredSize(
                                      preferredSize: const Size.fromHeight(kToolbarHeight),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TabBar(
                                          indicatorColor: Colors.grey,
                                          labelColor: Colors.black,
                                          unselectedLabelColor: Colors.grey,
                                          isScrollable: true,
                                          tabs: [
                                            Tab(text: "Resumo"),
                                            Tab(text: "Ações"),
                                            Tab(text: "Fundos"),
                                          ],
                                        ),
                                      ),
                                  ),
                                  flexibleSpace: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //   Row(
                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                        //   children: <Widget>[
                                        //     Container(
                                        //       padding: EdgeInsets.only(top: 80, left: 20),
                                        //       child: Text(
                                        //         "Carteira \nde investimentos",
                                        //         style: GoogleFonts.inter(
                                        //           textStyle: TextStyle(
                                        //             color: Color(0XFF333333),
                                        //             fontSize: 36,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        Padding(padding: EdgeInsets.only(top: 50, bottom: 40)),
                                        Container(
                                              padding: EdgeInsets.only(left: 20),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: "R\$ ${(initialInvestment).toStringAsFixed(2)} ",
                                                  style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 35,
                                                    ),
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: "(",
                                                      style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: "R\$ ${(snapshot.data['total'] - initialInvestment).toStringAsFixed(2)}",
                                                      style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: (snapshot.data['total'] - initialInvestment) < 0 ? Color(0xFFE94375) : Color(0xFF00B071),
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: ")",
                                                      style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: '\nTotal investido', style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                          color: Color(0XFF777777),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   // crossAxisAlignment: CrossAxisAlignment.stretch,
                                        //   children: <Widget>[
                                        //     Container(
                                        //       padding: EdgeInsets.only(right: 20),
                                        //       child: RichText(
                                        //         text: TextSpan(
                                        //           text: "${(((snapshot.data['total'] * 100) / initialInvestment) - 100).toStringAsFixed(2)}%",
                                        //           style: GoogleFonts.inter(
                                        //             textStyle: TextStyle(
                                        //               color: Color(0XFF333333),
                                        //               fontSize: 25,
                                        //             ),
                                        //           ),
                                        //           children: <TextSpan>[
                                        //             TextSpan(
                                        //               text: '\nValorização', style: GoogleFonts.inter(
                                        //                 textStyle: TextStyle(
                                        //                   color: Color(0XFF777777),
                                        //                   fontSize: 13,
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       )
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                preferredSize: Size.fromHeight(200.0),
                              ),
                              floatingActionButton: FloatingActionButton(
                                onPressed: () {
                                  _settingModalBottomSheet(context);
                                },
                                child: Icon(Icons.add),
                                backgroundColor: Color(0xFF125bb0),
                              ),
                              body: TabBarView(
                                  children: [
                                    SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            AspectRatio(
                                              aspectRatio: 1.3,
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    const SizedBox(
                                                      height: 14,
                                                    ),
                                                    Expanded(
                                                      child: AspectRatio(
                                                        aspectRatio: 1,
                                                        child: PieChart(
                                                          PieChartData(
                                                              borderData: FlBorderData(
                                                                show: false,
                                                              ),
                                                              sectionsSpace: 0,
                                                              centerSpaceRadius: 75,
                                                              sections: showingSections((snapshot.data['fiis_total'] * 100 / snapshot.data['total']).toStringAsFixed(1), (snapshot.data['stocks_total'] * 100 / snapshot.data['total']).toStringAsFixed(1))
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: const <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Indicator(
                                                              color: Color(0xff1B88DF),
                                                              text: 'Ações',
                                                              isSquare: false,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: Indicator(
                                                              color: Color(0xffFBAA32),
                                                              text: 'Fiis',
                                                              isSquare: false,
                                                            ),
                                                          ),
                                                          // SizedBox(
                                                          //   height: 4,
                                                          // ),
                                                          // Indicator(
                                                          //   color: Color(0xff845bef),
                                                          //   text: 'ETF',
                                                          //   isSquare: false,
                                                          // ),
                                                          // SizedBox(
                                                          //   height: 4,
                                                          // ),
                                                          // Indicator(
                                                          //   color: Color(0xff13d38e),
                                                          //   text: 'Small Caps',
                                                          //   isSquare: false,
                                                          // ),
                                                          // SizedBox(
                                                          //   height: 18,
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 28,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),





                                            Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                                                Card(
                                                    color: Color(0xffFAFBFE),
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(color: Color(0xffdde2e7), width: 2),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    elevation: 0,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 20.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: <Widget>[
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "Investimento em ações",
                                                                style: GoogleFonts.inter(
                                                                textStyle: TextStyle(
                                                                  color: Color(0xFF2A2B2D),
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              ),
                                                            ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 8.0),
                                                            child: Row(
                                                              children: [
                                                                RichText(
                                                                  text: TextSpan(
                                                                    text: "R\$ ${(stocksInitialInvestment).toStringAsFixed(2)} ",
                                                                    style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 18,
                                                                      ),
                                                                    ),
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: "(",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: "R\$ ${(snapshot.data['stocks_total'] - stocksInitialInvestment).toStringAsFixed(2)}",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: (snapshot.data['stocks_total'] - stocksInitialInvestment) < 0 ? Color(0xFFE94375) : Color(0xFF00B071),
                                                                            fontSize: 14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: ")",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                                                Card(
                                                    color: Color(0xffFAFBFE),
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(color: Color(0xffdde2e7), width: 2),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    elevation: 0,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: <Widget>[
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "Investimento em fundos",
                                                                style: GoogleFonts.inter(
                                                                textStyle: TextStyle(
                                                                  color: Color(0xFF2A2B2D),
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              ),
                                                            ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 8.0),
                                                            child: Row(
                                                              children: [
                                                                RichText(
                                                                  text: TextSpan(
                                                                    text: "R\$ ${(fiisInitialInvestment).toStringAsFixed(2)} ",
                                                                    style: GoogleFonts.inter(
                                                                      textStyle: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 18,
                                                                      ),
                                                                    ),
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: "(",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: "R\$ ${(snapshot.data['fiis_total'] - fiisInitialInvestment).toStringAsFixed(2)}",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: (snapshot.data['fiis_total'] - fiisInitialInvestment) < 0 ? Color(0xFFE94375) : Color(0xFF00B071),
                                                                            fontSize: 14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: ")",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: ListView.builder(
                                      itemCount: snapshot.data['stocks'].length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                            mainAxisSize: MainAxisSize.min,
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
                                          );
                                      },
                                  ),
                                    ),
                                    Container(
                                      child: ListView.builder(
                                      itemCount: snapshot.data['fiis'].length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(15.0),
                                                child: Card(
                                                  shape: Border(
                                                    left: BorderSide(
                                                      color: snapshot.data['fiis'][fiisNames[index]]['change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
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
                                                            text: fiisNames[index],
                                                            style: GoogleFonts.inter(
                                                            textStyle: TextStyle(
                                                              color: Color(0xFF2A2B2D),
                                                              fontSize: 25,
                                                            ),
                                                          ),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text: "\n ${snapshot.data['fiis'][fiisNames[index]]['change_percent'].toStringAsFixed(2)}%",
                                                                style: GoogleFonts.inter(
                                                                  textStyle: TextStyle(
                                                                    color: snapshot.data['fiis'][fiisNames[index]]['change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text: "R\$ ${snapshot.data['fiis'][fiisNames[index]]['price'].toStringAsFixed(2)}",
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
                                                            text: "R\$ ${snapshot.data['fiis'][fiisNames[index]]['amount_invested'].toStringAsFixed(2)}",
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
                                          );
                                      },
                                  ),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                    );
                  }
              }
            }
          )
      );
  }
}

class Storage  {
  Future<String> get localPath async  {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async  {
    final path = await localPath;
    return File('$path/stock_data.json');
  }

  Future<Map> readData() async {
    try {
      final file = await localFile;
      return await file.readAsString().then((value) => json.decode(value));
    } catch (e) {
      var tt = _getTotalizer().then((Map test) {
        return json.encode(test);
      }).then((String value) {
        this.writeData(value);
      });

      return null;
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}

void _settingModalBottomSheet(context){
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (BuildContext bc){
          return Container(
            padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Papel'
                        ),
                      ), 
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'Quantidade'
                        ),
                      ), 
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Valor de compra'
                        ),
                      ), 
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: new Text(
                              "Adicionar",
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 16, 
                              )
                          ),
                        ),
                        colorBrightness: Brightness.dark,
                        onPressed: () {
                          // _loginAttempt(context);
                        },
                        color: Color(0xFF125bb0),
                      ),
                    ],
                  ),
                ],
              ),
        ),
          );
      }
    );
}