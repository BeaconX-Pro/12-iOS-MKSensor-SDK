//
//  MKBXSExportDataHeaderView.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/2/19.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSExportDataHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"


@interface MKBXSExportDataHeaderView ()

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UIImageView *synIcon;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)UIButton *deleteButton;

@property (nonatomic, strong)UILabel *deleteLabel;

@property (nonatomic, strong)UIButton *exportButton;

@property (nonatomic, strong)UILabel *exportLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *switchLabel;

@end

@implementation MKBXSExportDataHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_WHITE_MACROS;
        [self addSubview:self.syncButton];
        [self.syncButton addSubview:self.synIcon];
        [self addSubview:self.syncLabel];
        [self addSubview:self.switchButton];
        [self addSubview:self.switchLabel];
        [self addSubview:self.deleteButton];
        [self addSubview:self.deleteLabel];
        [self addSubview:self.exportButton];
        [self addSubview:self.exportLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.synIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.syncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.syncButton.mas_right).mas_offset(20.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.switchButton.mas_left);
        make.right.mas_equalTo(self.switchButton.mas_right);
        make.top.mas_equalTo(self.switchButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.exportButton.mas_left).mas_offset(-35.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.deleteButton.mas_centerX);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.deleteButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.exportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.exportButton.mas_left);
        make.right.mas_equalTo(self.exportButton.mas_right);
        make.top.mas_equalTo(self.exportButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.synIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    //如果是开启监听，则不可切换列表和曲线
    self.switchButton.enabled = !self.syncButton.selected;
    //如果开启监听，则不可删除和导出数据
    self.exportButton.enabled = !self.syncButton.selected;
    self.deleteButton.enabled = !self.syncButton.selected;
    if (self.syncButton.selected) {
        //开始旋转
        [self.synIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
        if (self.switchButton.selected) {
            //已经显示了曲线图，再开始同步数据的时候必须显示列表
            [self switchButtonPressed];
        }
    } else {
        self.syncLabel.text = @"Sync";
    }
    if ([self.delegate respondsToSelector:@selector(bxs_syncButtonPressed:)]) {
        [self.delegate bxs_syncButtonPressed:self.syncButton.selected];
    }
}

- (void)switchButtonPressed {
    self.switchButton.selected = !self.switchButton.selected;
    UIImage *icon = (self.switchButton.selected ? LOADICON(@"MKBXPSeriesSlathf", @"MKBXSExportDataHeaderView", @"bxs_exportHT_curveSelected.png") : LOADICON(@"MKBXPSeriesSlathf", @"MKBXSExportDataHeaderView", @"bxs_exportHT_tableSelected.png"));
    [self.switchButton setImage:icon forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(bxs_switchButtonPressed:)]) {
        [self.delegate bxs_switchButtonPressed:self.switchButton.selected];
    }
}

- (void)deleteButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxs_deleteButtonPressed)]) {
        [self.delegate bxs_deleteButtonPressed];
    }
}

- (void)exportButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxs_exportButtonPressed)]) {
        [self.delegate bxs_exportButtonPressed];
    }
}

#pragma mark - public method
- (void)resetAllStatus {
    self.syncButton.selected = NO;
    [self.synIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    self.syncLabel.text = @"Sync";
    
    self.switchButton.enabled = YES;
    self.switchButton.selected = NO;
    
    self.exportButton.enabled = YES;
    
    self.deleteButton.enabled = YES;
}

#pragma mark - getter
- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_syncButton addTarget:self
                        action:@selector(syncButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _syncButton;
}

- (UIImageView *)synIcon {
    if (!_synIcon) {
        _synIcon = [[UIImageView alloc] init];
        _synIcon.image = LOADICON(@"MKBXPSeriesSlathf", @"MKBXSExportDataHeaderView", @"bxs_threeAxisAcceLoadingIcon.png");
    }
    return _synIcon;
}

- (UILabel *)syncLabel {
    if (!_syncLabel) {
        _syncLabel = [[UILabel alloc] init];
        _syncLabel.textColor = DEFAULT_TEXT_COLOR;
        _syncLabel.textAlignment = NSTextAlignmentCenter;
        _syncLabel.font = MKFont(10.f);
        _syncLabel.text = @"Sync";
    }
    return _syncLabel;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_switchButton setImage:LOADICON(@"MKBXPSeriesSlathf", @"MKBXSExportDataHeaderView", @"bxs_exportHT_tableSelected.png") forState:UIControlStateNormal];
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

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:LOADICON(@"MKBXPSeriesSlathf", @"MKBXSExportDataHeaderView", @"bxs_slotExportDeleteIcon.png") forState:UIControlStateNormal];
        [_deleteButton addTarget:self 
                          action:@selector(deleteButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UILabel *)deleteLabel {
    if (!_deleteLabel) {
        _deleteLabel = [[UILabel alloc] init];
        _deleteLabel.textColor = DEFAULT_TEXT_COLOR;
        _deleteLabel.textAlignment = NSTextAlignmentCenter;
        _deleteLabel.font = MKFont(10.f);
        _deleteLabel.text = @"Erase all";
    }
    return _deleteLabel;
}

- (UIButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exportButton setImage:LOADICON(@"MKBXPSeriesSlathf", @"MKBXSExportDataHeaderView", @"bxs_slotExportEnableIcon.png") forState:UIControlStateNormal];
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

@end
