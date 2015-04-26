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

@property (nonatomic, weak) id<PeripheralManagerProtocol> delegate;

@property (strong, nonatomic) CBPeripheralManager *manager;

// Discovered characteristics
@property (nonatomic, strong) NSMutableDictionary *discoveredCharacteristics; // Characteristics discovered
// Characteristics to look for
@property (nonatomic, strong) NSDictionary *characteristicsUUIDs;


// Static Methods
+ (instancetype)sharedPeripheral;

@end

@protocol PeripheralManagerProtocol <NSObject>

- (void)clean;
- (void)peripheral:(PeripheralManager *)manager didDiscoverCharacteristicsForService:(CBService *)service;

@end