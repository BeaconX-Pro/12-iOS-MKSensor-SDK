//
//  MKBXSSyncTimeCell.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/24.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSSyncTimeCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKBXSSyncTimeCellModel
@end

@interface MKBXSSyncTimeCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UILabel *dateLabel;

@end

@implementation MKBXSSyncTimeCell

+ (MKBXSSyncTimeCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXSSyncTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXSSyncTimeCellIdenty"];
    if (!cell) {
        cell = [[MKBXSSyncTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSSyncTimeCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.syncButton];
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.syncButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.syncButton.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxs_syncTimeCell_syncTimePressed)]) {
        [self.delegate bxs_syncTimeCell_syncTimePressed];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXSSyncTimeCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXSSyncTimeCellModel.class]) {
        return;
    }
    self.dateLabel.text = SafeStr(_dataModel.date);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Sync Beacon time";
    }
    return _msgLabel;
}

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [MKCustomUIAdopter customButtonWithTitle:@"Sync"
                                                        target:self
                                                        action:@selector(syncButtonPressed)];
    }
    return _syncButton;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = DEFAULT_TEXT_COLOR;
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = MKFont(14.f);
    }
    return _dateLabel;
}

@end
