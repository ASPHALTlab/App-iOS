//
//  CentralManager.h
//  Asphalt
//
//  Created by Morgan Collino on 2/8/15.
//
//

#import <CoreBluetooth/CoreBluetooth.h>
@protocol CentralManagerProtocol;

// Basically, this manager held the Bluetooth connectivity on (Scan, Connectivity...)

@interface CentralManager : NSObject <CBCentralManagerDelegate>

@property (nonatomic, weak) id<CentralManagerProtocol> delegate;
@property (nonatomic, strong) NSArray *cacheUUIDs; // Cache of past connected objects
@property (strong, nonatomic) NSArray *serviceUUIDs; // Searched services

// Discovered properties

@property (nonatomic, strong) NSArray *discoveredDevices; // Cache of past connected objects
@property (nonatomic, strong) NSMutableArray *discoveredServices; // Services discovered


// Connected peripheral
@property (nonatomic, strong) CBPeripheral *connectedPeripheral;

// Static Methods
+ (instancetype)sharedCentral;

// Public Methods
- (void)connectOnPeripheral:(CBPeripheral *)peripheral;
- (void)scan;

@end

@protocol CentralManagerProtocol <NSObject>

@optional
- (void)central:(CentralManager *)central didConnectOn:(CBPeripheral *)device;
- (void)central:(CentralManager *)central didDisconnectOn:(CBPeripheral *)device;
- (void)central:(CentralManager *)central didFailConnectOn:(CBPeripheral *)device;
- (void)central:(CentralManager *)central didDiscoverPeripheral:(CBPeripheral *)device;

@end