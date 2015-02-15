//
//  PeripheralManager.h
//  Asphalt
//
//  Created by Morgan Collino on 2/8/15.
//
//

#import <CoreBluetooth/CoreBluetooth.h>

@protocol PeripheralManagerProtocol;

@interface PeripheralManager : NSObject <CBPeripheralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBPeripheralManager *manager;
@property (nonatomic, weak) id<PeripheralManagerProtocol> delegate;
@property (strong, nonatomic) NSMutableDictionary *characteristics;

// Static Methods
+ (instancetype)sharedPeripheral;

@end

@protocol PeripheralManagerProtocol <NSObject>

- (void)clean;

@end