class BeaconScannerIOS extends BeaconScannerPlatform {
  static void registerWith() {
    BeaconScannerPlatform.instance = BeaconScannerIOS();
  }
}