//
//  MKBXSScanTLMCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2025/2/28.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSScanTLMCellModel : NSObject

@property (nonatomic, copy)NSString *version;
@property (nonatomic, assign)NSInteger mvPerbit;
@property (nonatomic, copy)NSString *temperature;
@property (nonatomic, copy)NSString *advertiseCount;
@property (nonatomic, copy)NSString *deciSecondsSinceBoot;

@end

@interface MKBXSScanTLMCell : MKBaseCell

@property (nonatomic, strong)MKBXSScanTLMCellModel *dataModel;

+ (MKBXSScanTLMCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
