import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milvikapp/model/Country.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'dart:convert';

class ChooseCountry extends StatefulWidget {
  @override
  _ChooseCountryState createState() => _ChooseCountryState();
}

class _ChooseCountryState extends State<ChooseCountry> {
  TextEditingController editingController = TextEditingController();
  List<Country> countryList = List();
  List<Country> filteredCountryList = List();
  bool showSpinner = true;

  @override
  void initState() {
    super.initState();
    loadCountry().then((value) => {
          setState(() {
            countryList = value;
            filteredCountryList = value;
            showSpinner = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // 2
          title: Text('Choose Country'),
        ),
        // 3
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        filteredCountryList = countryList
                            .where((element) => (element.name
                                .toLowerCase()
                                .contains(value.toLowerCase())))
                            .toList();
                      });
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: filteredCountryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(
                                    context, filteredCountryList[index].code);
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 50,
                                        height: 40,
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/flags/${filteredCountryList[index].flagUri}.png',
                                            ))),
                                    Expanded(
                                        child: Text(
                                            filteredCountryList[index].name,
                                            style: TextStyle(fontSize: 14))),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          filteredCountryList[index].code,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(fontSize: 14)),
                                    ))
                                  ]),
                            ),
                            Divider(color: Colors.black),
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  Future<List<Country>> loadCountry() async {
    List<Country> myList = List();
    String jsonString = await _loadACountryAsset();
    final jsonResponse = json.decode(jsonString);
    for (var i = 0; i < jsonResponse.length; i++) {
      myList.add(new Country.fromJson(jsonResponse[i]));
    }
    return myList;
  }

  Future<String> _loadACountryAsset() async {
    return await rootBundle.loadString('assets/countries.json');
  }
}
