//
//  MKBXSAccelerationHeaderView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/24.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXSAccelerationHeaderViewDelegate <NSObject>

- (void)bxs_updateThreeAxisNotifyStatus:(BOOL)notify;

- (void)bxs_clearMotionTriggerCountButtonPressed;

@end

@interface MKBXSAccelerationHeaderView : UIView

@property (nonatomic, weak)id <MKBXSAccelerationHeaderViewDelegate>delegate;

- (void)updateTriggerCount:(NSString *)count;

- (void)updateDataWithXData:(NSString *)xData yData:(NSString *)yData zData:(NSString *)zData;

@end

NS_ASSUME_NONNULL_END
