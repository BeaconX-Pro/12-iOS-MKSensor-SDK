//
//  MKBXSSlotUIDCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSlotUIDCellModel : NSObject

@property (nonatomic, copy)NSString *namespaceID;

@property (nonatomic, copy)NSString *instanceID;

@end

@protocol MKBXSSlotUIDCellDelegate <NSObject>

- (void)bxs_advContent_namespaceIDChanged:(NSString *)text;

- (void)bxs_advContent_instanceIDChanged:(NSString *)text;

@end

@interface MKBXSSlotUIDCell : MKBaseCell

@property (nonatomic, strong)MKBXSSlotUIDCellModel *dataModel;

@property (nonatomic, weak)id <MKBXSSlotUIDCellDelegate>delegate;

+ (MKBXSSlotUIDCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
