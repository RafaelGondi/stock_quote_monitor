import 'package:http/http.dart' as http;
import 'dart:convert';
import 'investment_data.dart';

Future<Map> _cryptoMap (cryptos) async {
  http.Response stockResponse = await http.get("https://api.nomics.com/v1/currencies/ticker?key=demo-b5d84e505a11969a7184f899fbb40ae1&ids=${cryptos['name']}&interval=1d,30d&convert=BRL&per-page=100&page=1");

  return {
    "symbol": cryptos['name'],
    "gain": (cryptos['qtdBought'] * double.parse(json.decode(stockResponse.body)[0]["price"])) - (cryptos['qtdBought'] * cryptos['valueBought']),
    "price": double.parse(json.decode(stockResponse.body)[0]["price"]),
    "change_percent": (100 - (cryptos['valueBought'] * 100) /  double.parse(json.decode(stockResponse.body)[0]["price"])),
    "daily_change_percent": double.parse(json.decode(stockResponse.body)[0]["1d"]["price_change_pct"]) * 100,
    "qtd_invested": cryptos['qtdBought'] * double.parse(json.decode(stockResponse.body)[0]["price"]),
  };
}

Future<Map> _fiisMap (fiis) async {
  http.Response stockResponse = await http.get("https://mfinance.com.br/api/v1/fiis?symbols=${fiis['name']}");
  http.Response dy = await http.get("https://mfinance.com.br/api/v1/fiis/dividends/${fiis['name']}");

  print(json.decode(dy.body)["dividends"][0]["value"]);

  return {
    "symbol": fiis['name'],
    "last_dy": fiis['qtdBought'] * json.decode(dy.body)["dividends"][0]["value"],
    "gain": (fiis['qtdBought'] * json.decode(stockResponse.body)[0]["lastPrice"]) - (fiis['qtdBought'] * fiis['valueBought']),
    "price": json.decode(stockResponse.body)[0]["lastPrice"],
    "change_percent": ((fiis['qtdBought'] * json.decode(stockResponse.body)[0]["lastPrice"]) / fiis['valueBought']) - 1,
    "daily_change_percent": json.decode(stockResponse.body)[0]["change"],
    "qtd_invested": fiis['qtdBought'] * json.decode(stockResponse.body)[0]["lastPrice"],
  };
}

Future<Map> _stockMap (stocks) async {
  http.Response stockResponse = await http.get("https://mfinance.com.br/api/v1/stocks?symbols=${stocks['name']}");

  print(json.decode(stockResponse.body)["stocks"]);

  var shouldIEnter = json.decode(stockResponse.body)["stocks"] == null ? false : true;

  if (shouldIEnter) {
    return {
      "symbol": stocks['name'],
      "gain": (stocks['qtdBought'] * json.decode(stockResponse.body)["stocks"][0]["lastPrice"]) - (stocks['qtdBought'] * stocks['valueBought']),
      "price": json.decode(stockResponse.body)["stocks"][0]["lastPrice"],
      "change_percent": (json.decode(stockResponse.body)["stocks"][0]["lastPrice"] * 100 / stocks['valueBought']) - 100,
      "daily_change_percent": json.decode(stockResponse.body)["stocks"][0]["change"],
      "qtd_invested": stocks['qtdBought'] * json.decode(stockResponse.body)["stocks"][0]["lastPrice"],
    };
  } else {

    stockResponse = await http.get("https://api.hgbrasil.com/finance/stock_price?key=2e240911&symbol=${stocks['name']}");
    shouldIEnter = json.decode(stockResponse.body)["results"][stocks['name']]["error"] == true ? false : true;

    if (shouldIEnter) {
      return {
        "symbol": stocks['name'],
        "gain": (stocks['qtdBought'] * json.decode(stockResponse.body)["results"][stocks['name']]["price"]) - (stocks['qtdBought'] * stocks['valueBought']),
        "price": json.decode(stockResponse.body)["results"][stocks['name']]["price"],
        "change_percent": json.decode(stockResponse.body)["results"][stocks['name']]["change_percent"],
      };
    } else {
      stockResponse = await http.get("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${stocks['name']}.SAO&apikey=X0KLX0CI9BQBNGFR");

      return {
        "symbol": json.decode(stockResponse.body)["Global Quote"]["01. symbol"].replaceAll('.SAO', ''),
        "gain": (stocks['qtdBought'] * double.parse(json.decode(stockResponse.body)["Global Quote"]["05. price"])) - (stocks['qtdBought'] * stocks['valueBought']),
        "price": double.parse(json.decode(stockResponse.body)["Global Quote"]["05. price"]),
        "change_percent": double.parse(json.decode(stockResponse.body)["Global Quote"]["10. change percent"].replaceAll('%', '')),
      };
    }
  }
}

