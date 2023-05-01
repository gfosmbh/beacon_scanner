import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('plugins.lukangagames.com/beacon_scanner_android');

/// An implementation of [BeaconScannerPlatform] for Android.
class BeaconScannerAndroid extends BeaconScannerPlatform {
  /// Registers this class as the default instance of [BeaconScannerPlatform].
  static void registerWith() {
    BeaconScannerPlatform.instance = BeaconScannerAndroid();
  }
}
