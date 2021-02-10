# DeepWall (deepwall_flutter_plugin)

* This package gives wrapper methods for deepwall sdks. [iOS](https://github.com/Teknasyon-Teknoloji/deepwall-ios-sdk) - [Android](https://github.com/Teknasyon-Teknoloji/deepwall-android-sdk)

* Before implementing this package, you need to have **api_key** and list of **actions**.

* You can get api_key and actions from [DeepWall Dashboard](https://console.deepwall.com/)


---


## Getting started

Add below code into your `pubspec.yaml` file under `dependencies` section.

```yml
deepwall_flutter_plugin:
    git:
      url: https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk.git
```


## Installation Notes
- Flutter version must be `>=1.20.0`

- **IOS**
  - Set minimum ios version to 10.0 in `ios/Podfile` like: `platform :ios, '10.0'`
  - Add `use_frameworks!` into `ios/Podfile` if not exists.
  - Run `$ cd ios && pod install`

- **ANDROID**
  - Set `minSdkVersion` to  21 in `android/build.gradle`
  - Add `maven { url 'https://raw.githubusercontent.com/Teknasyon-Teknoloji/deepwall-android-sdk/master/' }` into `android/build.gradle` (Add into repositories under allprojects)


---


## Usage

- On application start you need to initialize sdk with api key and environment.
```dart
import​ ​'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart'​;

DeepwallFlutterPlugin.initialize(​'API_KEY'​, Environment.PRODUCTION.value);
```

- Before requesting any paywall you need to set UserProperties (device uuid, country, language). [See all parameters](https://github.com/Teknasyon-Teknoloji/deepwall-ios-sdk#configuration)
```dart
import​ ​'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart'​;

DeepwallFlutterPlugin.setUserProperties(​'UNIQUE_DEVICE_ID_HERE (UUID)'​,​'en-us'​,​'us'​);
```


- After setting userProperties, you are ready for requesting paywall with an action name. You can find action name in DeepWall dashboard.
```dart
DeepwallFlutterPlugin.requestPaywall(​'AppLaunch'​, null​);

// or you can send extra parameters as:
Map​<​String​, ​Object​> extraData = ​new​ HashMap(); userProperties[​'key'​] = ​'Value'​;
DeepwallFlutterPlugin.requestPaywall(​'AppLaunch'​, extraData);
```

- You can also close paywall.
```dart
DeepwallFlutterPlugin.closePaywall();
```


- If any of userProperties is changed you need to call updateUserProperties method. (For example if user changed application language)
```dart
DeepwallFlutterPlugin.updateUserProperties(​'fr-fr'​,​'fr'​);
```

- There is also bunch of events triggering before and after DeepWall Actions. You may listen any events like below.
```dart
StreamSubscription subscribeToStream =
    DeepwallFlutterPlugin.eventBus.on<DeepwallFlutterEvent>().listen((event) {
        // // access event.data
    });
```

- Adding and removing event listener example
```dart
StreamSubscription subscribeToStream =
    DeepwallFlutterPlugin.eventBus.on<DeepwallFlutterEvent>().listen((event) {
        // // access event.data
    });

subscribeToStream.cancel();
```

---


## Notes
- You may found complete list of **events** in [lib/enums/events.dart](./lib/enums/events.dart) or [Native Sdk Page](https://github.com/Teknasyon-Teknoloji/deepwall-ios-sdk#event-handling)
- **UserProperties** are:
    - uuid
    - country
    - language
    - environmentStyle
    - debugAdvertiseAttributions

