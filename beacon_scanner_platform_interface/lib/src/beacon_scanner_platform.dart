import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../method_channel_beacon_scanner.dart';
import 'types.dart';

abstract class BeaconScannerPlatform extends PlatformInterface  {
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

  Future<bool> initialize() async {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<bool> dispose() async {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  Stream<ScanResult> ranging(List<Region> regions) {
    throw UnimplementedError('ranging() has not been implemented.');
  }

  Future<bool> setScanPeriod(int scanPeriod) async {
    throw UnimplementedError('setScanPeriod() has not been implemented.');
  }

  Future<bool> setScanDuration(int scanDuration) async {
    throw UnimplementedError('setScanDuration() has not been implemented.');
  }
}