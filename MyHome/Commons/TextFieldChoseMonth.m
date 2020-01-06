//
//  TextFieldChoseMonth.m
//  EVNCPCCSKH
//
//  Created by Macbook on 7/9/19.
//  Copyright © 2019 EVNCPC. All rights reserved.
//

#import "TextFieldChoseMonth.h"

@implementation TextFieldChoseMonth

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setNumberMonthAgo:(CGFloat)numberMonthAgo {
    NSDate *oneMonthDateAgo = [[NSDate date] dateByAddingTimeInterval:numberMonthAgo*30*24*60*60];
    self.text = [self formatDate:oneMonthDateAgo];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM/yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (void)commonInit {
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    [newDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [newDateFormatter setDateFormat:@"yyyy"];
    
    NSString *dateToServer = [newDateFormatter stringFromDate:[NSDate date]];
    
    NSInteger minYear = [dateToServer integerValue] - 3;
    NSInteger maxYear = [dateToServer integerValue];
    
    CDatePickerViewEx *monthPicker = [[CDatePickerViewEx alloc] init];
    [monthPicker selectToday];
    [monthPicker setupMinYear:minYear maxYear:maxYear];
    monthPicker.monthDelegate = self;
    [self setInputView:monthPicker];
}

- (void)didSelectCell:(NSString *)time {
    self.text = time;
}

/*
- (void)commonInit
{
    self.delegate = self;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *compMax = [[NSDateComponents alloc] init];
    [compMax setYear:0];
    [compMax setMonth:0];
    [compMax setDay:0];
    NSDate *maxDate = [calendar dateByAddingComponents:compMax toDate:currentDate options:0];
    
    NSDateComponents *compMin = [[NSDateComponents alloc] init];
    [compMin setYear:0];
    [compMin setMonth:0];
    [compMin setDay:-730];
    NSDate *minDate = [calendar dateByAddingComponents:compMin toDate:currentDate options:0];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(choseDateTo) forControlEvents:UIControlEventValueChanged];
    [datePicker setMaximumDate:maxDate];
    [datePicker setMinimumDate:minDate];
    [self setInputView:datePicker];
}


- (void)choseDateTo {
    UIDatePicker *picker = (UIDatePicker*)self.inputView;
    self.text = [self formatDate:picker.date];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self choseDateTo];
}


 */

@end
