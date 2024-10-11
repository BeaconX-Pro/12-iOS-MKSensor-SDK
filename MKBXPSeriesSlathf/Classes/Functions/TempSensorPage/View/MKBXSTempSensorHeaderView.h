//
//  MKBXSTempSensorHeaderView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/29.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSTempSensorHeaderViewModel : NSObject

@property (nonatomic, copy)NSString *temperature;

@property (nonatomic, copy)NSString *interval;

@end

@protocol MKBXSTempSensorHeaderViewDelegate <NSObject>

- (void)bxs_thSensorHeaderView_samplingIntervalChanged:(NSString *)interval;

@end

@interface MKBXSTempSensorHeaderView : UIView

@property (nonatomic, strong)MKBXSTempSensorHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKBXSTempSensorHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
