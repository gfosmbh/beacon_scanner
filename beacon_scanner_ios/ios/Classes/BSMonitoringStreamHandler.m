#import "BSMonitoringStreamHandler.h"
#import <BeaconScannerPlugin.h>

@implementation BSMonitoringStreamHandler

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
        [self.instance stopMonitoringBeacon];
    }
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    if (self.instance) {
        self.instance.flutterEventSinkMonitoring = events;
        [self.instance startMonitoringBeaconWithCall:arguments];
    }
    return nil;
}

@end
