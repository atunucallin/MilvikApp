import 'dart:convert';

import 'package:milvikapp/model/contacts.dart';

import 'package:http/http.dart' as http;

class Webservice {
  Future<List<Contacts>> fetchContacts() async {
    final url = "https://5efdb0b9dd373900160b35e2.mockapi.io/contacts";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((contact) => Contacts.fromJson(contact)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }
}
