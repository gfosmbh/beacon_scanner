# beacon_scanner

This plugin is based on [flutter_beacon](https://pub.dev/packages/flutter_beacon) by Eyro Labs.
This package can be combined with androids foreground services.
It uses Android AltBeacon and iOS CoreLocation under the hood.

An hybrid iBeacon scanner SDK for Flutter plugin. Supports Android API 18+ and iOS 8+.

Features:

* Automatic permission management
* Ranging iBeacons
* Monitoring iBeacons

## Installation

Add to pubspec.yaml:

```yaml
dependencies:
  flutter_beacon: latest
```

### Setup specific for Android

For target SDK version 29+ (Android 10, 11) is necessary to add manually ```ACCESS_FINE_LOCATION```

``` 
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

and if you want also background scanning:
```
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

### Setup specific for iOS

Works only for 13+.
In order to use beacons related features, apps are required to ask the location permission. It's a two step process:

1. Declare the permission the app requires in configuration files
2. Request the permission to the user when app is running (the plugin can handle this automatically)

The needed permissions in iOS is `when in use`.

For more details about what you can do with each permission, see:  
https://developer.apple.com/documentation/corelocation/choosing_the_authorization_level_for_location_services

Permission must be declared in `ios/Runner/Info.plist`:

```xml
<dict>
  <!-- When in use -->
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>Reason why app needs location</string>
  <!-- Always -->
  <!-- for iOS 11 + -->
  <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
  <string>Reason why app needs location</string>
  <!-- for iOS 9/10 -->
  <key>NSLocationAlwaysUsageDescription</key>
  <string>Reason why app needs location</string>
  <!-- Bluetooth Privacy -->
  <!-- for iOS 13 + -->
  <key>NSBluetoothAlwaysUsageDescription</key>
  <string>Reason why app needs bluetooth</string>
</dict>
```

## iOS Troubleshooting

* Example code works properly only on **physical device** (bluetooth on simulator is disabled)
* How to deploy flutter app on iOS device [Instruction](https://flutter.dev/docs/get-started/install/macos)
* If example code don't works on device (beacons not appear), please make sure that you have enabled <br/> Location and Bluetooth (Settings -> Flutter Beacon)

## How-to

Ranging APIs are designed as reactive streams.

* The first subscription to the stream will start the ranging

### Initializing Library

```dart
final BeaconScanner beaconScanner = BeaconScanner.instance;

try {
  // false - if you want to manage manual checking about the required permissions
  await beaconScanner.initialize(true);
} on PlatformException catch(e) {
  // library failed to initialize, check code and message
}
```

### Ranging beacons

```dart
final regions = <Region>[];

if (Platform.isIOS) {
  // iOS platform, at least set identifier and proximityUUID for region scanning
  regions.add(Region(
      identifier: 'Apple Airlocate',
      beaconId: IBeaconId(proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'),
  ));
} else {
  // android platform, it can ranging out of beacon that filter all of Proximity UUID
  regions.add(Region(identifier: 'com.beacon'));
}

// to start ranging beacons
_streamRanging = beaconScanner.ranging(regions).listen((ScanResult result) {
  // result contains a region and list of beacons found
  // list can be empty if no matching beacons were found in range
});

// to stop ranging beacons
_streamRanging.cancel();
```

### Monitoring beacons

```dart
final regions = <Region>[];

if (Platform.isIOS) {
// iOS platform, at least set identifier and proximityUUID for region scanning
regions.add(Region(
identifier: 'Apple Airlocate',
beaconId: IBeaconId(proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'),
));
} else {
// Android platform, it can ranging out of beacon that filter all of Proximity UUID
regions.add(Region(identifier: 'com.beacon'));
}

// to start monitoring beacons
// even works when app is closed on iOS
_streamMonitoring = beaconScanner.monitoring(regions).listen((MonitoringResult result) {
// result contains a region, event type and event state
});

// to stop monitoring beacons
_streamMonitoring.cancel();
```

