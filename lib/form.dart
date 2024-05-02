import 'package:flutter_blue_plus_app/form_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus_app/main.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var _contactName;
  var _contactNum;
  final _contactController = TextEditingController();
  final _contactNumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contactController.addListener(_updateText);
  }

  @override
  void dispose() {
    _contactController.dispose();
    _contactNumController.dispose();

    super.dispose();
  }

  void _addContact(Contact c) {
    setState(() {});
  }

  void _updateText() {
    setState(() {
      _contactName = _contactController.text;
      _contactNum = _contactNumController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(' Contact Info', style: style),
          backgroundColor: Colors.cyan,
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: [
                //

                //
                TextFormField(
                    controller: _contactController,
                    decoration: InputDecoration(
                      labelText: "Contact Name:",
                      border: OutlineInputBorder(),
                      //icon: Icon(Icons.contact_emergency_sharp)
                    )),

                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  controller: _contactNumController,
                  decoration: InputDecoration(
                    labelText: "Contact Phone Number:",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                // Text(
                //     "Contact name is ${_contactController.text} and number is ${_contactNumController.text}"),
                OutlinedButton(
                    onPressed: () {
                      contactObj.contactName = _contactController.text;
                      contactObj.contactNum = _contactNumController.text;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Details(
                          contactName: contactObj.contactName,
                          contactNum: contactObj.contactNum,
                        );
                      }));
                    },
                    child: Text('Submit')),
                //myBtn(context),
                SizedBox(
                  height: 15.0,
                ),
                OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Details(
                          contactName: contactObj.contactName,
                          contactNum: contactObj.contactNum,
                        );
                      }));
                    },
                    child: Text('View Contact Information')),
              ],
            )));
  }

  OutlinedButton myBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Details(
            contactName: _contactController.text,
            contactNum: _contactNumController.text,
          );
        }));
      },
      child: Text('Submit'),
    );
  }
}
