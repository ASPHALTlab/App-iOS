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
@property (strong, nonatomic) CBCentralManager *manager;

// Static Methods
+ (instancetype)sharedCentral;

@end

@protocol CentralManagerProtocol <NSObject>

- (void)central:(CentralManager *)central didConnectOn:(CBPeripheral *)device;
- (void)central:(CentralManager *)central didDisconnectOn:(CBPeripheral *)device;
- (void)central:(CentralManager *)central didFailConnectOn:(CBPeripheral *)device;
- (void)central:(CentralManager *)central didDiscoverPeripheral:(CBPeripheral *)device;

@end