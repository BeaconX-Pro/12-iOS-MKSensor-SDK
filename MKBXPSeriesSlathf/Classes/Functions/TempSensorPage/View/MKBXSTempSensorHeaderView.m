//
//  MKBXSTempSensorHeaderView.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/29.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSTempSensorHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"
#import "MKTextField.h"

@implementation MKBXSTempSensorHeaderViewModel
@end


@interface MKBXSTempConfigValueView : UIView

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *valueLabel;

@property (nonatomic, strong)UILabel *unitLabel;

@end

@implementation MKBXSTempConfigValueView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftIcon];
        [self addSubview:self.msgLabel];
        [self addSubview:self.valueLabel];
        [self addSubview:self.unitLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.width.mas_equalTo(25.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.valueLabel.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.unitLabel.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(85.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(28.f).lineHeight);
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5.f);
        make.width.mas_equalTo(30.f);
        make.bottom.mas_equalTo(self.valueLabel.mas_bottom);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
    }
    return _leftIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        _valueLabel.textColor = DEFAULT_TEXT_COLOR;
        _valueLabel.font = MKFont(28.f);
    }
    return _valueLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.textColor = DEFAULT_TEXT_COLOR;
        _unitLabel.font = MKFont(12.f);
    }
    return _unitLabel;
}

@end

@interface MKBXSTempSensorHeaderView ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKBXSTempConfigValueView *tempView;

@property (nonatomic, strong)UILabel *samplingLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *unitLabel;

@end

@implementation MKBXSTempSensorHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        [self addSubview:self.backView];
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.tempView];
        [self.backView addSubview:self.samplingLabel];
        [self.backView addSubview:self.textField];
        [self.backView addSubview:self.unitLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(20.f);
        make.bottom.mas_equalTo(-10.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.samplingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.samplingLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(65.f);
        make.top.mas_equalTo(self.tempView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.f);
        make.left.mas_equalTo(self.textField.mas_right).mas_offset(3.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXSTempSensorHeaderViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXSTempSensorHeaderViewModel.class]) {
        return;
    }
    self.tempView.valueLabel.text = SafeStr(_dataModel.temperature);
    self.textField.text = SafeStr(_dataModel.interval);
}


#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.text = @"Real-time data";
    }
    return _msgLabel;
}

- (MKBXSTempConfigValueView *)tempView {
    if (!_tempView) {
        _tempView = [[MKBXSTempConfigValueView alloc] init];
        _tempView.leftIcon.image = LOADICON(@"MKBXPSeriesSlathf", @"MKBXSTempSensorHeaderView", @"bxs_slotConfig_temperatureIcon.png");
        _tempView.msgLabel.text = @"Temperature";
        _tempView.valueLabel.text = @"0.0";
        _tempView.unitLabel.text = @"℃";
    }
    return _tempView;
}

- (UILabel *)samplingLabel {
    if (!_samplingLabel) {
        _samplingLabel = [[UILabel alloc] init];
        _samplingLabel.textColor = DEFAULT_TEXT_COLOR;
        _samplingLabel.textAlignment = NSTextAlignmentLeft;
        _samplingLabel.font = MKFont(13.f);
        _samplingLabel.text = @"Sampling interval";
    }
    return _samplingLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = MKFont(12.f);
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.text = @"1";
        _textField.maxLength = 5;
        _textField.placeholder = @"1~65535";
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxs_thSensorHeaderView_samplingIntervalChanged:)]) {
                [self.delegate bxs_thSensorHeaderView_samplingIntervalChanged:text];
            }
        };
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_textField addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.f);
        }];
    }
    return _textField;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"sec",@"   (1 ~ 65535)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _unitLabel;
}

@end
