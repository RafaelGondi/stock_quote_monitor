import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'indicator.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'builder.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';

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

  List<PieChartSectionData> showingSections(fii_pct, stock_pct, crypto_pct) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 15;
      final double radius = isTouched ? 60 : 48;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff2D99FE),
            value: double.parse(stock_pct),
            title: '${stock_pct}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xffFD825D),
            value: double.parse(fii_pct),
            title: '${fii_pct}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff816AF8),
            value: double.parse(crypto_pct),
            title: '${crypto_pct}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        // case 3:
        //   return PieChartSectionData(
        //     color: const Color(0xff2CD9C5),
        //     value: double.parse(cash_pct),
        //     title: '${cash_pct}%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //         fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        //   );
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

  // var initialInvestment = 5172.811;
  // var fiisInitialInvestment = 1365.121;
  // var cryptoInitialInvestment = 250.0;

  var stocksNames = ['AERI3', 'ALSO3', 'ARZZ3', 'BBAS3', 'BIDI11', 'BMGB4',
    'BPAN4', 'BRFS3', 'CYRE3', 'ENEV3', 'GMAT3', 'GOAU4', 'ITUB4', 'LAME4', 'LPSB3', 'LREN3', 'LWSA3',
    'NGRD3', 'NTCO3', 'PETR4', 'RDOR3', 'RRRP3', 'TAEE11', 'TOTS3', 'VALE3',
    ];

  var fiisNames = ['HGLG11', 'TEPP11', 'BCRI11', 'HFOF11', 'HCTR11'];

  var cryptoNames = ['BTC', 'ETH'];

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
                            length: 4,
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
                                          indicatorColor: Colors.cyan,
                                          labelColor: Colors.black,
                                          unselectedLabelColor: Colors.blueGrey,
                                          isScrollable: true,
                                          tabs: [
                                            Tab(text: "Resumo"),
                                            Tab(text: "Ações"),
                                            Tab(text: "Fundos"),
                                            Tab(text: "Criptomoedas"),
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
                                                  text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['initial_investment'])}",
                                                  style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 35,
                                                    ),
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: " (",
                                                      style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['total'] - snapshot.data['initial_investment'])}",
                                                      style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: (snapshot.data['total'] - snapshot.data['initial_investment']) < 0 ? Color(0xFFE94375) : Color(0xFF00B071),
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
                                        padding: EdgeInsets.only(top: 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(
                                              width: 40,
                                            ),
                                            AspectRatio(
                                              aspectRatio: 1.4,
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: AspectRatio(
                                                        aspectRatio: 1,
                                                        child: PieChart(
                                                          PieChartData(
                                                              borderData: FlBorderData(
                                                                show: false,
                                                              ),
                                                              sectionsSpace: 0,
                                                              centerSpaceRadius: 55,
                                                              sections: showingSections(
                                                                (snapshot.data['fiis_total'] * 100 / snapshot.data['total']).toStringAsFixed(1),
                                                                (snapshot.data['stocks_total'] * 100 / snapshot.data['total']).toStringAsFixed(1),
                                                                (snapshot.data['crypto_total'] * 100 / snapshot.data['total']).toStringAsFixed(1),
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 4.0),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: const <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                                            child: Indicator(
                                                              color: Color(0xff2D99FE),
                                                              text: 'Ações',
                                                              isSquare: false,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                                            child: Indicator(
                                                              color: Color(0xffFD825D),
                                                              text: 'Fiis',
                                                              isSquare: false,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                                            child: Indicator(
                                                              color: Color(0xff816AF8),
                                                              text: 'Cripto',
                                                              isSquare: false,
                                                            ),
                                                          ),
                                                          // Padding(
                                                          //   padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                                          //   child: Indicator(
                                                          //     color: Color(0xff2CD9C5),
                                                          //     text: 'Caixa',
                                                          //     isSquare: false,
                                                          //   ),
                                                          // ),
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
                                                      width: 20,
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
                                                                    text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['stocks_initial_investment'])} ",
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
                                                                        text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['stocks_total'] - snapshot.data['stocks_initial_investment'])}",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: (snapshot.data['stocks_total'] - snapshot.data['stocks_initial_investment']) < 0 ? Color(0xFFE94375) : Color(0xFF00B071),
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
                                                                    text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['fiis_initial_investment'])}",
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
                                                                        text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['fiis_total'] - snapshot.data['fiis_initial_investment'])}",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: (snapshot.data['fiis_total'] - snapshot.data['fiis_initial_investment']) < 0 ? Color(0xFFE94375) : Color(0xFF00B071),
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

                                                                      TextSpan(
                                                                        text: "\n\nDividendos: ",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['fiis_dy_month_total'])}",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Color(0xFF00B071),
                                                                            fontSize: 14,
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
                                                                text: "Investimento em criptomoedas",
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
                                                                    text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['cryptos_initial_investment'])} ",
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
                                                                        text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['crypto_total'] - snapshot.data['cryptos_initial_investment'])} ",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            color: (snapshot.data['crypto_total'] - snapshot.data['cryptos_initial_investment']) < 0 ? Color(0xFFE94375) : Color(0xFF00B071),
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
                                                    child: Column(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 16.0),
                                                          child: Row(
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: stocksNames[index],
                                                                  style: GoogleFonts.inter(
                                                                    textStyle: TextStyle(
                                                                      color: Color(0xFF2A2B2D),
                                                                      fontSize: 23,
                                                                    ),
                                                                  ),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text: " (",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: "${snapshot.data['stocks'][stocksNames[index]]['daily_change_percent'].toStringAsFixed(2)}%",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: snapshot.data['stocks'][stocksNames[index]]['daily_change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: ")",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "R\$ ${snapshot.data['stocks'][stocksNames[index]]['price'].toStringAsFixed(2)}",
                                                                  style: GoogleFonts.inter(
                                                                  textStyle: TextStyle(
                                                                    color: Color(0xFF2A2B2D),
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text: "\nValor do papel",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          color: Color(0xFF777777),
                                                                          fontSize: 11,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 16.0),
                                                                child: RichText(
                                                                  text: TextSpan(
                                                                    text: "R\$ ${snapshot.data['stocks'][stocksNames[index]]['gain'].toStringAsFixed(2)}",
                                                                    style: GoogleFonts.inter(
                                                                    textStyle: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: snapshot.data['stocks'][stocksNames[index]]['gain'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
                                                                      fontSize: 15,
                                                                    ),
                                                                  ),
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                      text: " (",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Color(0xFF2A2B2D),
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: "${snapshot.data['stocks'][stocksNames[index]]['change_percent'].toStringAsFixed(2)}%",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Color(0xFF2A2B2D),
                                                                          fontSize: 13,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: ")",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.normal,
                                                                          color: Color(0xFF2A2B2D),
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                      TextSpan(
                                                                        text: "\nGanhos",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            fontWeight: FontWeight.normal,
                                                                            color: Color(0xFF777777),
                                                                            fontSize: 11,
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
                                                      ]
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
                                                      color: snapshot.data['fiis'][fiisNames[index]]['daily_change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
                                                      width: 5
                                                    )
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 16.0),
                                                          child: Row(
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: fiisNames[index],
                                                                  style: GoogleFonts.inter(
                                                                    textStyle: TextStyle(
                                                                      color: Color(0xFF2A2B2D),
                                                                      fontSize: 23,
                                                                    ),
                                                                  ),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text: " (",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: "${snapshot.data['fiis'][fiisNames[index]]['daily_change_percent'].toStringAsFixed(2)}%",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: snapshot.data['fiis'][fiisNames[index]]['daily_change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: ")",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 15,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "R\$ ${snapshot.data['fiis'][fiisNames[index]]['price'].toStringAsFixed(2)}",
                                                                  style: GoogleFonts.inter(
                                                                  textStyle: TextStyle(
                                                                    color: Color(0xFF2A2B2D),
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text: "\nValor do papel",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          color: Color(0xFF777777),
                                                                          fontSize: 11,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 16.0),
                                                                child: RichText(
                                                                  text: TextSpan(
                                                                    text: "R\$ ${snapshot.data['fiis'][fiisNames[index]]['gain'].toStringAsFixed(2)}",
                                                                    style: GoogleFonts.inter(
                                                                    textStyle: TextStyle(
                                                                      color: Color(0xFF2A2B2D),
                                                                      fontSize: 15,
                                                                    ),
                                                                  ),
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                      text: " (",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: "${snapshot.data['fiis'][fiisNames[index]]['change_percent'].toStringAsFixed(2)}%",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: snapshot.data['fiis'][fiisNames[index]]['change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
                                                                          fontSize: 13,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: ")",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                      TextSpan(
                                                                        text: "\nGanhos",
                                                                        style: GoogleFonts.inter(
                                                                          textStyle: TextStyle(
                                                                            color: Color(0xFF777777),
                                                                            fontSize: 11,
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
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "R\$ ${snapshot.data['fiis'][fiisNames[index]]['last_dy'].toStringAsFixed(2)}",
                                                                  style: GoogleFonts.inter(
                                                                  textStyle: TextStyle(
                                                                    color: Color(0xFF29A37D),
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text: "\nDividendos do mês",
                                                                      style: GoogleFonts.inter(
                                                                        textStyle: TextStyle(
                                                                          color: Color(0xFF777777),
                                                                          fontSize: 11,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]
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
                                      itemCount: snapshot.data['crypto'].length,
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
                                                      color: snapshot.data['crypto'][cryptoNames[index]]['change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
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
                                                            text: cryptoNames[index],
                                                            style: GoogleFonts.inter(
                                                            textStyle: TextStyle(
                                                              color: Color(0xFF2A2B2D),
                                                              fontSize: 23,
                                                            ),
                                                          ),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text: "\n ${snapshot.data['crypto'][cryptoNames[index]]['change_percent'].toStringAsFixed(2)}%",
                                                                style: GoogleFonts.inter(
                                                                  textStyle: TextStyle(
                                                                    color: snapshot.data['crypto'][cryptoNames[index]]['change_percent'] < 0 ? Color(0xFFED3B51) : Color(0xFF29A37D),
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 13,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['crypto'][cryptoNames[index]]['price'])}",
                                                            style: GoogleFonts.inter(
                                                            textStyle: TextStyle(
                                                              color: Color(0xFF2A2B2D),
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text: "\nValor do papel",
                                                                style: GoogleFonts.inter(
                                                                  textStyle: TextStyle(
                                                                    color: Color(0xFF777777),
                                                                    fontSize: 11,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text: "${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(snapshot.data['crypto'][cryptoNames[index]]['gain'])}",
                                                            style: GoogleFonts.inter(
                                                            textStyle: TextStyle(
                                                              color: Color(0xFF2A2B2D),
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text: "\nGanhos",
                                                                style: GoogleFonts.inter(
                                                                  textStyle: TextStyle(
                                                                    color: Color(0xFF777777),
                                                                    fontSize: 11,
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