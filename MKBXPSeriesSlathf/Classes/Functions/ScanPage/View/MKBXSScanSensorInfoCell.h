//
//  MKBXSScanSensorInfoCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2022/7/18.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSScanSensorInfoCellModel : NSObject

@property (nonatomic, assign)BOOL magneticStatus;

@property (nonatomic, copy)NSString *magneticCount;

@property (nonatomic, assign)BOOL triaxialSensor;

@property (nonatomic, assign)BOOL motionStatus;

@property (nonatomic, copy)NSString *motionCount;

@property (nonatomic, copy)NSString *xData;

@property (nonatomic, copy)NSString *yData;

@property (nonatomic, copy)NSString *zData;

@property (nonatomic, assign)BOOL supportTemp;

@property (nonatomic, copy)NSString *temperature;

@property (nonatomic, assign)BOOL supportHumidity;

@property (nonatomic, copy)NSString *humidity;

- (CGFloat)fetchCellHeight;

@end

@interface MKBXSScanSensorInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXSScanSensorInfoCellModel *dataModel;

+ (MKBXSScanSensorInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
