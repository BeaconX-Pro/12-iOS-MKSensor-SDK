//
//  MKBXSSlotSensorInfoCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSlotSensorInfoCellModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *tagID;

@end

@protocol MKBXSSlotSensorInfoCellDelegate <NSObject>

- (void)bxs_advContent_tagInfo_deviceNameChanged:(NSString *)text;

- (void)bxs_advContent_tagInfo_tagIDChanged:(NSString *)text;

@end

@interface MKBXSSlotSensorInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXSSlotSensorInfoCellModel *dataModel;

@property (nonatomic, weak)id <MKBXSSlotSensorInfoCellDelegate>delegate;

+ (MKBXSSlotSensorInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
