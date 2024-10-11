//
//  MKBXSTaskAdopter.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const mk_bxs_totalNumKey;
extern NSString *const mk_bxs_totalIndexKey;
extern NSString *const mk_bxs_contentKey;

@class CBCharacteristic;
@interface MKBXSTaskAdopter : NSObject

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic;

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic;

@end

NS_ASSUME_NONNULL_END
