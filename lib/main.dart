// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import './widgets/custom_input.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

var request = Uri.parse('https://api.hgbrasil.com/finance?key=1c1567e4');

void main() {
  runApp(MaterialApp(
    home: CoinConverter(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);

  return jsonDecode(response.body);
}

class CoinConverter extends StatefulWidget {
  CoinConverter({Key? key}) : super(key: key);

  @override
  State<CoinConverter> createState() => _CoinConverterState();
}

class _CoinConverterState extends State<CoinConverter> {
  @override
  final realController = TextEditingController();
  var dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  num formatNumber(String money) {
    num formated = NumberFormat().parse(money);
    return formated;
  }

  double? dolar;
  double? euro;
  double? btc;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          leading: Icon(Icons.monetization_on, color: Colors.black),
          title: Text(
            'Conversor de Moedas',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Carregando',
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                      'Erro ao carregar dados :(',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = (snapshot.data! as Map<dynamic, dynamic>)['results']
                      ['currencies']['USD']['buy'];
                  euro = (snapshot.data! as Map<dynamic, dynamic>)['results']
                      ['currencies']['EUR']['buy'];
                  btc = (snapshot.data! as Map<dynamic, dynamic>)['results']
                      ['bitcoin']['mercadobitcoin']['last'];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Icon(Icons.monetization_on_outlined,
                            color: Colors.amber, size: 150),
                        Divider(),
                        CustomTextField(
                          controller: realController,
                          initialValue: '1',
                          label: 'Reais',
                          onChanged: (_) {
                            if (realController.text == '' ||
                                realController.text.split('')[0] == '.') {
                              dolarController.text =
                                  (double.parse('0') / dolar!)
                                      .toStringAsFixed(2);
                              euroController.text = (double.parse('0') / euro!)
                                  .toStringAsFixed(2);
                              bitcoinController.text =
                                  (double.parse('0') / btc!).toString();
                            } else {
                              dolarController.text =
                                  (double.parse(realController.text) / dolar!)
                                      .toStringAsFixed(2);
                              euroController.text =
                                  (double.parse(realController.text) / euro!)
                                      .toStringAsFixed(2);
                              bitcoinController.text =
                                  (double.parse(realController.text) / btc!)
                                      .toStringAsFixed(6);
                            }
                          },
                          prefix: 'R\$ ',
                        ),
                        Divider(),
                        CustomTextField(
                          controller: dolarController,
                          label: 'Dólares',
                          onChanged: (_) {
                            if (dolarController.text == '' ||
                                dolarController.text.split('')[0] == '.') {
                              realController.text = (double.parse('0') / dolar!)
                                  .toStringAsFixed(2);
                              euroController.text = (double.parse('0') / euro!)
                                  .toStringAsFixed(2);
                              bitcoinController.text =
                                  (double.parse('0') / btc!).toString();
                            } else {
                              realController.text =
                                  (double.parse(dolarController.text) * dolar!)
                                      .toStringAsFixed(2);
                              euroController.text =
                                  (double.parse(realController.text) / euro!)
                                      .toStringAsFixed(2);
                              bitcoinController.text =
                                  (double.parse(realController.text) / btc!)
                                      .toStringAsFixed(6);
                            }
                          },
                          prefix: '\$ ',
                        ),
                        Divider(),
                        CustomTextField(
                          controller: euroController,
                          label: 'Euro',
                          prefix: '€ ',
                          onChanged: (_) {
                            if (euroController.text == '' ||
                                euroController.text.split('')[0] == '.') {
                              realController.text = (double.parse('0') / dolar!)
                                  .toStringAsFixed(2);
                              dolarController.text = (double.parse('0') / euro!)
                                  .toStringAsFixed(2);
                              bitcoinController.text =
                                  (double.parse('0') / btc!).toString();
                            } else {
                              realController.text =
                                  (double.parse(euroController.text) * euro!)
                                      .toStringAsFixed(2);
                              dolarController.text =
                                  (double.parse(realController.text) / dolar!)
                                      .toStringAsFixed(2);
                              bitcoinController.text =
                                  (double.parse(realController.text) / btc!)
                                      .toStringAsFixed(6);
                            }
                          },
                        ),
                        Divider(),
                        CustomTextField(
                          controller: bitcoinController,
                          label: 'Bitcoin',
                          prefix: '₿  ',
                          onChanged: (_) {
                            if (bitcoinController.text == '' ||
                                bitcoinController.text.split('')[0] == '.') {
                              dolarController.text =
                                  (double.parse('0') / dolar!)
                                      .toStringAsFixed(2);
                              euroController.text = (double.parse('0') / euro!)
                                  .toStringAsFixed(2);
                              realController.text =
                                  (double.parse('0') / btc!).toString();
                            } else {
                              realController.text =
                                  (double.parse(bitcoinController.text) * btc!)
                                      .toStringAsFixed(2);
                              dolarController.text =
                                  (double.parse(realController.text) / dolar!)
                                      .toStringAsFixed(2);
                              euroController.text =
                                  (double.parse(realController.text) / euro!)
                                      .toStringAsFixed(2);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
