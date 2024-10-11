//
//  MKBXSPeripheral.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBXSPeripheral : NSObject<MKBLEBasePeripheralProtocol>

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral dfuMode:(BOOL)dfu;

@end

NS_ASSUME_NONNULL_END
