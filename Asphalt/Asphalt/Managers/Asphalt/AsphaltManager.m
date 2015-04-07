//
//  AsphaltManager.m
//  Asphalt
//
//  Created by Morgan Collino on 2/8/15.
//
//

#import "AsphaltManager.h"
#import "CentralManager.h"
#import "PeripheralManager.h"

@interface AsphaltManager () <CentralManagerProtocol, PeripheralManagerProtocol>

@property (nonatomic, strong) CentralManager *centralManager;
@property (nonatomic, strong) PeripheralManager *peripheralManager;

@end

@implementation AsphaltManager

- (instancetype)init {
	if (self = [super init]) {
		self.centralManager = [CentralManager sharedCentral];
		self.centralManager.delegate = self;
		self.peripheralManager = [PeripheralManager sharedPeripheral];
		self.peripheralManager.delegate = self;
	}
	return self;
}

+ (instancetype)sharedManager {
	
	static AsphaltManager *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[self alloc] init];
	});
	return shared;
}

- (void)sendColor:(uint8_t [3])colors {
	// write [0] R
	// write [1] G
	// write [2] B
	NSDictionary *characteristics = self.peripheralManager.characteristics;;

	if ([characteristics objectForKey:@"FFF1"]) {
		int8_t val = (uint8_t)colors[0];
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		CBCharacteristic *characteristic = [characteristics objectForKey:@"FFF1"];
		[self.peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[self.peripheral readValueForCharacteristic:characteristic];
	}
	
	if ([characteristics objectForKey:@"FFF2"]) {
		uint8_t val = (uint8_t)colors[1];
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		CBCharacteristic *characteristic = [characteristics objectForKey:@"FFF2"];
		[self.peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[self.peripheral readValueForCharacteristic:characteristic];
	}
	
	if ([characteristics objectForKey:@"FFF3"]) {
		int8_t val = (uint8_t)colors[2];
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		CBCharacteristic *characteristic = [characteristics objectForKey:@"FFF3"];
		[self.peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[self.peripheral readValueForCharacteristic:characteristic];
	}
	
}

- (void)sendCurrentTime {
	NSDictionary *characteristics = self.peripheralManager.characteristics;;
	
	if ([characteristics objectForKey:@"1805"]) {
		int8_t val = 0; // NSDate
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		CBCharacteristic *characteristic = [characteristics objectForKey:@"1805"];
		[self.peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[self.peripheral readValueForCharacteristic:characteristic];
	}
	
}

- (void)search {
	
}

- (void)disconnect {
	[[CentralManager sharedCentral].manager cancelPeripheralConnection:self.peripheral];
}

- (BOOL)isConnected {
	return self.peripheral && self.peripheral.state == CBPeripheralStateConnected;
}

- (void)sendChangeConnection {
	if ([self.delegate respondsToSelector:@selector(connectionDidChange:)]) {
		[self.delegate connectionDidChange:self.isConnected];
	}
}


#pragma mark CentralManagerProtocol

- (void)central:(CentralManager *)central didConnectOn:(CBPeripheral *)device {
	NSLog(@"Central: DidConnectOn: %@", device);
	self.peripheral = device;
	self.peripheral.delegate = [PeripheralManager sharedPeripheral];
	[self sendChangeConnection];
}

- (void)central:(CentralManager *)central didDisconnectOn:(CBPeripheral *)device {
	NSLog(@"Central: didDisconnectOn: %@", device);
	self.peripheral = nil;
	[self sendChangeConnection];
}

- (void)central:(CentralManager *)central didDiscoverPeripheral:(CBPeripheral *)device {
	NSLog(@"\n\nCentral: didDiscoverPeripheral: %@", device);
}

- (void)central:(CentralManager *)central didFailConnectOn:(CBPeripheral *)device {
	NSLog(@"Central: DidFailConnectOn: %@", device);
	self.peripheral = nil;
	[self sendChangeConnection];
}

#pragma mark PeripheralManagerProtocol

- (void)clean {
	
	// See if we are subscribed to a characteristic on the peripheral
	if (self.peripheral.services != nil) {
		for (CBService *service in self.peripheral.services) {
			if (service.characteristics) {
				for (CBCharacteristic *characteristic in service.characteristics) {
					if (characteristic.isNotifying) {
						[self.peripheral setNotifyValue:NO forCharacteristic:characteristic];
					}
				}
			}
		}
	}
 
	// Delegate : centralManager cancelPeripheralConnection:_discoveredPeripheral
	// Delegate : put property discoveredPeripheral
	
	[self.centralManager.manager cancelPeripheralConnection:self.peripheral];
	self.peripheral = nil;
}


@end
