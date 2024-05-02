// Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_app/fall_data_page.dart';
import 'package:flutter_blue_plus_app/form.dart';
import 'package:flutter_blue_plus_app/send_msg.dart';

import 'screens/bluetooth_off_screen.dart';
import 'screens/scan_screen.dart';
import 'package:provider/provider.dart';

List<fallData> fallDataList = [];

var contactObj = Contact();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String contactName = '';
  final String ContactNum = '';
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Obstacle Detection Device App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  get contactName => null;

  get contactNum => null;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Object Detection', style: style),
          backgroundColor: Colors.cyan[700],
        ),
        body: Row(children: [
          Column(
            children: [
              SizedBox(width: 5),
            ],
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
//
                    // About Page
                    child: SizedBox(
                        width: 300,
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutPage()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.cyan[100]),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.white, width: 4.0),
                            )),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.telegram,
                                  size: 40.0,
                                ),
                                Text(
                                  'About',
                                  textAlign: TextAlign.center,
                                )
                              ]),
                        )),
                  ),

                  //Fall Detection Data Button
                  Expanded(
                    child: SizedBox(
                      width: 300,
                      height: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FallDataPage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.cyan[100]),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.white, width: 4),
                          )),
                        ),
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
                  //Fall Detection Button
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyText()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.cyan[100]),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.white, width: 4),
                          )),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.messenger,
                                size: 40.0,
                              ),
                              Text(
                                'Message for Help',
                                textAlign: TextAlign.center,
                              )
                            ]),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ]),
          ),

          //
          //
          // Second Column
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //
                //Emergency Contact Button
                Expanded(
                  child: SizedBox(
                    width: 300,
                    height: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmergencyContactPage()),
                        );
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.cyan[100]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.white, width: 4.0),
                        )),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.contact_emergency,
                              size: 40.0,
                            ),
                            Text(
                              'Emergency Contact \nInformation',
                              textAlign: TextAlign.center,
                            )
                          ]),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlutterBlueApp()));
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.cyan[100]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.white, width: 4),
                        )),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.bluetooth,
                              size: 40.0,
                            ),
                            Text(
                              'Bluetooth',
                              textAlign: TextAlign.center,
                            )
                          ]),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BatteryPage()),
                        );
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.cyan[100]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.white, width: 4),
                        )),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.battery_5_bar,
                              size: 40.0,
                            ),
                            Text(
                              'Battery',
                              textAlign: TextAlign.center,
                            )
                          ]),
                    ),
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
          Column(
            children: [SizedBox(width: 5)],
          )
        ]),
      );
    });
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('About', style: style),
        backgroundColor: Colors.cyan,

        //elevation: 100.0,
      ),
      body: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Text(
                  '\nThis app is designed to work with our ODA device. Our ODA device allows blind and visually impaired individuals to navigate life independently and hands free. The device is worn as a belt and vibrates in the direction of detected obstacles. This app connects with the device through bluetooth for added functions such as alerting contacts of detected falls and informing the user of battery percentages.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Container(
                  height: 70,
                  child: Text(
                    'Instructions:                                                ',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 30),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: SizedBox(
                child: Text(
                  '1) Connect the ODA device to the app by pressing the bluetooth button and selecting the "ODA Device" option. \n',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: SizedBox(
                child: Text(
                  '2) Click on the Emergency Contact button and input contact information.',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: SizedBox(
                  child: Text(
                '\n3) Navigate through lifes obstacle hands free!                                     ',
                style: TextStyle(fontSize: 15),
              )),
            ),
          ] //children
          ),
    );
  }
}

class FallDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return MyData();
  }
}

class FallDetectionPage extends StatelessWidget {
  FallDetectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return MyText();
  }
}

class EmergencyContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return MyForm();
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('Emergency Contact Information', style: style),
    //     backgroundColor: Colors.cyan,

    //     //elevation: 100.0,
    //   ),
    //   body: Column(
    //       //mainAxisSize: MainAxisSize.min,
    //       children: [
    //         ElevatedButton.icon(
    //           onPressed: () {
    //             //appState.toggleVoiceAlert();
    //           },
    //           label: Text('Speech Alert'),
    //           icon: Icon(Icons.record_voice_over),
    //         ),
    //         SizedBox(height: 20),
    //         ElevatedButton.icon(
    //           onPressed: () {
    //             // appState.toggleLocationServices();
    //           },
    //           icon: Icon(Icons.map),
    //           label: Text('Turn Location on'),
    //         ),
    //         SizedBox(height: 20),
    //         ElevatedButton.icon(
    //           onPressed: () {
    //             //setState(() {
    //             //selectedIndex = value;
    //           },
    //           icon: Icon(Icons.warning),
    //           label: Text('Turn fall detection on'),
    //         ),
    //       ] //children
    //       ),
    // );
  }
}

class BatteryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Battery', style: style),
        backgroundColor: Colors.cyan,

        //elevation: 100.0,
      ),
      body: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                //appState.toggleVoiceAlert();
              },
              label: Text('Speech Alert'),
              icon: Icon(Icons.record_voice_over),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // appState.toggleLocationServices();
              },
              icon: Icon(Icons.map),
              label: Text('Turn Location on'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                //setState(() {
                //selectedIndex = value;
              },
              icon: Icon(Icons.warning),
              label: Text('Turn fall detection on'),
            ),
          ] //children
          ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          AppBar(
            title: Text('Settings', style: style),
            backgroundColor: theme.colorScheme.primary,
            //elevation: 100.0,
          ),
          SizedBox(height: 100),
          Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  //appState.toggleVoiceAlert();
                },
                label: Text('Speech Alert'),
                icon: Icon(Icons.record_voice_over),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // appState.toggleLocationServices();
                },
                icon: Icon(Icons.map),
                label: Text('Turn Location on'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  //setState(() {
                  //selectedIndex = value;
                },
                icon: Icon(Icons.warning),
                label: Text('Turn fall detection on'),
              ),
            ],
          )
        ]);
  }
}

class BluetoothPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth', style: style),
          backgroundColor: Colors.cyan,
        ),
        body: Column(
          children: [
            Text('Connect to bluetooth'),
          ],
        ));
  }
}

/*class FallDetectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Center(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
          SizedBox(height: 100),
          Card(
              color: theme.colorScheme.primary,
              elevation: 100.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Fall Detection',
                  style: style,
                ),
              )),
          SizedBox(height: 100),
          //BigCard(pair: pair),
          //SizedBox(height: 10),
        ]));
  }
}*/

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    final style2 = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onBackground,
    );

    return Center(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          Card(
              color: theme.colorScheme.primary,
              elevation: 100.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Welcome to "Object Detection Device"',
                  style: style,
                ),
              )),
          Text(
            'Easily navigate with tools such as speech alerts, fall detectiona and GPS navigation',
            style: style2,
          )
        ],
      ),
    );
  }
}

// void main() {
//   FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
//   runApp(const FlutterBlueApp());
// }

//
// This widget shows BluetoothOffScreen or
// ScanScreen depending on the adapter state
//
class FlutterBlueApp extends StatefulWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  State<FlutterBlueApp> createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void
      initState() // method called when object inserted into tree. called once for each state object created
  {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) //checks if state object is currently in tree. It is an error to call [setState] unless [mounted] is true.
      {
        setState(() {}); // notifies framework that the state has changed
      }
    });
  }

  @override
  void dispose() //called when object removed from tree permanantly
  {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //assigns screen to ScanScreen if bluetooth on and to bluetoothOffScreen otherwise
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const ScanScreen()
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      color: Colors.lightBlue,
      home: screen,
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

//
// This observer listens for Bluetooth Off and dismisses the DeviceScreen
//
class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}

class Contact {
  String contactName = '';
  String contactNum = '';
}

class fallData {
  String fallDay =
      '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
  int minute = DateTime.now().minute;
}
