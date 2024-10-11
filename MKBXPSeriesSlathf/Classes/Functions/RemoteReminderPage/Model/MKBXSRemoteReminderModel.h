//
//  MKBXSRemoteReminderModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/27.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSRemoteReminderModel : NSObject

#pragma mark - LED notification
@property (nonatomic, copy)NSString *ledBlinkingTime;

@property (nonatomic, copy)NSString *ledBlinkingInterval;

#pragma mark - Buzzer notification
@property (nonatomic, copy)NSString *buzzerRingingTime;

@property (nonatomic, copy)NSString *buzzerRingingInterval;

@end

NS_ASSUME_NONNULL_END
