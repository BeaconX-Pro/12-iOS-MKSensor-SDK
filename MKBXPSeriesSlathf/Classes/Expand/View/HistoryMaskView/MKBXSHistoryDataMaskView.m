//
//  MKBXSHistoryDataMaskView.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/25.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSHistoryDataMaskView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKTextField.h"

@interface MKBXSHistoryDataMaskView ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *totalLabel;

@property (nonatomic, strong)UILabel *numberLabel;

@end

@implementation MKBXSHistoryDataMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = kAppWindow.bounds;
        [self setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
        [self addSubview:self.backView];
        [self.backView addSubview:self.totalLabel];
        [self.backView addSubview:self.numberLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(80.f);
    }];
    [self.totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    CGFloat width = self.frame.size.width - 2 * 30.f - 2 * 10.f;
    CGSize numberWidth = [NSString sizeWithText:self.numberLabel.text
                                        andFont:self.numberLabel.font
                                     andMaxSize:CGSizeMake(width - 2 * 15.f, MAXFLOAT)];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.totalLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(numberWidth.height);
    }];
}

#pragma mark - public method
- (void)showWithView:(UIView *)view {
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
    [view addSubview:self];
}

- (void)dismiss{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)updateTotalNumber:(NSString *)totalNumber {
    self.totalLabel.text = [NSString stringWithFormat:@"%@%@",@"Total records: ",totalNumber];
}

- (void)updateCurrentNumber:(NSString *)number {
    self.numberLabel.text = [NSString stringWithFormat:@"%@ %@ %@",@"Reading data ... , update ",number,@" records"];
    [self setNeedsLayout];
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [_backView setBackgroundColor:RGBCOLOR(44, 44, 44)];
        [_backView.layer setMasksToBounds:YES];
        [_backView.layer setBorderColor:CUTTING_LINE_COLOR.CGColor];
        [_backView.layer setBorderWidth:0.5f];
        [_backView.layer setCornerRadius:5.f];
    }
    return _backView;
}

- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = COLOR_WHITE_MACROS;
        _totalLabel.font = MKFont(15.f);
        _totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = COLOR_WHITE_MACROS;
        _numberLabel.font = MKFont(15.f);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.numberOfLines = 0;
        _numberLabel.text = @"Reading data ... , update 0 records";
    }
    return _numberLabel;
}

@end
