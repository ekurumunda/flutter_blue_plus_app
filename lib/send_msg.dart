import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus_app/main.dart';
import 'package:flutter_sms/flutter_sms.dart';

import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../call_funct.dart';

// class MyCall extends StatefulWidget {
//   const MyCall({super.key, required this.title});
//   final String title;

//   @override
//   State<MyCall> createState() => _MyCallState();
// }

// class _MyCallState extends State<MyCall> {
//   bool _hasCallSupport = false;
//   Future<void>? _launched;
//   String _phone = '19144817390';

//   @override
//   void initState() {
//     super.initState();
//     // Check for phone call support.
//     canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
//       setState(() {
//         _hasCallSupport = result;
//       });
//     });
//   }

//   Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
//     if (snapshot.hasError) {
//       return Text('Error: ${snapshot.error}');
//     } else {
//       return const Text('19144629023');
//     }
//   }

//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     await launchUrl(launchUri);
//   }

//   @override
//   Widget build(BuildButton) {
//     // onPressed calls using this URL are not gated on a 'canLaunch' check
//     // because the assumption is that every device can launch a web URL.

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: ListView(
//         children: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: _hasCallSupport
//                     ? () => setState(() {
//                           _launched = _makePhoneCall(_phone);
//                         })
//                     : null,
//                 child: _hasCallSupport
//                     ? const Text('Make phone call')
//                     : const Text('Calling not supported'),
//               ),
//               const Padding(padding: EdgeInsets.all(16.0)),
//               FutureBuilder<void>(future: _launched, builder: _launchStatus),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class MyText extends StatefulWidget {
  /// MyText(this.contactName, this.contactNum);
  MyText({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyTextState();
  }
  //_MyTextState createState() => _MyTextState();
}

class _MyTextState extends State<MyText> {
  late TextEditingController _controllerPeople, _controllerMessage;

  String? _message, body;
  String _canSendSMSMessage = 'Check is not run.';
  List<String> people = [contactObj.contactNum];
  // List<String> num = [];
  bool sendDirect = false;

  @override
  void initState() {
    //people.add(widget.contactName);
    // num.add(widget.contactNum);
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _controllerPeople = TextEditingController();
    _controllerMessage = TextEditingController();
  }

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message:
            'Hi ${contactObj.contactName}, a fall was detected. Check in to make sure they are okay.', //_controllerMessage.text,
        recipients: [contactObj.contactNum], // recipients,
        sendDirect: sendDirect,
      );
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  Future<bool> _canSendSMS() async {
    bool _result = await canSendSMS();
    setState(() => _canSendSMSMessage =
        _result ? 'This unit can send SMS' : 'This unit cannot send SMS');
    return _result;
  }

  Widget _phoneTile(String name) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
            top: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
            right: BorderSide(color: Colors.grey.shade300),
          )),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => people.remove(name)),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    name,
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text('Fall Detection', style: style),
            backgroundColor: Colors.cyan,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios))),
        body: ListView(
          children: <Widget>[
            //
            //
            // Send for help
            //
            //

            Expanded(
              child: SizedBox(
                height: 350,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.cyan[100]),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.white, width: 4.0),
                    )),
                  ),
                  onPressed: () {
                    _send();
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.send,
                          size: 40.0,
                        ),
                        Text(
                          'Send Help',
                          textAlign: TextAlign.center,
                        )
                      ]),
                ),
              ),
            ),
            //
            //
            // Call for help
            //
            //
            Expanded(
              child: SizedBox(
                height: 350,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.cyan[100]),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.white, width: 4.0),
                    )),
                  ),
                  onPressed: () {
                    _MyCallState()._makePhoneCall(contactObj.contactNum);
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.call, size: 40.0),
                        Text(
                          'Call Help',
                        )
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send() {
    if (people.isEmpty) {
      setState(() => _message = 'At Least 1 Person or Message Required');
    } else {
      _sendSMS(people);
    }
  }
}
///////
///
///
///
///
///
///
///
///
///
///
///
///
///Copy paste call code
///// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

class MyCall extends StatefulWidget {
  const MyCall({super.key, required this.title});
  final String title;

  @override
  State<MyCall> createState() => _MyCallState();
}

class _MyCallState extends State<MyCall> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = contactObj.contactNum;

  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return Text(_phone);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildButton) {
    // onPressed calls using this URL are not gated on a 'canLaunch' check
    // because the assumption is that every device can launch a web URL.

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _hasCallSupport
                    ? () => setState(() {
                          _launched = _makePhoneCall(_phone);
                        })
                    : null,
                child: _hasCallSupport
                    ? const Text('Make phone call')
                    : const Text('Calling not supported'),
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
              FutureBuilder<void>(future: _launched, builder: _launchStatus),
            ],
          ),
        ],
      ),
    );
  }
}
