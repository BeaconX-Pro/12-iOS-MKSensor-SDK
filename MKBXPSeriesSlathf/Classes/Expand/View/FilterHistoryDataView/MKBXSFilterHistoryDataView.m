//
//  MKBXSFilterHistoryDataView.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/2/22.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSFilterHistoryDataView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

#import "BRDatePickerView.h"

@interface MKBXSFilterHistoryDataView ()

@property (nonatomic, strong)UIView *topLine;

@property (nonatomic, strong)UILabel *startLabel;

@property (nonatomic, strong)UILabel *startDateLabel;

@property (nonatomic, strong)UIButton *startDateButton;

@property (nonatomic, strong)UILabel *endLabel;

@property (nonatomic, strong)UILabel *endDateLabel;

@property (nonatomic, strong)UIButton *endDateButton;

@property (nonatomic, strong)UIButton *startButton;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@end

@implementation MKBXSFilterHistoryDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topLine];
        [self addSubview:self.startLabel];
        [self addSubview:self.startDateLabel];
        [self addSubview:self.startDateButton];
        [self addSubview:self.endLabel];
        [self addSubview:self.endDateLabel];
        [self addSubview:self.endDateButton];
        [self addSubview:self.startButton];
        NSString *date = [self.dateFormatter stringFromDate:[NSDate date]];
        self.startDateLabel.text = date;
        self.endDateLabel.text = date;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [self.startButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(35.f);
    }];
    [self.startDateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.startButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.startLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.startDateButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.startDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.startLabel.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(self.startDateButton.mas_left).mas_offset(-2.f);
        make.centerY.mas_equalTo(self.startDateButton.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.endDateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.startButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(self.startDateButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.endLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.endDateButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.endDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.endLabel.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(self.endDateButton.mas_left).mas_offset(-2.f);
        make.centerY.mas_equalTo(self.endDateButton.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}



#pragma mark - event method
- (void)startDateButtonPressed {
    NSDate *date = [self.dateFormatter dateFromString:self.startDateLabel.text];
    
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeYMDHMS;
    datePickerView.selectDate = date;
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = YES;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSLog(@"选择的值：%@", selectValue);
        NSString *valueDate = [self.dateFormatter stringFromDate:selectDate];
        self.startDateLabel.text = SafeStr(valueDate);
//        if ([self.delegate respondsToSelector:@selector(bxs_dateSelectedView_startDateChanged:)]) {
//            [self.delegate bxs_dateSelectedView_startDateChanged:valueDate];
//        }
    };
    // 设置自定义样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc] init];
    datePickerView.pickerStyle = customStyle;

    // 3.显示
    [datePickerView show];
}

- (void)endDateButtonPressed {
    NSDate *date = [self.dateFormatter dateFromString:self.endDateLabel.text];
    
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc] init];
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeYMDHMS;
    datePickerView.selectDate = date;
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = YES;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSLog(@"选择的值：%@", selectValue);
        NSString *valueDate = [self.dateFormatter stringFromDate:selectDate];
        self.endDateLabel.text = SafeStr(valueDate);
//        if ([self.delegate respondsToSelector:@selector(bxs_dateSelectedView_endDateChanged:)]) {
//            [self.delegate bxs_dateSelectedView_endDateChanged:valueDate];
//        }
    };
    // 设置自定义样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    datePickerView.pickerStyle = customStyle;

    // 3.显示
    [datePickerView show];
}

- (void)startButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxs_dateSelectedView_startPressed:endDate:)]) {
        [self.delegate bxs_dateSelectedView_startPressed:self.startDateLabel.text endDate:self.endDateLabel.text];
    }
}

#pragma mark - getter
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = DEFAULT_TEXT_COLOR;
    }
    return _topLine;
}

- (UILabel *)startLabel {
    if (!_startLabel) {
        _startLabel = [[UILabel alloc] init];
        _startLabel.textAlignment = NSTextAlignmentLeft;
        _startLabel.textColor = DEFAULT_TEXT_COLOR;
        _startLabel.font = MKFont(13.f);
        _startLabel.text = @"Start Date:";
    }
    return _startLabel;
}

- (UILabel *)startDateLabel {
    if (!_startDateLabel) {
        _startDateLabel = [[UILabel alloc] init];
        _startDateLabel.textAlignment = NSTextAlignmentLeft;
        _startDateLabel.textColor = DEFAULT_TEXT_COLOR;
        _startDateLabel.font = MKFont(11.f);
    }
    return _startDateLabel;
}

- (UIButton *)startDateButton {
    if (!_startDateButton) {
        _startDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startDateButton setImage:LOADICON(@"MKBXPSeriesSlathf", @"MKBXSFilterHistoryDataView", @"bxs_calendar.png") forState:UIControlStateNormal];
        [_startDateButton addTarget:self
                             action:@selector(startDateButtonPressed)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _startDateButton;
}

- (UILabel *)endLabel {
    if (!_endLabel) {
        _endLabel = [[UILabel alloc] init];
        _endLabel.textAlignment = NSTextAlignmentLeft;
        _endLabel.textColor = DEFAULT_TEXT_COLOR;
        _endLabel.font = MKFont(13.f);
        _endLabel.text = @"End Date:";
    }
    return _endLabel;
}

- (UILabel *)endDateLabel {
    if (!_endDateLabel) {
        _endDateLabel = [[UILabel alloc] init];
        _endDateLabel.textAlignment = NSTextAlignmentLeft;
        _endDateLabel.textColor = DEFAULT_TEXT_COLOR;
        _endDateLabel.font = MKFont(11.f);
    }
    return _endDateLabel;
}

- (UIButton *)endDateButton {
    if (!_endDateButton) {
        _endDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endDateButton setImage:LOADICON(@"MKBXPSeriesSlathf", @"MKBXSFilterHistoryDataView", @"bxs_calendar.png") forState:UIControlStateNormal];
        [_endDateButton addTarget:self
                           action:@selector(endDateButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _endDateButton;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [MKCustomUIAdopter customButtonWithTitle:@"Start"
                                                         target:self
                                                         action:@selector(startButtonPressed)];
        _startButton.titleLabel.font = MKFont(12.f);
    }
    return _startButton;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    }
    return _dateFormatter;
}

@end
