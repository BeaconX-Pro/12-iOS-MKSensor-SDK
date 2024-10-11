//
//  MKBXSScanPageAdopter.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MKBXSBaseBeacon;
@class MKBXScanInfoCellModel;
@interface MKBXSScanPageAdopter : NSObject



/// 将扫描到的beacon数据转换成对应的cellModel
/*
 如果beacon是:
 MKBXSiBeacon:                   iBeacon广播帧(对应的dataModel是MKBXScanBeaconCellModel类型)
 MKBXSTLMBeacon:                 TLM广播帧(对应的dataModel是MKBXScanTLMCellModel类型)
 MKBXSUIDBeacon:                 UID广播帧(对应的dataModel是MKBXScanUIDCellModel类型)
 MKBXSURLBeacon:                 URL广播帧(对应的dataModel是MKBXScanURLCellModel类型)
 MKBXSTagInfoBeacon:             Tag广播帧(对应的dataModel是MKBXSScanSensorInfoCellModel类型)
 
 如果不是其中的一种，则返回nil
 */
/// @param beacon 扫描到的beacon数据
+ (NSObject *)parseBeaconDatas:(MKBXSBaseBeacon *)beacon;

+ (MKBXScanInfoCellModel *)parseBaseBeaconToInfoModel:(MKBXSBaseBeacon *)beacon;

/// 新扫描到的数据已经在列表的数据源中存在，则需要将扫描到的数据结合列表数据源中的数据进行处理
/*
 如果beacon是设备信息帧和TLM帧，直接替换，如果是URL、iBeacon、UID、三轴、温湿度中的一种，则判断数据内容是否和已经存在的信息一致，如果一致，不处理，如果不一致，则直接加入到exsitModel的广播帧数组(advertiseList)里面去
 */
/// @param exsitModel 列表数据源中已经存在的数据
/// @param beacon 刚扫描到的beacon数据
+ (void)updateInfoCellModel:(MKBXScanInfoCellModel *)exsitModel beaconData:(MKBXSBaseBeacon *)beacon;

/// 根据不同的dataModel加载cell
/*
 目前支持
 MKBXScanBeaconCell:        iBeacon广播帧(对应的dataModel是MKBXScanBeaconCellModel类型)
 MKBXScanTLMCell:           TLM广播帧(对应的dataModel是MKBXScanTLMCellModel类型)
 MKBXScanUIDCell:           UID广播帧(对应的dataModel是MKBXScanUIDCellModel类型)
 MKBXScanURLCell:           URL广播帧(对应的dataModel是MKBXScanURLCellModel类型)
 MKBXSScanSensorInfoCell:      Tag信息帧(对应的dataModel是MKBXSScanSensorInfoCellModel类型)
 如果不是其中的一种，则返回一个初始化的UITableViewCell
 */
/// @param tableView tableView
/// @param dataModel dataModel
+ (UITableViewCell *)loadCellWithTableView:(UITableView *)tableView dataModel:(NSObject *)dataModel;

/// 根据不同的dataModel返回cell的高度
/*
 目前支持
 根据UUID动态计算:        iBeacon广播帧(对应的dataModel是MKBXScanBeaconCellModel类型)
 140.f:                 Tag信息帧(对应的dataModel是MKBXSScanSensorInfoCellModel类型)
 110.f:                 TLM广播帧(对应的dataModel是MKBXScanTLMCellModel类型)
 85.f:                  UID广播帧(对应的dataModel是MKBXScanUIDCellModel类型)
 70.f:                  URL广播帧(对应的dataModel是MKBXScanURLCellModel类型)
 如果不是其中的一种，则返回0
 */
/// @param indexPath indexPath
+ (CGFloat)loadCellHeightWithDataModel:(NSObject *)dataModel;

/// 根据传进来的model确定在设备信息帧的dataArray里面的排序号
/*
 0:         MKBXScanUIDCellModel
 1:         MKBXScanURLCellModel
 2:         MKBXScanTLMCellModel
 3:         MKBXScanBeaconCellModel
 4:         MKBXSScanSensorInfoCellModel
 否则返回6，排在最后面
 */
/// @param dataModel dataModel
+ (NSInteger)fetchFrameIndex:(NSObject *)dataModel;

@end

NS_ASSUME_NONNULL_END
