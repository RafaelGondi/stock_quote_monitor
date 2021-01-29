class VariableIncome {
  String type;
  String name;
  double qtdBought;
  double valueBought;

  VariableIncome(this.type, this.name, this.qtdBought, this.valueBought);

  Map<String,dynamic> get map {
    return {
      "type": type,
      "name": name,
      "qtdBought":qtdBought,
      "valueBought": valueBought,
    };
  }
}

Map<String, List<VariableIncome>> variableIncomeData() {
  var stocks = [
    VariableIncome('stock', 'AERI3', 10.0, 12.30),
    VariableIncome('stock', 'ALSO3', 2.0, 28.990),
    VariableIncome('stock', 'ARZZ3', 1.0, 69.06),
    VariableIncome('stock', 'BBAS3', 4.0, 39.100),
    VariableIncome('stock', 'BIDI11', 2.0, 101.770),
    VariableIncome('stock', 'BMGB4', 10.0, 5.38),
    VariableIncome('stock', 'BPAN4', 10.0, 9.22),
    VariableIncome('stock', 'BRFS3', 2.0, 22.400),
    VariableIncome('stock', 'CYRE3', 2.0, 28.940),
    VariableIncome('stock', 'ENEV3', 1.0, 58.900),
    VariableIncome('stock', 'GMAT3', 3.0, 8.320),
    VariableIncome('stock', 'GOAU4', 4.0, 11.350),
    VariableIncome('stock', 'ITUB4', 2.0, 32.050),
    VariableIncome('stock', 'LAME4', 2.0, 26.180),
    VariableIncome('stock', 'LPSB3', 15.0, 4.58),
    VariableIncome('stock', 'LREN3', 2.0, 43.560),
    VariableIncome('stock', 'LWSA3', 4.0, 93.5275),
    VariableIncome('stock', 'NGRD3', 15.0, 9.760),
    VariableIncome('stock', 'NTCO3', 3.0, 51.520),
    VariableIncome('stock', 'PETR4', 3.0, 28.200),
    VariableIncome('stock', 'RDOR3', 1.0, 67.17),
    VariableIncome('stock', 'RRRP3', 3.0, 34.36),
    VariableIncome('stock', 'TAEE11', 3.0, 32.13),
    VariableIncome('stock', 'TOTS3', 2.0, 27.730),
    VariableIncome('stock', 'VALE3', 2.0, 87.390),
  ];

      // VariableIncome('stock', 'LWSA3', 1.0, 76.930),
    // VariableIncome('stock', 'LWSA3', 4.0, 93.5275),
    // VariableIncome('stock', 'NGRD3', 5.0, 11.542),

  var fiis = [
    // VariableIncome('fii', 'ALZR11', 2.0, 129.000),
    // VariableIncome('fii', 'BCFF11', 2.0, 91.260),
    VariableIncome('fii', 'HGLG11', 2.0, 178.805),
    // VariableIncome('fii', 'HGBS11', 1.0, 216.76),
    VariableIncome('fii', 'TEPP11', 3.0, 89.297),

    VariableIncome('fii', 'BCRI11', 2.0, 117.66),
    VariableIncome('fii', 'HFOF11', 2.0, 103.20),
    VariableIncome('fii', 'HCTR11', 2.0, 148.95),
  ];

  var cryptos = [
    VariableIncome('crypto', 'BTC', 0.00051275, 194049.97),
    VariableIncome('crypto', 'ETH', 0.02161401, 6939.94),
  ];

  return {
    'stocks': stocks,
    'fiis': fiis,
    'cryptos': cryptos,
  };
}