#import "BSRangingStreamHandler.h"
#import <BeaconScannerPlugin.h>

@implementation BSRangingStreamHandler

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
        [self.instance stopRangingBeacon];
    }
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    if (self.instance) {
        self.instance.flutterEventSinkRanging = events;
        [self.instance startRangingBeaconWithCall:arguments];
    }
    return nil;
}

@end
