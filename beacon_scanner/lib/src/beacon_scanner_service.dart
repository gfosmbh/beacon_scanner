class BeaconScannerService {
  static final BeaconScannerService instance = BeaconScannerService._();

  BeaconScannerService._();

  bool isInitialize = false;

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