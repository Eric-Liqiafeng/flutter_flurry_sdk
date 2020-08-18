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
      androidKey: "androidKey",
      iosKey: "iosKey",
      performanceMetrics: true,
      enableLog: true,
    );
    await FlutterFlurrySdk.setUserId("user1234");
    await FlutterFlurrySdk.logEvent("open_app");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Flurry SDK example'),
        ),
        body: Center(
          child: Text('Example'),
        ),
      ),
    );
  }
}
