//
//  MKBXSScanSensorInfoCell.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2022/7/18.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSScanSensorInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBXSScanSensorInfoCellModel

- (CGFloat)fetchCellHeight {
    if (self.triaxialSensor) {
        //支持三轴
        if (self.supportTemp && self.supportHumidity) {
            //支持温湿度
            return 170.f;
        }
        if ((self.supportTemp && !self.supportHumidity) || (!self.supportTemp && self.supportHumidity)) {
            //支持温度或者湿度
            return 155.f;
        }
        //不支持温湿度
        return 130.f;
    }
    //不支持三轴
    if (self.supportTemp && self.supportHumidity) {
        //支持温湿度
        return 110.f;
    }
    if ((self.supportTemp && !self.supportHumidity) || (!self.supportTemp && self.supportHumidity)) {
        //支持温度或者湿度
        return 115.f;
    }
    //都不支持
    return 70.f;
}

@end

@interface MKBXSScanSensorInfoCell ()

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *msLabel;

@property (nonatomic, strong)UILabel *msValueLabel;

@property (nonatomic, strong)UILabel *mtcLabel;

@property (nonatomic, strong)UILabel *mtcValueLabel;

@property (nonatomic, strong)UILabel *mosLabel;

@property (nonatomic, strong)UILabel *mosValueLabel;

@property (nonatomic, strong)UILabel *motcLabel;

@property (nonatomic, strong)UILabel *motcValueLabel;

@property (nonatomic, strong)UILabel *accLabel;

@property (nonatomic, strong)UILabel *accValueLabel;

@property (nonatomic, strong)UILabel *tempLabel;

@property (nonatomic, strong)UILabel *tempValueLabel;

@property (nonatomic, strong)UILabel *humidityLabel;

@property (nonatomic, strong)UILabel *humidityValueLabel;

@end

@implementation MKBXSScanSensorInfoCell

+ (MKBXSScanSensorInfoCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXSScanSensorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXSScanSensorInfoCellIdenty"];
    if (!cell) {
        cell = [[MKBXSScanSensorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSScanSensorInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.msLabel];
        [self.contentView addSubview:self.msValueLabel];
        [self.contentView addSubview:self.mtcLabel];
        [self.contentView addSubview:self.mtcValueLabel];
        
        
        [self.contentView addSubview:self.humidityLabel];
        [self.contentView addSubview:self.humidityValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(7.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(7.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.msLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.msValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.msLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.mtcLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.msLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.mtcValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.mtcLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXSScanSensorInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXSScanSensorInfoCellModel.class]) {
        return;
    }
    self.msValueLabel.text = (_dataModel.magneticStatus ? @"Open" : @"Closed");
    self.mtcValueLabel.text = SafeStr(_dataModel.magneticCount);
    [self setupTriaxialSensor];
    [self setupTemperatureSensor];
    [self setupHumiditySensor];
}

#pragma mark - Private method

- (void)setupTriaxialSensor {
    if (self.mosLabel.superview) {
        [self.mosLabel removeFromSuperview];
    }
    if (self.mosValueLabel.superview) {
        [self.mosValueLabel removeFromSuperview];
    }
    if (self.motcLabel.superview) {
        [self.motcLabel removeFromSuperview];
    }
    if (self.motcValueLabel.superview) {
        [self.motcValueLabel removeFromSuperview];
    }
    if (self.accLabel.superview) {
        [self.accLabel removeFromSuperview];
    }
    if (self.accValueLabel.superview) {
        [self.accValueLabel removeFromSuperview];
    }
    
    if (!self.dataModel.triaxialSensor) {
        //当前设备不支持三轴
        return;
    }
    [self.contentView addSubview:self.mosLabel];
    [self.contentView addSubview:self.mosValueLabel];
    [self.contentView addSubview:self.motcLabel];
    [self.contentView addSubview:self.motcValueLabel];
    [self.contentView addSubview:self.accLabel];
    [self.contentView addSubview:self.accValueLabel];
    
    [self.mosLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.mtcLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.mosValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.mosLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.motcLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.mosLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.motcValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.motcLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.accLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.motcLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.accValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.accLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
    self.mosValueLabel.text = (self.dataModel.motionStatus ? @"In progress" : @"No Movement");
    self.motcValueLabel.text = SafeStr(self.dataModel.motionCount);
    self.accValueLabel.text = [NSString stringWithFormat:@"X: %@mg;Y: %@mg;Z: %@mg",SafeStr(self.dataModel.xData),SafeStr(self.dataModel.yData),SafeStr(self.dataModel.zData)];
}

- (void)setupTemperatureSensor {
    if (self.tempLabel.superview) {
        [self.tempLabel removeFromSuperview];
    }
    if (self.tempValueLabel.superview) {
        [self.tempValueLabel removeFromSuperview];
    }
    if (!self.dataModel.supportTemp) {
        //当前设备不支持温度
        return;
    }
    [self.contentView addSubview:self.tempLabel];
    [self.contentView addSubview:self.tempValueLabel];
    
    self.tempValueLabel.text = [NSString stringWithFormat:@"%@%@",self.dataModel.temperature,@"℃"];
    
    if (!self.dataModel.triaxialSensor) {
        //不支持三轴
        [self.tempLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.msgLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
            make.top.mas_equalTo(self.mtcLabel.mas_bottom).mas_offset(5.f);
            make.height.mas_equalTo(MKFont(12.f).lineHeight);
        }];
        [self.tempValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_centerX);
            make.right.mas_equalTo(-15.f);
            make.centerY.mas_equalTo(self.tempLabel.mas_centerY);
            make.height.mas_equalTo(MKFont(12.f).lineHeight);
        }];
        return;
    }
    //带三轴
    [self.tempLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.accLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.tempValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.tempLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

- (void)setupHumiditySensor {
    if (self.humidityLabel.superview) {
        [self.humidityLabel removeFromSuperview];
    }
    if (self.humidityValueLabel.superview) {
        [self.humidityValueLabel removeFromSuperview];
    }
    if (!self.dataModel.supportHumidity) {
        //当前设备不支持温度
        return;
    }
    [self.contentView addSubview:self.humidityLabel];
    [self.contentView addSubview:self.humidityValueLabel];
    
    self.humidityValueLabel.text = [NSString stringWithFormat:@"%@%@",self.dataModel.humidity,@"%RH"];
    if (self.dataModel.supportTemp) {
        //支持温度
        [self.humidityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.msgLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
            make.top.mas_equalTo(self.tempLabel.mas_bottom).mas_offset(5.f);
            make.height.mas_equalTo(MKFont(12.f).lineHeight);
        }];
        [self.humidityValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_centerX);
            make.right.mas_equalTo(-15.f);
            make.centerY.mas_equalTo(self.humidityLabel.mas_centerY);
            make.height.mas_equalTo(MKFont(12.f).lineHeight);
        }];
        return;
    }
    //下面的全部为不支持温度
    if (!self.dataModel.triaxialSensor) {
        //不支持三轴
        [self.humidityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.msgLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
            make.top.mas_equalTo(self.mtcLabel.mas_bottom).mas_offset(5.f);
            make.height.mas_equalTo(MKFont(12.f).lineHeight);
        }];
        [self.humidityValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_centerX);
            make.right.mas_equalTo(-15.f);
            make.centerY.mas_equalTo(self.humidityLabel.mas_centerY);
            make.height.mas_equalTo(MKFont(12.f).lineHeight);
        }];
        return;
    }
    if (self.dataModel.triaxialSensor) {
        //支持三轴
        [self.humidityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.msgLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
            make.top.mas_equalTo(self.accLabel.mas_bottom).mas_offset(5.f);
            make.height.mas_equalTo(MKFont(12.f).lineHeight);
        }];
        [self.humidityValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_centerX);
            make.right.mas_equalTo(-15.f);
            make.centerY.mas_equalTo(self.humidityLabel.mas_centerY);
            make.height.mas_equalTo(MKFont(12.f).lineHeight);
        }];
        return;
    }
}

