//
//  MKBXSExportTempDataCurveView.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/29.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSExportTempDataCurveView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKBXSTHCurveView.h"

@interface MKBXSExportTempDataCurveView ()

@property (nonatomic, strong)UILabel *totalLabel;

@property (nonatomic, strong)UILabel *displayLabel;

@property (nonatomic, strong)MKBXSTHCurveView *tempView;

@property (nonatomic, strong)MKBXSTHCurveViewModel *tempModel;

@end

@implementation MKBXSExportTempDataCurveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_WHITE_MACROS;
        [self addSubview:self.tempView];
        [self addSubview:self.totalLabel];
        [self addSubview:self.displayLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.totalLabel.mas_bottom).mas_offset(3.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(20.f);
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(-5.f);
    }];
}

#pragma mark - public method
- (void)updateTemperatureDatas:(NSArray <NSString *>*)temperatureList
                temperatureMax:(CGFloat)temperatureMax
                temperatureMin:(CGFloat)temperatureMin
                 completeBlock:(void (^)(void))completeBlock {
    if (!ValidArray(temperatureList)) {
        if (completeBlock) {
            completeBlock();
        }
        return;
    }
    self.totalLabel.text = [@"Total Data Points: " stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)temperatureList.count]];
    NSString *displayText = [NSString stringWithFormat:@"%ld",(long)temperatureList.count];
    if (temperatureList.count > 1000) {
        displayText = @"1000";
    }
    self.displayLabel.text = [@"Window Display Points: " stringByAppendingString:displayText];
    [self.tempView drawCurveWithParamModel:self.tempModel
                                 pointList:temperatureList
                                  maxValue:temperatureMax
                                  minValue:temperatureMin];
    if (completeBlock) {
        completeBlock();
    }
}

#pragma mark - getter
- (MKBXSTHCurveView *)tempView {
    if (!_tempView) {
        _tempView = [[MKBXSTHCurveView alloc] init];
    }
    return _tempView;
}

- (MKBXSTHCurveViewModel *)tempModel {
    if (!_tempModel) {
        _tempModel = [[MKBXSTHCurveViewModel alloc] init];
        _tempModel.curveTitle = @"Temperature(℃)";
        _tempModel.curveViewBackgroundColor = COLOR_WHITE_MACROS;
        _tempModel.lineWidth = 3.f;
        _tempModel.labelColor = RGBCOLOR(136, 136, 136);
    }
    return _tempModel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = [UIColor blueColor];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.font = MKFont(10.f);
        _totalLabel.text = @"Total Data Points: 0";
    }
    return _totalLabel;
}

- (UILabel *)displayLabel {
    if (!_displayLabel) {
        _displayLabel = [[UILabel alloc] init];
        _displayLabel.textColor = [UIColor blueColor];
        _displayLabel.textAlignment = NSTextAlignmentRight;
        _displayLabel.font = MKFont(10.f);
        _displayLabel.text = @"Window Display Points: 0";
    }
    return _displayLabel;
}

@end
