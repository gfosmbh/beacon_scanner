#import "BSUtils.h"
#import <CoreLocation/CoreLocation.h>

@implementation BSUtils

+ (NSDictionary * _Nonnull) dictionaryFromCLBeacon:(CLBeacon*) beacon {
    NSString *proximity;
    switch (beacon.proximity) {
        case CLProximityUnknown:
            proximity = @"unknown";
            break;
        case CLProximityImmediate:
            proximity = @"immediate";
            break;
        case CLProximityNear:
            proximity = @"near";
            break;
        case CLProximityFar:
            proximity = @"far";
            break;
    }
    
    NSNumber *rssi = [NSNumber numberWithInteger:beacon.rssi];
    NSNumber *accuracy = [NSNumber numberWithDouble:beacon.accuracy];
    return @{
             @"proximityUUID": [beacon.UUID UUIDString],
             @"major": beacon.major,
             @"minor": beacon.minor,
             @"rssi": rssi,
             @"accuracy": accuracy,
             @"proximity": proximity
             };
}

+ (NSDictionary * _Nonnull) dictionaryFromCLBeaconRegion:(CLBeaconRegion*) region {
    id major = region.major;
    if (!major) {
        major = [NSNull null];
    }
    id minor = region.minor;
    if (!minor) {
        minor = [NSNull null];
    }
    
    return @{
             @"identifier": region.identifier,
             @"proximityUUID": [region.UUID UUIDString],
             @"major": major,
             @"minor": minor,
             };
}

+ (CLBeaconRegion * _Nullable) regionFromDictionary:(NSDictionary*) dict {
    NSString *identifier = dict[@"identifier"];
    NSString *proximityUUID = dict[@"proximityUUID"];
    NSNumber *major = dict[@"major"];
    NSNumber *minor = dict[@"minor"];
    
    CLBeaconRegion *region = nil;
    if (proximityUUID && major && minor) {
        region = [[CLBeaconRegion alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:proximityUUID] major:[major intValue] minor:[minor intValue] identifier:identifier];
    } else if (proximityUUID && major) {
        region = [[CLBeaconRegion alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:proximityUUID] major:[major intValue] identifier:identifier];
    } else if (proximityUUID) {
        region = [[CLBeaconRegion alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:proximityUUID] identifier:identifier];
    }
    
    return region;
}

@end
