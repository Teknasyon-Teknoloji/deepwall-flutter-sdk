import 'dart:async';
import 'package:flutter/material.dart';
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';
import 'package:deepwall_flutter_plugin/enums/environments.dart';
import 'package:deepwall_flutter_plugin/enums/events.dart';
import 'package:deepwall_flutter_plugin/enums/device_orientations.dart';
// import 'package:deepwall_flutter_plugin/enums/environmentstyles.dart';

const String apiKey = "XXXXX";
const String paywallAction = "AppLaunch";
const String deviceId = "unique-device-id-here-00001";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
    late StreamSubscription streamSubscriber;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      streamSubscriber = DeepwallFlutterPlugin.eventBus
          .on<DeepwallFlutterEvent>()
          .listen((event) {
        // ignore: avoid_print
        print(event.event.value);
        // ignore: avoid_print
        print(event.data);
      });

      DeepwallFlutterPlugin.initialize(apiKey, Environment.SANDBOX.value);

      DeepwallFlutterPlugin.setUserProperties(
        deviceId,
        'fr',
        'en-en',
      );

      // Future.delayed(Duration(milliseconds: 5000), () {
      //   DeepwallFlutterPlugin.closePaywall();
      // });
    } on Exception {
      // ignore: avoid_print
      print('Failed to connect deepwall.');
      streamSubscriber.cancel();
    }

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
            child: const Text('Open Paywall'),
            onPressed: () {
              DeepwallFlutterPlugin.requestPaywall(paywallAction, null);

              /*
              DeepwallFlutterPlugin.requestPaywall(paywallAction, null,
                  orientation: DeviceOrientations.PORTRAIT.value);
              */
            },
          ),
        ),
      ),
    );
  }
}
