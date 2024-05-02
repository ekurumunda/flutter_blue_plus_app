import 'package:flutter/material.dart';
import 'package:flutter_blue_plus_app/form.dart';
import 'package:flutter_blue_plus_app/main.dart';

class Details extends StatelessWidget {
  Details({Key? key, required this.contactName, required this.contactNum})
      : super(key: key);

  String contactName;
  String contactNum;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Contacts'),
            backgroundColor: Colors.cyan,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios))),
        body: Container(
            child: ListView(
          children: [
            ListTile(
                leading: Icon(Icons.contact_emergency),
                title: Text(contactName),
                subtitle: Text(contactNum)),
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Edit contact information')),
          ],
        )));
  }
}
