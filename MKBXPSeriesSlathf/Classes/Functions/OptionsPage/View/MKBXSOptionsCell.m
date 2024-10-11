//
//  MKBXSOptionsCell.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSOptionsCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKBXSOptionsCellModel
@end

@interface MKBXSOptionsCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)UIImageView *icon;

@end

@implementation MKBXSOptionsCell

+ (MKBXSOptionsCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXSOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXSOptionsCellIdenty"];
    if (!cell) {
        cell = [[MKBXSOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSOptionsCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.noteLabel];
        [self.contentView addSubview:self.icon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(40.f);
    }];
    CGSize noteSize = [NSString sizeWithText:self.noteLabel.text
                                     andFont:self.noteLabel.font
                                  andMaxSize:CGSizeMake(self.contentView.frame.size.width - 2 * 15.f - 40.f - 5.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.icon.mas_centerY);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXSOptionsCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXSOptionsCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.noteLabel.text = SafeStr(_dataModel.noteMsg);
    self.icon.image = LOADICON(@"MKBXPSeriesSlathf", @"MKBXSOptionsCell", _dataModel.iconName);
}


#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(13.f);
        _noteLabel.textColor = RGBCOLOR(175, 175, 175);
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

@end
