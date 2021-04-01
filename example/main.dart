import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';
import 'package:deepwall_flutter_plugin/enums/environments.dart';
import 'package:deepwall_flutter_plugin/enums/events.dart';
// import 'package:deepwall_flutter_plugin/enums/environmentstyles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    StreamSubscription streamSubscriber;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      streamSubscriber = DeepwallFlutterPlugin.eventBus
          .on<DeepwallFlutterEvent>()
          .listen((event) {
        print(event.event.value);
        print(event.data);
      });

      DeepwallFlutterPlugin.initialize('API_KEY', Environment.SANDBOX.value);

      DeepwallFlutterPlugin.setUserProperties(
          'unique-device-id-here', 'en', 'us');

      // Future.delayed(Duration(milliseconds: 5000), () {
      //   DeepwallFlutterPlugin.closePaywall();
      // });
    } on Exception {
      print('Failed to connect deepwall.');
      streamSubscriber.cancel();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Deepwall example app'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Open Paywall'),
            onPressed: () {
              DeepwallFlutterPlugin.requestPaywall('AppLaunch', null);
            },
          ),
        ),
      ),
    );
  }
}
