//
//  CBCommunication.h
//  Asphalt
//
//  Created by Morgan Collino on 10/31/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CBCommunication : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@end