Future<Map> totalizer() async {
  var tickers = variableIncomeData();

  var total = 0.0;

  // var cashInvestment = 2194.82;

  // var cashInvestment = 1455.2;

  var _totalizer = new Map<String, dynamic>();
  
  _totalizer['total'] = 0.0;
  _totalizer['stocks_total'] = 0.0;
  _totalizer['fiis_total'] = 0.0;
  _totalizer['fiis_dy_month_total'] = 0.0;
  _totalizer['crypto_total'] = 0.0;

  _totalizer['stocks_initial_investment'] = 0.0;
  _totalizer['fiis_initial_investment'] = 0.0;
  _totalizer['cryptos_initial_investment'] = 0.0;

  _totalizer['initial_investment'] = 0.0;

  _totalizer['stocks'] = new Map<String, dynamic>();
  _totalizer['fiis'] = new Map<String, dynamic>();
  _totalizer['crypto'] = new Map<String, dynamic>();

  for (var i = 0; i < tickers['cryptos'].length; i++) {
    _totalizer['crypto'][tickers['cryptos'][i].map['name']] = await _cryptoMap(tickers['cryptos'][i].map);
  }

  for (var i = 0; i < tickers['fiis'].length; i++) {
    _totalizer['fiis'][tickers['fiis'][i].map['name']] = await _fiisMap(tickers['fiis'][i].map);
  }

  for (var i = 0; i < tickers['stocks'].length; i++) {
    _totalizer['stocks'][tickers['stocks'][i].map['name']] = await _stockMap(tickers['stocks'][i].map);
  }

 ///////////////////////////////////////////////////////////////////////////////////////////////

  for (var i = 0; i < tickers['cryptos'].length; i++) { 
    total = total + _totalizer['crypto'][tickers['cryptos'][i].map['name']]['qtd_invested'];
    _totalizer['crypto_total'] = _totalizer['crypto_total'] + _totalizer['crypto'][tickers['cryptos'][i].map['name']]['qtd_invested'];

    _totalizer['cryptos_initial_investment'] = _totalizer['cryptos_initial_investment'] + (tickers['cryptos'][i].map['qtdBought'] * tickers['cryptos'][i].map['valueBought']);
  }

  for (var i = 0; i < tickers['fiis'].length; i++) { 
    total = total + _totalizer['fiis'][tickers['fiis'][i].map['name']]['qtd_invested'];
    _totalizer['fiis_total'] = _totalizer['fiis_total'] + _totalizer['fiis'][tickers['fiis'][i].map['name']]['qtd_invested'];

    _totalizer['fiis_dy_month_total'] = _totalizer['fiis_dy_month_total'] + _totalizer['fiis'][tickers['fiis'][i].map['name']]['last_dy'];

    _totalizer['fiis_initial_investment'] = _totalizer['fiis_initial_investment'] + (tickers['fiis'][i].map['qtdBought'] * tickers['fiis'][i].map['valueBought']);
  }

  for (var i = 0; i < tickers['stocks'].length; i++) { 
    total = total + _totalizer['stocks'][tickers['stocks'][i].map['name']]['qtd_invested'];
    _totalizer['stocks_total'] = _totalizer['stocks_total'] + _totalizer['stocks'][tickers['stocks'][i].map['name']]['qtd_invested'];

    _totalizer['stocks_initial_investment'] = _totalizer['stocks_initial_investment'] + (tickers['stocks'][i].map['qtdBought'] * tickers['stocks'][i].map['valueBought']);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////

  _totalizer['total'] = _totalizer['stocks_total'] + _totalizer['fiis_total'] + _totalizer['crypto_total'];
  _totalizer['initial_investment'] = _totalizer['cryptos_initial_investment'] + _totalizer['fiis_initial_investment'] + _totalizer['stocks_initial_investment'];

  return _totalizer;
}