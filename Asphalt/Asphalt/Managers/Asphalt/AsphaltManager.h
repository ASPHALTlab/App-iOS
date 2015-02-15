//
//  AsphaltManager.h
//  Asphalt
//
//  Created by Morgan Collino on 2/8/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class CentralManager;
@class PeripheralManager;

@protocol AsphaltManagerDelegate;

@interface AsphaltManager : NSObject

- (void)sendColor:(uint8_t[3])color;
- (void)sendCurrentTime;
- (void)disconnect;
- (void)search;
- (BOOL)isConnected;
+ (instancetype)sharedManager;

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (nonatomic, weak) id<AsphaltManagerDelegate> delegate;

@end

@protocol AsphaltManagerDelegate <NSObject>

- (void)connectionDidChange:(BOOL)hasConnection;

@end