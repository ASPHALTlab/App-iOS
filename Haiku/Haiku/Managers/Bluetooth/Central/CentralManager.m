//
//  CentralManager.m
//  Asphalt
//
//  Created by Morgan Collino on 2/8/15.
//
//

#import "CentralManager.h"
#import "PeripheralManager.h"
#import "HaikuCommunication.h"

@interface CentralManager ()

@property (retain, nonatomic) NSUUID *identifier;
@property (nonatomic) BOOL strictScan;
@property (nonatomic, strong) CBCentralManager *manager;

@end

@implementation CentralManager

static NSString * const kCacheUUIDs = @"CACHE_PREVIOUS_UUIDS";

//E519A981-EB1F-ED37-84C9-B73F2488DA05
//00001531-1212-EFDE-1523-785FEABCD123


+ (instancetype)sharedCentral {
	
	static CentralManager *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[self alloc] init];
	});
	return shared;
}

- (instancetype)init {
	if (self = [super init]) {
		self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
		self.strictScan = NO;
		self.discoveredDevices = @[];
#warning PUT_STRICTSCAN TO YES WHEN WE KNOW THE UUIDS SERVICES !
		[self loadCachedObjects];
		
		// Service use to scan & to discover
	
		self.serviceUUIDs = @[[CBUUID UUIDWithString:DATA_SERVICE]];
	}
	return self;
}

- (void)clean {
	self.discoveredServices = @[].mutableCopy;
	self.discoveredDevices = @[];
}

#pragma mark - Cache

- (void)loadCachedObjects {
	
	self.cacheUUIDs = @[];
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSArray *cachedObjects = [userDefault objectForKey:kCacheUUIDs];
	
	if (cachedObjects) {
		NSMutableArray *uuids = [[NSMutableArray alloc] init];
		for (NSString *uuid in cachedObjects) {
			NSUUID *newUUID = [[NSUUID alloc] initWithUUIDString:uuid];
			[uuids addObject:newUUID];
		}
		self.cacheUUIDs = uuids;
	}
}

- (void)insertUUIDInCache:(NSUUID *)newDevice {
	
	NSMutableArray *mutable = [self.cacheUUIDs mutableCopy];
	[mutable addObject:newDevice];
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	NSArray *cachedObjects = [userDefault objectForKey:kCacheUUIDs];
	if (cachedObjects == nil) {
		cachedObjects = @[newDevice.UUIDString];
	} else {
		NSMutableArray *mutableCachedArray = [cachedObjects mutableCopy];
		[mutableCachedArray addObject:newDevice.UUIDString];
		cachedObjects = mutableCachedArray;
	}
	
	[userDefault setObject:cachedObjects forKey:kCacheUUIDs];
	[userDefault synchronize];
}

- (BOOL)isUUIDKnown:(NSUUID *)uuid {
	
	for (NSUUID *cacheUUID in self.cacheUUIDs) {
		if ([uuid.UUIDString isEqualToString:cacheUUID.UUIDString]) {
			return YES;
		}
	}
	return NO;
}


#pragma mark - Logical

// Service to erase -- TEST MODE --
//9B5E7E2A-1635-094D-19E7-CF7A10B97360
//713D0000-503E-4C75-BA94-3148F18D941E

- (void)scan {
	
	// /!\ BE SPECIFIC TO LOOK UP FOR SPECIFIC UUID of services
	// More there are of services, the more the lookup will be efficient
	// If you pass nil, you can not scan in background / try to reconnect in background mode
	
	
	if (self.strictScan == NO) {
		[self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];
	} else {
		NSLog(@"serviceUUIDs: %@", self.serviceUUIDs);
		NSLog(@"MANAGER: %@", self.manager);
		[self.manager scanForPeripheralsWithServices:self.serviceUUIDs options:@{CBCentralManagerScanOptionSolicitedServiceUUIDsKey:@NO,CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];
	}
}

// Identifier : Bike Assistant: 3378FD5A-39E0-3E3B-6205-65741D7E1267
#pragma mark - Central Manager Delegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BLE_NEW_DEVICE_DETECTED
														object:self
													  userInfo:@{@"peripheral":peripheral, @"advertisementData":advertisementData}];
	
	NSLog(@"Advertisement: %@", advertisementData);
	if ([self.delegate respondsToSelector:@selector(central:didDiscoverPeripheral:)]) {
		[self.delegate central:self didDiscoverPeripheral:peripheral];
	}
	
	if ([self isUUIDKnown:peripheral.identifier]) {
		NSLog(@"AUTO_CONNECT");
		[self connectOnPeripheral:peripheral];
	}
	
	[self.discoveredDevices arrayByAddingObject:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BLE_CO_DEVICE
														object:self
													  userInfo:@{@"peripheral":peripheral}];
	
	self.connectedPeripheral = peripheral;
	
	// Insert in cache if not known
	if ([self isUUIDKnown:peripheral.identifier] == NO) {
		[self insertUUIDInCache:peripheral.identifier];
	}
	
	// Launch the peripheral manager to discover services/characteristics of the device
	PeripheralManager *manager = [PeripheralManager sharedPeripheral];
	[peripheral setDelegate:manager];
	[peripheral discoverServices:nil]; // Discover all -> Precise to be less consumption
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
	} else if (central.state == CBCentralManagerStatePoweredOn) {
		NSLog(@"CBCentralManagerStatePoweredOn ==> Scan");
		[self scan];
	} else if ([central state] == CBCentralManagerStateUnauthorized) {
		NSLog(@"CoreBluetooth BLE state is unauthorized");
	}
	else if ([central state] == CBCentralManagerStateUnknown) {
		NSLog(@"CoreBluetooth BLE state is unknown");
	}
	else if ([central state] == CBCentralManagerStateUnsupported) {
		NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
	}
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	
	if ([self.delegate respondsToSelector:@selector(central:didFailConnectOn:)]) {
		[self.delegate central:self didFailConnectOn:peripheral];
	}
	
	if (self.connectedPeripheral) {
		[self.connectedPeripheral setDelegate:nil];
		self.connectedPeripheral = nil;
	}
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	
	[self clean];
	[[NSNotificationCenter defaultCenter] postNotificationName:BLE_DECO_DEVICE
														object:self
													  userInfo:@{@"peripheral":peripheral}];
	
	//[self scan];
	if ([self.delegate respondsToSelector:@selector(central:didDisconnectOn:)]) {
		[self.delegate central:self didDisconnectOn:peripheral];
	}

	if (self.connectedPeripheral) {
		[self.connectedPeripheral setDelegate:nil];
		self.connectedPeripheral = nil;
	}
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
	NSLog(@"Peripherals retrieved: %@", peripherals);
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
	NSLog(@"DidRetrieveConnectedPeripherals :%@", peripherals);
}

#pragma mark - Public methods

- (void)connectOnPeripheral:(CBPeripheral *)peripheral {
	
	[self.manager cancelPeripheralConnection:peripheral]; //IMPORTANT, to clear off any pending connections
	[self.manager connectPeripheral:peripheral
							options:[NSDictionary dictionaryWithObject:@YES
																forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}



@end
