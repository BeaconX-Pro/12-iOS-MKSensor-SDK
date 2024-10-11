//
//  MKBXSRemoteReminderCell.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/27.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSRemoteReminderCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKBXSRemoteReminderCellModel
@end

@interface MKBXSRemoteReminderCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *remindButton;

@end

@implementation MKBXSRemoteReminderCell

+ (MKBXSRemoteReminderCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXSRemoteReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXSRemoteReminderCellIdenty"];
    if (!cell) {
        cell = [[MKBXSRemoteReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSRemoteReminderCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.remindButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.remindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(35.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.remindButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)remindButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxs_remindButtonPressed:)]) {
        [self.delegate bxs_remindButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXSRemoteReminderCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXSRemoteReminderCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UIButton *)remindButton {
    if (!_remindButton) {
        _remindButton = [MKCustomUIAdopter customButtonWithTitle:@"Remind"
                                                          target:self
                                                          action:@selector(remindButtonPressed)];
    }
    return _remindButton;
}

@end
