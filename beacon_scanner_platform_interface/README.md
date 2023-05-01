# beacon_scanner_platform_interface

A common platform interface for the beacon_scanner_platform_interface plugin.
This interface allows platform-specific implementations of the beacon_scanner plugin, as well as the plugin itself, to ensure they are supporting the same interface.

## Usage

To implement a new platform-specific implementation of beacon_scanner, extend BeaconScannerPlatform with an implementation that performs the platform-specific behavior, 
and when you register your plugin, set the default BeaconScannerPlatform by calling
BeaconScannerPlatform.instance = MyPlatformBeaconScanner().
