//
//  MKBXSHallSensorHeaderView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/24.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSHallSensorHeaderViewModel : NSObject

@property (nonatomic, copy)NSString *count;

@end

@protocol MKBXSHallSensorHeaderViewDelegate <NSObject>

- (void)bxs_hallSensorHeaderView_clearPressed;

@end

@interface MKBXSHallSensorHeaderView : UIView

@property (nonatomic, strong)MKBXSHallSensorHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKBXSHallSensorHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
