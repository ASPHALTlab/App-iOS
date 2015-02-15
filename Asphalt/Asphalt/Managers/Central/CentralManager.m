//
//  CentralManager.m
//  Asphalt
//
//  Created by Morgan Collino on 2/8/15.
//
//

#import "CentralManager.h"
#import "PeripheralManager.h"

@interface CentralManager ()

@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (retain, nonatomic) NSUUID *identifier;

@end

@implementation CentralManager

- (instancetype) init {
	if (self = [super init]) {
		self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
	}
	return self;
}

+ (instancetype)sharedCentral {
	
	static CentralManager *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[self alloc] init];
	});
	return shared;
}

// Identifier : Bike Assistant: 3378FD5A-39E0-3E3B-6205-65741D7E1267
#pragma mark - Central Manager Delegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	
	if ([self.delegate respondsToSelector:@selector(central:didDiscoverPeripheral:)]) {
		[self.delegate central:self didDiscoverPeripheral:peripheral];
	}
	
	// Testing mode : UUID - Only one.
	if (![peripheral.identifier.UUIDString isEqualToString:@"99781D07-D9A5-512D-FDFA-1038CC0C92DD"]) {
		return;
	}
	
	self.discoveredPeripheral = peripheral;
	[self.manager connectPeripheral:self.discoveredPeripheral
							options:[NSDictionary dictionaryWithObject:@YES
																forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	PeripheralManager *manager = [PeripheralManager sharedPeripheral];
	[peripheral setDelegate:manager];
	[peripheral discoverServices:nil];
	if ([self.delegate respondsToSelector:@selector(central:didConnectOn:)]) {
		[self.delegate central:self didConnectOn:peripheral];
	}
}

// E519A981-EB1F-ED37-84C9-B73F2488DA05 -- Other device -- Testing

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
	// You should test all scenarios
	if (central.state != CBCentralManagerStatePoweredOn) {
		return;
	}
	
	if (central.state == CBCentralManagerStatePoweredOn) {
		[self.manager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey:@NO }];
	}
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	
	if ([self.delegate respondsToSelector:@selector(central:didFailConnectOn:)]) {
		[self.delegate central:self didFailConnectOn:peripheral];
	}
	
	if (self.discoveredPeripheral) {
		[self.discoveredPeripheral setDelegate:nil];
		self.discoveredPeripheral = nil;
	}
	
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	
	if ([self.delegate respondsToSelector:@selector(central:didDisconnectOn:)]) {
		[self.delegate central:self didDisconnectOn:peripheral];
	}

	if (self.discoveredPeripheral) {
		[self.discoveredPeripheral setDelegate:nil];
		self.discoveredPeripheral = nil;
	}
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
	NSLog(@"Peripherals retrieved: %@", peripherals);
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
	NSLog(@"DidRetrieveConnectedPeripherals :%@", peripherals);
}

@end