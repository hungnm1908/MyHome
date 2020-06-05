//
//  TextFiledChoseDate.m
//  mBCCS
//
//  Created by HuCuBi on 7/24/17.
//  Copyright © 2017 HuCuBi. All rights reserved.
//

#import "TextFiledChoseDate.h"

@implementation TextFiledChoseDate

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    if (self = [super init])
    {
        [self commonInit];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self commonInit];
//    }
//    return self;
//}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self commonInit];
//    }
//    return self;
//}

- (void)setNumberDayAgo:(CGFloat)numberDayAgo {
//    if (numberDayAgo >= 0) {
        NSDate *oneMonthDateAgo = [[NSDate date] dateByAddingTimeInterval:numberDayAgo*24*60*60];
        self.text = [self formatDate:oneMonthDateAgo];
//    }
}

- (void)commonInit
{
    self.delegate = self;
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDate *currentDate = [NSDate date];
//
//    NSDateComponents *compMax = [[NSDateComponents alloc] init];
//    [compMax setYear:0];
//    [compMax setMonth:0];
//    [compMax setDay:365];
//    NSDate *maxDate = [calendar dateByAddingComponents:compMax toDate:currentDate options:0];
//
//    NSDateComponents *compMin = [[NSDateComponents alloc] init];
//    [compMin setYear:0];
//    [compMin setMonth:0];
//    [compMin setDay:-365];
//    NSDate *minDate = [calendar dateByAddingComponents:compMin toDate:currentDate options:0];

    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(choseDateTo) forControlEvents:UIControlEventValueChanged];
//    [datePicker setMaximumDate:maxDate];
//    [datePicker setMinimumDate:minDate];
    [self setInputView:datePicker];
}

- (void)choseDateTo {
    UIDatePicker *picker = (UIDatePicker*)self.inputView;
    self.text = [self formatDate:picker.date];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self choseDateTo];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

@end
