import 'package:flutter/cupertino.dart';
import 'package:milvikapp/model/contacts.dart';
import 'package:milvikapp/services/webservice.dart';

class ContactListViewModel extends ChangeNotifier {
  ContactListViewModel() {
    fetchContacts();
  }

  List<Contacts> contacts = List<Contacts>();

  Future<void> fetchContacts() async {
    contacts = await Webservice().fetchContacts();
    print(this.contacts);
    notifyListeners();
  }
}
