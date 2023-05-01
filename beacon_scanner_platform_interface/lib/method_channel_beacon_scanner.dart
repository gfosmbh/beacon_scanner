import 'package:flutter/services.dart';

import 'package:beacon_scanner_platform_interface/src/beacon_scanner_platform.dart';

import 'src/types.dart';

const MethodChannel _channel = MethodChannel('plugins.lukangagames.com/beacon_scanner');

/// An implementation of [BeaconScannerPlatform] that uses method channels.
class MethodChannelBeaconScanner extends BeaconScannerPlatform {
  @override
  Future<bool> initialize() async {
    return (await _channel.invokeMethod<bool>('initialize')) ?? false;
  }

  @override
  Future<bool> dispose() async {
    return (await _channel.invokeMethod<bool>('dispose')) ?? false;
  }

  @override
  Stream<ScanResult> ranging(List<Region> regions) {
    // TODO implement
    return throw UnimplementedError('ranging() has not been implemented.');
  }

  @override
  Future<bool> setScanPeriod(int scanPeriod) async {
    return (await _channel.invokeMethod<bool>(
          'dispose',
          <String, Object>{'scanPeriod': scanPeriod},
        )) ??
        false;
  }

  @override
  Future<bool> setScanDuration(int scanDuration) async {
    return (await _channel.invokeMethod<bool>(
          'dispose',
          <String, Object>{'scanPeriod': scanDuration},
        )) ??
        false;
  }
}
