import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flurry_sdk/flutter_flurry_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initFlurry();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initFlurry() async {
    await FlutterFlurrySdk.initialize(
      androidKey: "ZC5X9XP66T8N3VR7HNR4",
      iosKey: "CJDG53T7VX9KHZMPNB7Q",
      performanceMetrics: true,
      enableLog: true,
    );
    await FlutterFlurrySdk.setUserId("1234");
    await FlutterFlurrySdk.logEvent("testflurry");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Flurry analytics example.'),
        ),
      ),
    );
  }
}
