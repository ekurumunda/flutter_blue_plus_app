import 'package:flutter/material.dart';
import 'package:flutter_blue_plus_app/main.dart';
import 'dart:convert';

class MyData extends StatefulWidget {
  MyData({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyDataState();
  }
}

class MyDataState extends State<MyData> {
  var dataDictionary = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addFallDetectedData() {
    setState(() {});
  }

  Map _makeDictionary() {
    for (fallData x in fallDataList) {
      dataDictionary[x.fallDay] = 0;
    }
    for (fallData x in fallDataList) {
      dataDictionary[x.fallDay] += 1;
    }
    return dataDictionary;
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
        title: Text('Fall Data', style: style),
        backgroundColor: Colors.cyan,
      ),
      body: ListView.builder(
          itemCount: fallDataList.length,
          itemBuilder: (context, index) {
            return listSquare(
                child: 'Fall Detected on ${fallDataList[index].fallDay}');
          }),
    );
  }
}

class listSquare extends StatelessWidget {
  //const listSquare({super.key});
  final String child;
  listSquare({required this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            height: 70,
            color: Colors.cyan[100],
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                child,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20),
              ),
            )));
  }
}
