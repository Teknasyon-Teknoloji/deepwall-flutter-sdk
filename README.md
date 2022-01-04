# DeepWall (flutter sdk)

* This package gives' wrapper methods for deepwall sdks. [iOS](https://github.com/Teknasyon-Teknoloji/deepwall-ios-sdk) - [Android](https://github.com/Teknasyon-Teknoloji/deepwall-android-sdk)

* Before implementing this package, you need to have **api_key** and list of **actions**.

* You can get api_key and actions from [DeepWall Dashboard](https://console.deepwall.com/)


---


## Getting started

Add below code into your `pubspec.yaml` file under `dependencies` section.

```yml
deepwall_flutter_plugin:
    git:
      url: https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk.git
      ref: 1.4.1
```

And run `$ flutter pub get`


### Installation Notes
- **IOS**
    - Set minimum ios version 10.0 or higher in `ios/Podfile` like: `platform :ios, '10.0'`
    - Add `use_frameworks!` into `ios/Podfile` if not exists.
    - Run `$ cd ios && pod install`

- **ANDROID**
    - Set kotlin_version "1.4.32" or higher in `android/build.gradle`
    - Set `minSdkVersion` to 21 or higher in `android/app/build.gradle`
    - Add `maven { url 'https://raw.githubusercontent.com/Teknasyon-Teknoloji/deepwall-android-sdk/master/' }` into `android/build.gradle` (Add into repositories under allprojects)


---


## Usage

### Let's start

- On application start you need to initialize sdk with api key and environment.
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.initialize('{API_KEY}', Environment.PRODUCTION.value);
```

- Before requesting any paywall you need to set UserProperties (device uuid, country, language). [See all parameters](https://github.com/Teknasyon-Teknoloji/deepwall-ios-sdk#configuration)
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.setUserProperties('UNIQUE_DEVICE_ID_HERE (UUID)', 'en-us', 'us');
```

- After setting userProperties, you are ready for requesting paywall with an action key. You can find action key in DeepWall dashboard.
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.requestPaywall('{ACTION_KEY}', null);

// You can send extra parameter if needed as below
Map<String, Object> extraData = new HashMap();
extraData['sliderIndex'] = 2;
extraData['title'] = 'Deepwall';
DeepwallFlutterPlugin.requestPaywall('{ACTION_KEY}', extraData);
```

- You can also close paywall.
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.closePaywall();
```

- When any of userProperties is changed, you need to call updateUserProperties method. (For example if user changed application language)
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.updateUserProperties('fr-fr','fr');
```

- You can validate receipts like below.
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.validateReceipt('{API_KEY}', ReceiptValidationType.RESTORE.value);
```


### Events

- There is also bunch of events triggering before and after DeepWall Actions. You may listen any event like below.
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

StreamSubscription subscribeToStream =
    DeepwallFlutterPlugin.eventBus.on<DeepwallFlutterEvent>().listen((event) {
        // // access event.data
    });
```

- Adding and removing event listener example
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

StreamSubscription subscribeToStream =
    DeepwallFlutterPlugin.eventBus.on<DeepwallFlutterEvent>().listen((event) {
        // // access event.data
    });

subscribeToStream.cancel();
```


### iOS Only Methods

- Requesting ATT Prompts
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.requestAppTracking('{ACTION_KEY}', null);

// You can send extra parameter if needed as below
Map<String, Object> extraData = new HashMap();
extraData['appName'] = 'My awesome app';
DeepwallFlutterPlugin.requestAppTracking('{ACTION_KEY}', extraData);
```

- Sending extra data to paywall while it's open.
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

Map<String, Object> extraData = new HashMap();
extraData['appName'] = 'My awesome app';
DeepwallFlutterPlugin.sendExtraDataToPaywall('{ACTION_KEY}', extraData);
```


### Android Only Methods

- For consumable products, you need to mark the purchase as consumed for consumable product to be purchased again.
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.consumeProduct('consumable_product_id');
```

- Use `setProductUpgradePolicy` method to set the product upgrade policy for Google Play apps.
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.setProductUpgradePolicy(
  ProrationMode.IMMEDIATE_WITHOUT_PRORATION.value,
  Policy.ENABLE_ALL_POLICIES.value
);
```

- Use `updateProductUpgradePolicy` method to update the product upgrade policy within the app workflow before requesting paywalls.
```dart
import 'package:deepwall_flutter_plugin/deepwall_flutter_plugin.dart';

DeepwallFlutterPlugin.updateProductUpgradePolicy(
  ProrationMode.IMMEDIATE_WITHOUT_PRORATION.value,
  Policy.ENABLE_ALL_POLICIES.value
);
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
    - phoneNumber
    - emailAddress
    - firstName
    - lastName
