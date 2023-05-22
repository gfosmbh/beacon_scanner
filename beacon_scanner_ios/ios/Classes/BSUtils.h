#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CLBeacon;
@class CLBeaconRegion;
@interface BSUtils : NSObject

+ (NSDictionary * _Nonnull) dictionaryFromCLBeacon:(CLBeacon*) beacon;
+ (NSDictionary * _Nonnull) dictionaryFromCLBeaconRegion:(CLBeaconRegion*) region;

+ (CLBeaconRegion * _Nullable) regionFromDictionary:(NSDictionary*) dict;

@end

NS_ASSUME_NONNULL_END
