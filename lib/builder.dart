import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map> _cryptoMap (cryptoName, qtd) async {
  http.Response stockResponse = await http.get("https://api.nomics.com/v1/currencies/ticker?key=demo-26240835858194712a4f8cc0dc635c7a&ids=${cryptoName}&interval=1d,30d&convert=BRL&per-page=100&page=1");

  return {
    "symbol": cryptoName,
    "amount_invested": qtd * double.parse(json.decode(stockResponse.body)[0]["price"]),
    "price": double.parse(json.decode(stockResponse.body)[0]["price"]),
    "change_percent": double.parse(json.decode(stockResponse.body)[0]["1d"]["price_change_pct"]) * 100,
  };
}

Future<Map> _fiisMap (fiisName, qtd) async {
  http.Response stockResponse = await http.get("https://mfinance.com.br/api/v1/fiis?symbols=${fiisName}");

  return {
    "symbol": fiisName,
    "amount_invested": qtd * json.decode(stockResponse.body)[0]["lastPrice"],
    "price": json.decode(stockResponse.body)[0]["lastPrice"],
    "change_percent": json.decode(stockResponse.body)[0]["change"],
  };
}

Future<Map> _stockMap (stockName, qtd) async {
  print("stockName: ");
  print(stockName);

  print("qtd: ");
  print(qtd);

  http.Response stockResponse = await http.get("https://mfinance.com.br/api/v1/stocks?symbols=${stockName}");

  print(json.decode(stockResponse.body)["stocks"]);

  var shouldIEnter = json.decode(stockResponse.body)["stocks"] == null ? false : true;

  if (shouldIEnter) {
    return {
      "symbol": stockName,
      "amount_invested": qtd * json.decode(stockResponse.body)["stocks"][0]["lastPrice"],
      "price": json.decode(stockResponse.body)["stocks"][0]["lastPrice"],
      "change_percent": json.decode(stockResponse.body)["stocks"][0]["change"],
    };
  } else {

    stockResponse = await http.get("https://api.hgbrasil.com/finance/stock_price?key=2e240911&symbol=${stockName}");
    shouldIEnter = json.decode(stockResponse.body)["results"][stockName]["error"] == true ? false : true;

    if (shouldIEnter) {
      return {
        "symbol": stockName,
        "amount_invested": qtd * json.decode(stockResponse.body)["results"][stockName]["price"],
        "price": json.decode(stockResponse.body)["results"][stockName]["price"],
        "change_percent": json.decode(stockResponse.body)["results"][stockName]["change_percent"],
      };
    } else {
      stockResponse = await http.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${stockName}.SAO&apikey=X0KLX0CI9BQBNGFR");

      return {
        "symbol": json.decode(stockResponse.body)["Global Quote"]["01. symbol"].replaceAll('.SAO', ''),
        "amount_invested": qtd * double.parse(json.decode(stockResponse.body)["Global Quote"]["05. price"]),
        "price": double.parse(json.decode(stockResponse.body)["Global Quote"]["05. price"]),
        "change_percent": double.parse(json.decode(stockResponse.body)["Global Quote"]["10. change percent"].replaceAll('%', '')),
      };
    }
  }
}

Future<Map> totalizer() async {
  var stocksNames = ['ALSO3', 'BBAS3', 'BIDI11',
    'BRFS3', 'CYRE3', 'ENEV3', 'GMAT3', 'GOAU4', 'ITUB4', 'LAME4', 'LREN3', 'LWSA3',
    'MGLU3', 'NTCO3', 'PETR4', 'PSSA3', 'RLOG3', 'TOTS3', 'VALE3', 'VIVT3'];

  var fiisNames = ['ALZR11', 'BCFF11', 'HGLG11', 'HGBS11', 'TEPP11'];

  var cryptoNames = ['BTC', 'ETH'];

  var stocksQuantities = [2.0, 4.0, 2.0, 2.0, 2.0, 1.0,
    3.0, 4.0, 2.0, 2.0, 2.0, 1.0, 4.0, 3.0, 3.0,
    1.0, 1.0, 2.0, 2.0, 1.0];

  var fiisQuantities = [2.0, 2.0, 2.0, 1.0, 2.0];

  var cryptoQuantities = [0.00051275, 0.02161401];

  var stocksObj = {};
  var total = 0.0;
  
  for (var stock in stocksNames) {
    stocksObj[stock] = {};
  }

  for (var fii in fiisNames) {
    stocksObj[fii] = {};
  }

  var _totalizer = new Map<String, dynamic>();
  
  _totalizer['total'] = 0.0;
  _totalizer['stocks_total'] = 0.0;
  _totalizer['fiis_total'] = 0.0;
  _totalizer['crypto_total'] = 0.0;


  _totalizer['stocks'] = new Map<String, dynamic>();
  _totalizer['fiis'] = new Map<String, dynamic>();
  _totalizer['crypto'] = new Map<String, dynamic>();

  for (var i = 0; i < cryptoNames.length; i++) {
    _totalizer['crypto'][cryptoNames[i]] = await _cryptoMap(cryptoNames[i], cryptoQuantities[i]);
  }

  for (var i = 0; i < fiisNames.length; i++) {
    _totalizer['fiis'][fiisNames[i]] = await _fiisMap(fiisNames[i], fiisQuantities[i]);
  }

  for (var i = 0; i < stocksNames.length; i++) {
    _totalizer['stocks'][stocksNames[i]] = await _stockMap(stocksNames[i], stocksQuantities[i]);
  }

 ///////////////////////////////////////////////////////////////////////////////////////////////

  for (var i = 0; i < cryptoNames.length; i++) { 
    total = total + _totalizer['crypto'][cryptoNames[i]]['amount_invested'];
    _totalizer['crypto_total'] = _totalizer['crypto_total'] + _totalizer['crypto'][cryptoNames[i]]['amount_invested'];
  }

  for (var i = 0; i < fiisNames.length; i++) { 
    total = total + _totalizer['fiis'][fiisNames[i]]['amount_invested'];
    _totalizer['fiis_total'] = _totalizer['fiis_total'] + _totalizer['fiis'][fiisNames[i]]['amount_invested'];
  }

  for (var i = 0; i < stocksNames.length; i++) { 
    total = total + _totalizer['stocks'][stocksNames[i]]['amount_invested'];
    _totalizer['stocks_total'] = _totalizer['stocks_total'] + _totalizer['stocks'][stocksNames[i]]['amount_invested'];
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////

  _totalizer['total'] = _totalizer['stocks_total'] + _totalizer['fiis_total'] + _totalizer['crypto_total'];

  return _totalizer;
}