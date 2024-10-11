//
//  MKBXSSlotBeaconCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSlotBeaconCellModel : NSObject

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

@end

@protocol MKBXSSlotBeaconCellDelegate <NSObject>

- (void)bxs_advContent_majorChanged:(NSString *)major;

- (void)bxs_advContent_minorChanged:(NSString *)minor;

- (void)bxs_advContent_uuidChanged:(NSString *)uuid;

@end

@interface MKBXSSlotBeaconCell : MKBaseCell

@property (nonatomic, strong)MKBXSSlotBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKBXSSlotBeaconCellDelegate>delegate;

+ (MKBXSSlotBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
