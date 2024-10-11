//
//  MKBXSSlotFrameTypePickView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2022/7/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MKBXSSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXSSlotFrameTypePickViewDelegate <NSObject>

- (void)bxs_slotFrameTypeChanged:(bxs_slotType)frameType;

@end

@interface MKBXSSlotFrameTypePickView : UIView

@property (nonatomic, weak)id <MKBXSSlotFrameTypePickViewDelegate>delegate;

- (void)updateFrameType:(bxs_slotType)frameType;

@end

NS_ASSUME_NONNULL_END
