//
//  MKBXSTHSensorHeaderView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/26.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSTHSensorHeaderViewModel : NSObject

@property (nonatomic, copy)NSString *temperature;

@property (nonatomic, copy)NSString *humidity;

@property (nonatomic, copy)NSString *interval;

@end

@protocol MKBXSTHSensorHeaderViewDelegate <NSObject>

- (void)bxs_thSensorHeaderView_samplingIntervalChanged:(NSString *)interval;

@end

@interface MKBXSTHSensorHeaderView : UIView

@property (nonatomic, strong)MKBXSTHSensorHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKBXSTHSensorHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
