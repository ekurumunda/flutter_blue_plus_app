//

////COPY AND PASTED:
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import "../utils/snackbar.dart";

import "descriptor_tile.dart";

import '../send_msg.dart';
import 'package:flutter_sms/flutter_sms.dart';
import '../fall_data_page.dart';

import '../main.dart';

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile(
      {Key? key, required this.characteristic, required this.descriptorTiles})
      : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  List<int> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription =
        widget.characteristic.lastValueStream.listen((value) {
      _value = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothCharacteristic get c => widget.characteristic;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  Future onReadPressed() async {
    try {
      await c.read();
      Snackbar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
    try {
      await c.write(_getRandomBytes(),
          withoutResponse: c.properties.writeWithoutResponse);
      Snackbar.show(ABC.c, "Write: Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

  Future onSubscribePressed() async {
    try {
      String op = c.isNotifying == false ? "Subscribe" : "Unubscribe";
      await c.setNotifyValue(c.isNotifying == false);
      Snackbar.show(ABC.c, "$op : Success", success: true);
      if (c.properties.read) {
        await c.read();
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Subscribe Error:", e),
          success: false);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.characteristic.uuid.str.toUpperCase()}';
    return Text(uuid, style: TextStyle(fontSize: 13));
  }

  int numFalls = 0;

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    String dataWord = String.fromCharCodes(_value);
    if (dataWord == 'Fall Detected') {
      numFalls += 1;
      _MyTextState().send();

      ///ADDED
      if (fallDataList.isEmpty) {
        fallDataList.add(fallData());
        MyDataState().addFallDetectedData(); // may be able to get rid of
      } else if (fallDataList.last.minute != DateTime.now().minute) {
        fallDataList.add(fallData());
        MyDataState().addFallDetectedData(); // may be able to get rid of
      }

      ///END OF ADDED STATEMENT
    } else {
      dataWord = 'No Fall';
    }
    return Text(data + dataWord + numFalls.toString(),
        style: TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
        child: Text("Read"),
        onPressed: () async {
          await onReadPressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
    return TextButton(
        child: Text(withoutResp ? "WriteNoResp" : "Write"),
        onPressed: () async {
          await onWritePressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = widget.characteristic.isNotifying;
    return TextButton(
        child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
        onPressed: () async {
          await onSubscribePressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildButtonRow(BuildContext context) {
    bool read = widget.characteristic.properties.read;
    bool write = widget.characteristic.properties.write;
    bool notify = widget.characteristic.properties.notify;
    bool indicate = widget.characteristic.properties.indicate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        if (notify || indicate) buildSubscribeButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Characteristic'),
            buildUuid(context),
            buildValue(context),
            FloatingActionButton(onPressed: () {
              fallDataList.add(fallData());
              MyDataState().addFallDetectedData();
            })
          ],
        ),
        subtitle: buildButtonRow(context),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: widget.descriptorTiles,
    );
  }
}

///////
///
///
///
///
///
///
///Copy pasted:
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Fall Detection'),
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
            // Fall detection data
            //
            //
            SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                height: 230,
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
                    send();
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.data_thresholding,
                          size: 40.0,
                        ),
                        Text(
                          'Fall Detection Data',
                          textAlign: TextAlign.center,
                        )
                      ]),
                ),
              ),
            ),
            //
            //
            // Send for help
            //
            //

            Expanded(
              child: SizedBox(
                height: 230,
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
                    send();
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
                height: 230,
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
                    send();
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

  void send() {
    if (people.isEmpty) {
      setState(() => _message = 'At Least 1 Person or Message Required');
    } else {
      _sendSMS(people);
    }
  }
}

//////
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
///AGAIN copy and pasted fall data page

// class MyData extends StatefulWidget {
//   MyData({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _MyDataState();
//   }
// }

// class _MyDataState extends State<MyData> {
//   var dataDictionary = {};

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void addFallDetectedData() {
//     setState(() {});
//   }

//   Map _makeDictionary() {
//     for (fallData x in fallDataList) {
//       dataDictionary[x.fallDay] = 0;
//     }
//     for (fallData x in fallDataList) {
//       dataDictionary[x.fallDay] += 1;
//     }
//     return dataDictionary;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final style = theme.textTheme.displaySmall!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('Fall Data', style: style),
//         backgroundColor: Colors.cyan,
//       ),
//       body: ListView.builder(
//           itemCount: fallDataList.length,
//           itemBuilder: (context, index) {
//             return listSquare(
//                 child: 'Fall Detected on ${fallDataList[index].fallDay}');
//           }),
//       floatingActionButton: FloatingActionButton(onPressed: () {
//         fallDataList.add(fallData());
//         setState(() {});
//       }),
//     );
//   }
// }

// class listSquare extends StatelessWidget {
//const listSquare({super.key});
//   final String child;
//   listSquare({required this.child});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Container(
//             height: 70,
//             color: Colors.cyan[100],
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Text(
//                 child,
//                 textAlign: TextAlign.justify,
//                 style: TextStyle(fontSize: 20),
//               ),
//             )));
//   }
// }
