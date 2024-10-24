//
//  MKBXSFilterHTHistoryHeaderView.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/2/23.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSFilterHTHistoryHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"


@interface MKBXSFilterHTHistoryHeaderView ()

@property (nonatomic, strong)UIButton *exportButton;

@property (nonatomic, strong)UILabel *exportLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *switchLabel;

@property (nonatomic, strong)UILabel *sumLabel;

@end

@implementation MKBXSFilterHTHistoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_WHITE_MACROS;
        [self addSubview:self.switchButton];
        [self addSubview:self.switchLabel];
        [self addSubview:self.exportButton];
        [self addSubview:self.exportLabel];
        [self addSubview:self.sumLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.switchButton.mas_left);
        make.right.mas_equalTo(self.switchButton.mas_right);
        make.top.mas_equalTo(self.switchButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.switchButton.mas_right).mas_offset(30.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.exportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.exportButton.mas_left);
        make.right.mas_equalTo(self.exportButton.mas_right);
        make.top.mas_equalTo(self.exportButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.exportButton.mas_right).mas_offset(30.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
}

#pragma mark - event method

- (void)switchButtonPressed {
    self.switchButton.selected = !self.switchButton.selected;
    UIImage *icon = (self.switchButton.selected ? LOADICON(@"MKBXPSeriesSlathf", @"MKBXSFilterHTHistoryHeaderView", @"bxs_exportHT_curveSelected.png") : LOADICON(@"MKBXPSeriesSlathf", @"MKBXSFilterHTHistoryHeaderView", @"bxs_exportHT_tableSelected.png"));
    [self.switchButton setImage:icon forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(bxs_filterHTHistoryHeaderView_switchButtonPressed:)]) {
        [self.delegate bxs_filterHTHistoryHeaderView_switchButtonPressed:self.switchButton.selected];
    }
}

- (void)exportButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxs_filterHTHistoryHeaderView_exportButtonPressed)]) {
        [self.delegate bxs_filterHTHistoryHeaderView_exportButtonPressed];
    }
}

#pragma mark - public method
- (void)updateSumRecord:(NSString *)record {
    self.sumLabel.text = [NSString stringWithFormat:@"Filtered records: %@",SafeStr(record)];
}

#pragma mark - getter

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_switchButton setImage:LOADICON(@"MKBXPSeriesSlathf", @"MKBXSFilterHTHistoryHeaderView", @"bxs_exportHT_tableSelected.png") forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)switchLabel {
    if (!_switchLabel) {
        _switchLabel = [[UILabel alloc] init];
        _switchLabel.textColor = DEFAULT_TEXT_COLOR;
        _switchLabel.textAlignment = NSTextAlignmentCenter;
        _switchLabel.font = MKFont(10.f);
        _switchLabel.text = @"Display";
    }
    return _switchLabel;
}

- (UIButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exportButton setImage:LOADICON(@"MKBXPSeriesSlathf", @"MKBXSFilterHTHistoryHeaderView", @"bxs_slotExportEnableIcon.png") forState:UIControlStateNormal];
        [_exportButton addTarget:self
                          action:@selector(exportButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportButton;
}

- (UILabel *)exportLabel {
    if (!_exportLabel) {
        _exportLabel = [[UILabel alloc] init];
        _exportLabel.textColor = DEFAULT_TEXT_COLOR;
        _exportLabel.textAlignment = NSTextAlignmentCenter;
        _exportLabel.font = MKFont(10.f);
        _exportLabel.text = @"Export";
    }
    return _exportLabel;
}

- (UILabel *)sumLabel {
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] init];
        _sumLabel.textColor = DEFAULT_TEXT_COLOR;
        _sumLabel.textAlignment = NSTextAlignmentLeft;
        _sumLabel.font = MKFont(13.f);
        _sumLabel.text = @"Records: N/A";
    }
    return _sumLabel;
}

@end
