//
//  MKBXSHallSensorHeaderView.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/24.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSHallSensorHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKBXSHallSensorHeaderViewModel
@end



@interface MKBXSHallSensorHeaderView ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *mtCountLabel;

@property (nonatomic, strong)UILabel *mtCountValueLabel;

@property (nonatomic, strong)UIButton *clearButton;

@end

@implementation MKBXSHallSensorHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        [self addSubview:self.backView];
        [self.backView addSubview:self.mtCountLabel];
        [self.backView addSubview:self.mtCountValueLabel];
        [self.backView addSubview:self.clearButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(44.f);
    }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.mtCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(150.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.mtCountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mtCountLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method

- (void)clearButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxs_hallSensorHeaderView_clearPressed)]) {
        [self.delegate bxs_hallSensorHeaderView_clearPressed];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXSHallSensorHeaderViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXSHallSensorHeaderViewModel.class]) {
        return;
    }
    self.mtCountValueLabel.text = SafeStr(_dataModel.count);
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

- (UILabel *)mtCountLabel {
    if (!_mtCountLabel) {
        _mtCountLabel = [[UILabel alloc] init];
        _mtCountLabel.textColor = DEFAULT_TEXT_COLOR;
        _mtCountLabel.textAlignment = NSTextAlignmentLeft;
        _mtCountLabel.font = MKFont(15.f);
        _mtCountLabel.text = @"Motion trigger count";
    }
    return _mtCountLabel;
}

- (UILabel *)mtCountValueLabel {
    if (!_mtCountValueLabel) {
        _mtCountValueLabel = [[UILabel alloc] init];
        _mtCountValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _mtCountValueLabel.textAlignment = NSTextAlignmentCenter;
        _mtCountValueLabel.font = MKFont(12.f);
        _mtCountValueLabel.text = @"0";
    }
    return _mtCountValueLabel;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [MKCustomUIAdopter customButtonWithTitle:@"Clear"
                                                         target:self
                                                         action:@selector(clearButtonPressed)];
    }
    return _clearButton;
}

@end
