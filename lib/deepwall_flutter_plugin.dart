import 'dart:async';

import 'package:deepwall_flutter_plugin/enums/errorcodes.dart';
import 'package:deepwall_flutter_plugin/enums/events.dart';
import 'package:flutter/services.dart';
import 'package:event_bus/event_bus.dart';

class DeepwallFlutterEvent {
  Event event;
  dynamic data;

  DeepwallFlutterEvent(this.event, this.data);
}

class DeepwallFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('deepwall_flutter_plugin');

  static const EventChannel _eventChannel =
      const EventChannel('deepwall_plugin_stream');

  static EventBus eventBus = EventBus();

  constructor() {}

  static void initialize(apiKey, environment) async {
    initEvents();
    await _channel.invokeMethod(
        'initialize', {"apiKey": apiKey, "environment": environment});
  }

  static void initEvents() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      // Custom Flutter Listener with event name
      final Map<dynamic, dynamic> map = event;
      if (map.containsKey('event')) {
        if (map['event'] == Event.PAYWALL_REQUESTED.value) {
          eventBus.fire(
              new DeepwallFlutterEvent(Event.PAYWALL_REQUESTED, map['data']));
        } else if (map['event'] == Event.PAYWALL_RESPONSE_RECEIVED.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_RESPONSE_RECEIVED, map['data']));
        } else if (map['event'] == Event.PAYWALL_RESPONSE_FAILURE.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_RESPONSE_FAILURE, map['data']));
        } else if (map['event'] == Event.PAYWALL_OPENED.value) {
          eventBus.fire(
              new DeepwallFlutterEvent(Event.PAYWALL_OPENED, map['data']));
        } else if (map['event'] == Event.PAYWALL_NOT_OPENED.value) {
          eventBus.fire(
              new DeepwallFlutterEvent(Event.PAYWALL_NOT_OPENED, map['data']));
        } else if (map['event'] == Event.PAYWALL_ACTION_SHOW_DISABLED.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_ACTION_SHOW_DISABLED, map['data']));
        } else if (map['event'] == Event.PAYWALL_CLOSED.value) {
          eventBus.fire(
              new DeepwallFlutterEvent(Event.PAYWALL_CLOSED, map['data']));
        } else if (map['event'] == Event.PAYWALL_EXTRA_DATA_RECEIVED.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_EXTRA_DATA_RECEIVED, map['data']));
        } else if (map['event'] == Event.PAYWALL_PURCHASING_PRODUCT.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_PURCHASING_PRODUCT, map['data']));
        } else if (map['event'] == Event.PAYWALL_PURCHASE_SUCCESS.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_PURCHASE_SUCCESS, map['data']));
        } else if (map['event'] == Event.PAYWALL_PURCHASE_FAILED.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_PURCHASE_FAILED, map['data']));
        } else if (map['event'] == Event.PAYWALL_RESTORE_SUCCESS.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_RESTORE_SUCCESS, map['data']));
        } else if (map['event'] == Event.PAYWALL_RESTORE_FAILED.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_RESTORE_FAILED, map['data']));
        } else if (map['event'] == Event.PAYWALL_CONSUME_SUCCESS.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_CONSUME_SUCCESS, map['data']));
        } else if (map['event'] == Event.PAYWALL_CONSUME_FAILURE.value) {
          eventBus.fire(new DeepwallFlutterEvent(
              Event.PAYWALL_CONSUME_FAILURE, map['data']));
        }
      }
    });
  }

  static void setUserProperties(uuid, country, language,
      {environmentStyle: 0, debugAdvertiseAttributions: null}) async {
    if (uuid.isEmpty) {
      throw new DeepwallException(ErrorCode.USER_PROPERTIES_UUID_REQUIRED);
    }
    if (country.isEmpty) {
      throw new DeepwallException(ErrorCode.USER_PROPERTIES_COUNTRY_REQUIRED);
    }
    if (language.isEmpty) {
      throw new DeepwallException(ErrorCode.USER_PROPERTIES_LANGUAGE_REQUIRED);
    }
    await _channel.invokeMethod('setUserProperties', {
      "uuid": uuid,
      "country": country,
      'language': language,
      'environmentStyle': environmentStyle,
      'debugAdvertiseAttributions': debugAdvertiseAttributions
    });
  }

  static void requestPaywall(actionKey, extraData) async {
    _channel.invokeMethod(
        'requestPaywall', {"actionKey": actionKey, 'extraData': extraData});
  }

  static void requestAppTracking(actionKey, extraData) async {
    _channel.invokeMethod(
        'requestAppTracking', {"actionKey": actionKey, 'extraData': extraData});
  }

  static void sendExtraDataToPaywall(extraData) async {
    _channel.invokeMethod('requestAppTracking', {'extraData': extraData});
  }

  static void updateUserProperties(country, language,
      {environmentStyle: 0, debugAdvertiseAttributions: null}) async {
    await _channel.invokeMethod('updateUserProperties', {
      "country": country,
      'language': language,
      'environmentStyle': environmentStyle,
      'debugAdvertiseAttributions': debugAdvertiseAttributions
    });
  }

  static void closePaywall() async {
    await _channel.invokeMethod('closePaywall');
  }

  static void hidePaywallLoadingIndicator() async {
    await _channel.invokeMethod('hidePaywallLoadingIndicator');
  }

  static void validateReceipt(type) async {
    await _channel.invokeMethod('validateReceipt', {'validationType': type});
  }

  static void consumeProduct(productId) async {
    await _channel.invokeMethod('consumeProduct', {'productId': productId});
  }

  static void setProductUpgradePolicy(prorationType, upgradePolicy) async {
    await _channel.invokeMethod('setProductUpgradePolicy',
        {'prorationType': prorationType, 'upgradePolicy': upgradePolicy});
  }

  static void updateProductUpgradePolicy(prorationType, upgradePolicy) async {
    await _channel.invokeMethod('updateProductUpgradePolicy',
        {'prorationType': prorationType, 'upgradePolicy': upgradePolicy});
  }
}
