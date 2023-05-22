import 'package:beacon_scanner_platform_interface/beacon_scanner_platform_interface.dart';

class BeaconScanner {
  /// Instance of Beacon-Service
  static final BeaconScanner instance = BeaconScanner._();

  BeaconScanner._();

  /// Is [BeaconScanner] initialize
  bool isInitialize = false;

  /// Check for the latest [AuthorizationStatus] from device.
  ///
  /// For Android, this will return [AuthorizationStatus.allowed], [AuthorizationStatus.denied] or [AuthorizationStatus.notDetermined].
  Future<AuthorizationStatus> get authorizationStatus => BeaconScannerPlatform.instance.authorizationStatus;

  /// Check for the latest [BluetoothState] from device.
  Future<BluetoothState> get bluetoothState => BeaconScannerPlatform.instance.bluetoothState;

  /// Initialize scanning API.
  /// When [withCheck] is active, it will check required permissions
  ///
  /// For Android, it will check whether Bluetooth is enabled,
  /// allowed to access location services and check
  /// whether location services is enabled.
  /// For iOS, it will check whether Bluetooth is enabled,
  /// requestWhenInUse or requestAlways location services and check
  /// whether location services is enabled.
  Future<bool> initialize([bool withCheck = false]) async {
    if (withCheck) {
      return isInitialize = await BeaconScannerPlatform.instance.initialize();
    } else {
      return isInitialize = await BeaconScannerPlatform.instance.initializeAndCheckScanning();
    }
  }

  /// Close scanning API.
  Future<bool> close() async {
    bool successClosed = await BeaconScannerPlatform.instance.close();
    isInitialize = !successClosed;
    return successClosed;
  }

  /// Start ranging iBeacons with defined [List] of [Region]s.
  ///
  /// This will fires [RangingResult] whenever the iBeacons in range.
  Stream<ScanResult> ranging(List<Region> regions) => BeaconScannerPlatform.instance.ranging(regions);

  /// Start monitoring iBeacons with defined [List] of [Region]s.
  ///
  /// This will fires [MonitoringResult] whenever the iBeacons in range.
  Stream<MonitoringResult> monitoring(List<Region> regions) => BeaconScannerPlatform.instance.monitoring(regions);

  /// Customize duration of the beacon scan on the Android Platform.
  Future<bool> setScanPeriod(Duration scanPeriod) async => BeaconScannerPlatform.instance.setScanPeriod(scanPeriod.inMilliseconds);

  /// Customize duration of the beacon scan on the Android Platform.
  Future<bool> setScanDuration(Duration scanDuration) async => BeaconScannerPlatform.instance.setScanPeriod(scanDuration.inMilliseconds);

  /// Start checking for bluetooth state changed.
  ///
  /// This will fires [BluetoothState] whenever bluetooth state changed.
  Stream<BluetoothState> bluetoothStateChanged() => BeaconScannerPlatform.instance.bluetoothStateChanged();

  /// Return `true` when location service is enabled, otherwise `false`.
  Future<bool> checkLocationServicesIfEnabled() => BeaconScannerPlatform.instance.checkLocationServicesIfEnabled();

  /// Set the default AuthorizationStatus to use in requesting location authorization.
  /// For iOS, this can be either [AuthorizationStatus.whenInUse] or [AuthorizationStatus.always].
  /// For Android, this is not used.
  ///
  /// This method should be called very early to have an effect,
  /// before any of the other initializeScanning or authorizationStatus getters.
  ///
  Future<bool> setLocationAuthorizationTypeDefault(AuthorizationStatus authorizationStatus) =>
      BeaconScannerPlatform.instance.setLocationAuthorizationTypeDefault(authorizationStatus);

  /// Start checking for location service authorization status changed.
  ///
  /// This will fires [AuthorizationStatus] whenever authorization status changed.
  Stream<AuthorizationStatus> authorizationStatusChanged() => BeaconScannerPlatform.instance.authorizationStatusChanged();

  /// Request an authorization to the device.
  ///
  /// For Android, this will request a permission of `Manifest.permission.ACCESS_COARSE_LOCATION`.
  /// For iOS, this will send a request `CLLocationManager#requestAlwaysAuthorization`.
  Future<bool> requestAuthorization() => BeaconScannerPlatform.instance.requestAuthorization();

  /// Request to open Application Settings from device.
  ///
  /// For Android, this will does nothing.
  Future<bool> openApplicationSettings() => BeaconScannerPlatform.instance.openApplicationSettings();

  /// Request to open Locations Settings from device.
  ///
  /// For iOS, this will does nothing because of private method.
  Future<bool> openLocationSettings() => BeaconScannerPlatform.instance.openLocationSettings();

  /// Request to open Bluetooth Settings from device.
  ///
  /// For iOS, this will does nothing because of private method.
  Future<bool> openBluetoothSettings() => BeaconScannerPlatform.instance.openBluetoothSettings();

  /// If the device can act like a beacon (advertising BLE-Frames)
  Future<bool> isBroadcastSupported() => BeaconScannerPlatform.instance.isBroadcastSupported();
}
