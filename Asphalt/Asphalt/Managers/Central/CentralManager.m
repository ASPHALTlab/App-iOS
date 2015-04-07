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

//E519A981-EB1F-ED37-84C9-B73F2488DA05
//00001531-1212-EFDE-1523-785FEABCD123

- (instancetype) init {
	if (self = [super init]) {
		self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
		
		NSArray *a =  [self.manager retrievePeripheralsWithIdentifiers:@[[CBUUID UUIDWithString:@"9B5E7E2A-1635-094D-19E7-CF7A10B97360"]]];
		NSLog(@"A: %@", a);
		if (a.count > 0) {
			CBPeripheral *p = (CBPeripheral *)[a objectAtIndex:0];
			self.discoveredPeripheral = p;
			[self.manager cancelPeripheralConnection:p]; //IMPORTANT, to clear off any pending connections
			[self.manager connectPeripheral:p options:nil];
		}
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

- (void)scan {
	

	
	// Service to erase -- TEST MODE --
	//9B5E7E2A-1635-094D-19E7-CF7A10B97360
	//713D0000-503E-4C75-BA94-3148F18D941E
	//[self.manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"9B5E7E2A-1635-094D-19E7-CF7A10B97360"]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];
	[self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];

}

// Identifier : Bike Assistant: 3378FD5A-39E0-3E3B-6205-65741D7E1267
#pragma mark - Central Manager Delegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	
	if ([self.delegate respondsToSelector:@selector(central:didDiscoverPeripheral:)]) {
		[self.delegate central:self didDiscoverPeripheral:peripheral];
	}
	
	if ([peripheral.identifier.UUIDString isEqualToString:@"9B5E7E2A-1635-094D-19E7-CF7A10B97360"]) {
		
		NSLog(@"Advertisement Data : %@", advertisementData);
		
		self.discoveredPeripheral = peripheral;
		[self.manager cancelPeripheralConnection:peripheral]; //IMPORTANT, to clear off any pending connections

		[self.manager connectPeripheral:self.discoveredPeripheral
							options:[NSDictionary dictionaryWithObject:@YES
																forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
	}
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	PeripheralManager *manager = [PeripheralManager sharedPeripheral];
	[peripheral setDelegate:manager];
	[peripheral discoverServices:nil];
	if ([self.delegate respondsToSelector:@selector(central:didConnectOn:)]) {
		[self.delegate central:self didConnectOn:peripheral];
	}
	[self.manager stopScan];
}

// E519A981-EB1F-ED37-84C9-B73F2488DA05 -- Other device -- Testing

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
	// You should test all scenarios
	if (central.state != CBCentralManagerStatePoweredOn) {
		return;
	}
	
	if (central.state == CBCentralManagerStatePoweredOn) {
		[self scan];
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
	
	[self scan];
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
