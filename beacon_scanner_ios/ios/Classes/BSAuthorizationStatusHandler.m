#import "BSAuthorizationStatusHandler.h"
#import <BeaconScannerPlugin.h>
#import <CoreBluetooth/CoreBluetooth.h>

@implementation BSAuthorizationStatusHandler

- (instancetype) initWithBeaconScannerPlugin:(BeaconScannerPlugin*) instance {
    if (self = [super init]) {
        _instance = instance;
    }
    
    return self;
}

///------------------------------------------------------------
#pragma mark - Flutter Stream Handler
///------------------------------------------------------------

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    if (self.instance) {
        self.instance.flutterEventSinkAuthorization = nil;
    }
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    // initialize central manager if it itsn't
    [self.instance initializeLocationManager];
    
    if (self.instance) {
        self.instance.flutterEventSinkAuthorization = events;
    }
    
    return nil;
}

@end