#pragma mark - getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = LOADICON(@"MKBXPSeriesSlathf", @"MKBXSScanSensorInfoCell", @"bxs_littleBluePoint.png");
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Sensor info";
    }
    return _msgLabel;
}

- (UILabel *)msLabel {
    if (!_msLabel) {
        _msLabel = [self createLabel];
        _msLabel.text = @"Door magnetic status";
    }
    return _msLabel;
}

- (UILabel *)msValueLabel {
    if (!_msValueLabel) {
        _msValueLabel = [self createLabel];
    }
    return _msValueLabel;
}

- (UILabel *)mtcLabel {
    if (!_mtcLabel) {
        _mtcLabel = [self createLabel];
        _mtcLabel.text = @"Magnetic trigger count";
    }
    return _mtcLabel;
}

- (UILabel *)mtcValueLabel {
    if (!_mtcValueLabel) {
        _mtcValueLabel = [self createLabel];
    }
    return _mtcValueLabel;
}

- (UILabel *)mosLabel {
    if (!_mosLabel) {
        _mosLabel = [self createLabel];
        _mosLabel.text = @"Motion status";
    }
    return _mosLabel;
}

- (UILabel *)mosValueLabel {
    if (!_mosValueLabel) {
        _mosValueLabel = [self createLabel];
    }
    return _mosValueLabel;
}

- (UILabel *)motcLabel {
    if (!_motcLabel) {
        _motcLabel = [self createLabel];
        _motcLabel.text = @"Motion trigger count";
    }
    return _motcLabel;
}

- (UILabel *)motcValueLabel {
    if (!_motcValueLabel) {
        _motcValueLabel = [self createLabel];
    }
    return _motcValueLabel;
}

- (UILabel *)accLabel {
    if (!_accLabel) {
        _accLabel = [self createLabel];
        _accLabel.text = @"Acceleration";
    }
    return _accLabel;
}

- (UILabel *)accValueLabel {
    if (!_accValueLabel) {
        _accValueLabel = [self createLabel];
    }
    return _accValueLabel;
}

- (UILabel *)tempLabel {
    if (!_tempLabel) {
        _tempLabel = [self createLabel];
        _tempLabel.text = @"Temperature";
    }
    return _tempLabel;
}

- (UILabel *)tempValueLabel {
    if (!_tempValueLabel) {
        _tempValueLabel = [self createLabel];
    }
    return _tempValueLabel;
}

- (UILabel *)humidityLabel {
    if (!_humidityLabel) {
        _humidityLabel = [self createLabel];
        _humidityLabel.text = @"Humidity";
    }
    return _humidityLabel;
}

- (UILabel *)humidityValueLabel {
    if (!_humidityValueLabel) {
        _humidityValueLabel = [self createLabel];
    }
    return _humidityValueLabel;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = MKFont(10.f);
    return label;
}

@end
