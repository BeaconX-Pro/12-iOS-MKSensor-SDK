//
//  MKBXSSDKDataAdopter.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXSSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSDKDataAdopter : NSObject

+ (NSString *)getUrlscheme:(char)hexChar;
+ (NSString *)getEncodedString:(char)hexChar;

+ (NSString *)fetchThreeAxisDataRate:(mk_bxs_threeAxisDataRate)dataRate;
+ (NSString *)fetchThreeAxisDataAG:(mk_bxs_threeAxisDataAG)ag;

+ (NSString *)fetchTxPower:(mk_bxs_txPower)txPower;
+ (NSString *)fetchTxPowerValueString:(NSString *)content;

+ (NSDictionary *)parseSlotData:(NSString *)content advData:(NSData *)advData hasStandbyDuration:(BOOL)hasStandbyDuration;

+ (NSDictionary *)parseSlotTriggerParam:(NSString *)content;

+ (NSString *)fetchUrlString:(mk_bxs_urlHeaderType)urlType urlContent:(NSString *)urlContent;

+ (NSArray *)parseHallData:(NSArray *)list;

+ (NSArray *)parseTemperatureHumidityData:(NSString *)content;

+ (NSString *)fetchAdvChannelCmd:(mk_bxs_advChannel)channel;

+ (NSString *)fetchSlotAdvParamsCmd:(id <mk_bxs_slotAdvContentParam>)param;

+ (NSString *)fetchSlotTriggerdAdvParamsCmd:(id <mk_bxs_slotTriggeredAdvContentParam>)param;

@end

NS_ASSUME_NONNULL_END
