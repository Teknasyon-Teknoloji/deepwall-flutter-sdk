import 'package:deepwall_flutter_plugin/enums/environments.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('deepwall_flutter_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('initialize', () async {
    DeepwallFlutterPlugin.initialize('API_KEY', Environment.SANDBOX.value);
    //expect(await DeepwallFlutterPlugin.platformVersion, '42');
  });
}
