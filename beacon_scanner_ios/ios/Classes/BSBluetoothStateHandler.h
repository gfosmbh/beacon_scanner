#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@class BeaconScannerPlugin;
@interface BSBluetoothStateHandler : NSObject<FlutterStreamHandler>

@property (strong, nonatomic) BeaconScannerPlugin* instance;

- (instancetype) initWithBeaconScannerPlugin:(BeaconScannerPlugin*) instance;

@end

NS_ASSUME_NONNULL_END
