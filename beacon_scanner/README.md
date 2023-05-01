# beacon_scanner

A Flutter plugin for Scanning iBeacon.

## Usage

To implement a new platform-specific implementation of beacon_scanner, extend BeaconScannerPlatform with an implementation that performs the platform-specific behavior, 
and when you register your plugin, set the default BeaconScannerPlatform by calling
BeaconScannerPlatform.instance = MyPlatformBeaconScanner().
