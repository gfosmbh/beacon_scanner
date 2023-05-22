import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../method_channel_beacon_scanner.dart';
import 'types/authorization_status.dart';
import 'types/bluetooth_state.dart';
import 'types/monitoring_result.dart';
import 'types/region.dart';
import 'types/scan_result.dart';

abstract class BeaconScannerPlatform extends PlatformInterface {
  /// Constructs a BeaconScannerPlatform
  BeaconScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BeaconScannerPlatform _instance = MethodChannelBeaconScanner();

  /// The default instance of [BeaconScannerPlatform] to use
  ///
  /// Defaults to [MethodChannelUrlLauncher].
  static BeaconScannerPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [BeaconScannerPlatform] when they register themselves.
  static set instance(BeaconScannerPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Initialize scanning API.
  Future<bool> initialize() => throw UnimplementedError('initialize() has not been implemented.');

  /// Initialize scanning API and check required permissions.
  ///
  /// For Android, it will check whether Bluetooth is enabled,
  /// allowed to access location services and check
  /// whether location services is enabled.
  /// For iOS, it will check whether Bluetooth is enabled,
  /// requestWhenInUse or requestAlways location services and check
  /// whether location services is enabled.
  Future<bool> initializeAndCheckScanning() => throw UnimplementedError('initializeAndCheckScanning() has not been implemented.');

  /// Close scanning API.
  Future<bool> close() => throw UnimplementedError('close() has not been implemented.');

  /// Start ranging iBeacons with defined [List] of [Region]s.
  ///
  /// This will fires [RangingResult] whenever the iBeacons in range.
  Stream<ScanResult> ranging(List<Region> regions) => throw UnimplementedError('ranging() has not been implemented.');

  /// Start monitoring iBeacons with defined [List] of [Region]s.
  ///
  /// This will fires [MonitoringResult] whenever the iBeacons in range.
  Stream<MonitoringResult> monitoring(List<Region> regions) => throw UnimplementedError('monitoring() has not been implemented.');

  /// Customize duration of the beacon scan on the Android Platform.
  Future<bool> setScanPeriod(int scanPeriod) => throw UnimplementedError('setScanPeriod() has not been implemented.');

  /// Customize duration spent not scanning between each scan cycle on the Android Platform.
  Future<bool> setScanDuration(int scanDuration) => throw UnimplementedError('setScanDuration() has not been implemented.');

  /// Check for the latest [BluetoothState] from device.
  Future<BluetoothState> get bluetoothState => throw UnimplementedError('bluetoothState() has not been implemented.');

  /// Start checking for bluetooth state changed.
  ///
  /// This will fires [BluetoothState] whenever bluetooth state changed.
  Stream<BluetoothState> bluetoothStateChanged() => throw UnimplementedError('bluetoothStateChanged() has not been implemented.');

  /// Return `true` when location service is enabled, otherwise `false`.
  Future<bool> checkLocationServicesIfEnabled() => throw UnimplementedError('checkLocationServicesIfEnabled() has not been implemented.');

  /// Set the default AuthorizationStatus to use in requesting location authorization.
  /// For iOS, this can be either [AuthorizationStatus.whenInUse] or [AuthorizationStatus.always].
  /// For Android, this is not used.
  ///
  /// This method should be called very early to have an effect,
  /// before any of the other initializeScanning or authorizationStatus getters.
  ///
  Future<bool> setLocationAuthorizationTypeDefault(AuthorizationStatus authorizationStatus) =>
      throw UnimplementedError('setLocationAuthorizationTypeDefault() has not been implemented.');

  /// Check for the latest [AuthorizationStatus] from device.
  ///
  /// For Android, this will return [AuthorizationStatus.allowed], [AuthorizationStatus.denied] or [AuthorizationStatus.notDetermined].
  Future<AuthorizationStatus> get authorizationStatus async => throw UnimplementedError('authorizationStatus() has not been implemented.');

  /// Start checking for location service authorization status changed.
  ///
  /// This will fires [AuthorizationStatus] whenever authorization status changed.
  Stream<AuthorizationStatus> authorizationStatusChanged() => throw UnimplementedError('authorizationStatusChanged() has not been implemented.');

  /// Request an authorization to the device.
  ///
  /// For Android, this will request a permission of `Manifest.permission.ACCESS_COARSE_LOCATION`.
  /// For iOS, this will send a request `CLLocationManager#requestAlwaysAuthorization`.
  Future<bool> requestAuthorization() => throw UnimplementedError('requestAuthorization() has not been implemented.');

  /// Request to open Application Settings from device.
  ///
  /// For Android, this will does nothing.
  Future<bool> openApplicationSettings() => throw UnimplementedError('openApplicationSettings() has not been implemented.');

  /// Request to open Locations Settings from device.
  ///
  /// For iOS, this will does nothing because of private method.
  Future<bool> openLocationSettings() => throw UnimplementedError('openLocationSettings() has not been implemented.');

  /// Request to open Bluetooth Settings from device.
  ///
  /// For iOS, this will does nothing because of private method.
  Future<bool> openBluetoothSettings() => throw UnimplementedError('openBluetoothSettings() has not been implemented.');

  /// If the device can act like a beacon (advertising BLE-Frames)
  Future<bool> isBroadcastSupported() => throw UnimplementedError('isBroadcastSupported() has not been implemented.');
}
