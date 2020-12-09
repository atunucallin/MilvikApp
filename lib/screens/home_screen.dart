import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milvikapp/model/contacts.dart';
import 'package:milvikapp/services/auth_services.dart';
import 'package:milvikapp/view_model/contacts_view_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // 2
          title: Text('Dashboard'),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    AuthService().signOut();
                  },
                  child: Icon(
                    Icons.more_vert,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        // 3
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: ChangeNotifierProvider(
              create: (_) => ContactListViewModel(),
              child: Container(child: Builder(builder: (context) {
                List<Contacts> vm =
                    context.select<ContactListViewModel, List<Contacts>>(
                        (f) => f.contacts);
                return ListView(
                    children: vm
                        .map((Contacts contact) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(contact.profilePic),
                              ),
                              title: Text(contact.firstName,
                                  style: TextStyle(color: Colors.black)),
                              subtitle: Text(
                                contact.description ?? "",
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: Icon(Icons.arrow_right),
                              isThreeLine: true,
                              onTap: () {
                                /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatUI(
                                      chatId: filteredChatList[index]
                                          .chatId,
                                    )));*/
                              },
                              selected: true,
                            ))
                        .toList());
              }))),
        ));
  }
}
