import 'dart:async';

import 'package:beacon_scanner_platform_interface/beacon_scanner_platform_interface.dart';
import 'package:flutter/services.dart';

/// An implementation of [BeaconScannerPlatform] for Android.
class BeaconScannerAndroid extends BeaconScannerPlatform {
  /// Registers this class as the default instance of [BeaconScannerPlatform].
  static void registerWith() {
    BeaconScannerPlatform.instance = BeaconScannerAndroid();
  }

  /// Method Channel used to communicate to native code.
  static const MethodChannel _channel = MethodChannel('plugins.lukangagames.com/beacon_scanner_android');

  /// Event Channel used to communicate to native code ranging beacons.
  static const EventChannel _rangingChannel = EventChannel('beacon_scanner_event_ranging');

  /// Event Channel used to communicate to native code monitoring beacons.
  static const EventChannel _monitoringChannel = EventChannel('beacon_scanner_event_monitoring');

  /// Event Channel used to communicate to native code to checking
  /// for bluetooth state changed.
  static const EventChannel _bluetoothStateChangedChannel = EventChannel('beacon_scanner_bluetooth_state_changed');

  /// Event Channel used to communicate to native code to checking
  /// for bluetooth state changed.
  static const EventChannel _authorizationStatusChangedChannel = EventChannel('beacon_scanner_authorization_status_changed');

  /// This information does not change from call to call. Cache it.
  Stream<BluetoothState>? _onBluetoothState;

  /// This information does not change from call to call. Cache it.
  Stream<AuthorizationStatus>? _onAuthorizationStatus;

  @override
  Future<bool> initialize() async => (await _channel.invokeMethod<bool>('initialize')) ?? false;

  @override
  Future<bool> initializeAndCheckScanning() async => (await _channel.invokeMethod<bool>('initializeAndCheckScanning')) ?? false;

  @override
  Future<bool> close() async => (await _channel.invokeMethod<bool>('close')) ?? false;

  @override
  Stream<ScanResult> ranging(List<Region> regions) {
    final List<Map<String, dynamic>> list = regions.map((region) => region.toJson()).toList();
    final Stream<ScanResult> onRanging = _rangingChannel.receiveBroadcastStream(list).map((dynamic event) => ScanResult.fromJson(event));
    return onRanging;
  }

  @override
  Stream<MonitoringResult> monitoring(List<Region> regions) {
    final List<Map<String, dynamic>> list = regions.map((region) => region.toJson()).toList();
    final Stream<MonitoringResult> onMonitoring = _monitoringChannel.receiveBroadcastStream(list).map((dynamic event) => MonitoringResult.fromJson(event));
    return onMonitoring;
  }

  @override
  Future<bool> setScanPeriod(int scanPeriod) async =>
      (await _channel.invokeMethod<bool>(
        'setScanPeriod',
        <String, Object>{'scanPeriod': scanPeriod},
      )) ??
      false;

  @override
  Future<bool> setScanDuration(int scanDuration) async =>
      (await _channel.invokeMethod<bool>(
        'setScanDuration',
        <String, Object>{'scanDuration': scanDuration},
      )) ??
      false;

  @override
  Future<BluetoothState> get bluetoothState async => BluetoothState.parse(await _channel.invokeMethod('bluetoothState'));

  @override
  Stream<BluetoothState> bluetoothStateChanged() {
    if (_onBluetoothState == null) {
      _onBluetoothState = _bluetoothStateChangedChannel.receiveBroadcastStream().map((dynamic event) => BluetoothState.parse(event));
    }
    return _onBluetoothState!;
  }

  @override
  Future<bool> checkLocationServicesIfEnabled() async => await _channel.invokeMethod('checkLocationServicesIfEnabled');

  @override
  Future<bool> setLocationAuthorizationTypeDefault(AuthorizationStatus authorizationStatus) async => false;

  @override
  Future<AuthorizationStatus> get authorizationStatus async => AuthorizationStatus.parse(await _channel.invokeMethod('authorizationStatus'));

  @override
  Stream<AuthorizationStatus> authorizationStatusChanged() {
    if (_onAuthorizationStatus == null) {
      _onAuthorizationStatus = _authorizationStatusChangedChannel.receiveBroadcastStream().map((dynamic event) => AuthorizationStatus.parse(event));
    }
    return _onAuthorizationStatus!;
  }

  @override
  Future<bool> requestAuthorization() async => await _channel.invokeMethod('requestAuthorization');

  @override
  Future<bool> openApplicationSettings() async => false;

  @override
  Future<bool> openLocationSettings() async => await _channel.invokeMethod('openLocationSettings');

  @override
  Future<bool> openBluetoothSettings() async => await _channel.invokeMethod('openBluetoothSettings');

  @override
  Future<bool> isBroadcastSupported() async => await _channel.invokeMethod('isBroadcastSupported');
}
