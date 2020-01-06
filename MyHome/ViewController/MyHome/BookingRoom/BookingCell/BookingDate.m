//
//  BookingDate.m
//  MyHome
//
//  Created by Macbook on 9/27/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "BookingDate.h"
#import "Utils.h"

@implementation BookingDate

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)getTextDate {
    if (self.date) {
        NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
        [calender setTimeZone:[NSTimeZone systemTimeZone]];
        NSDateComponents *components = [calender components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitTimeZone fromDate:self.date];

        NSInteger day = [components day];
        return [NSString stringWithFormat:@"%ld",(long)day];
    }else{
        return @"";
    }
}

- (UIColor *)getTextDateColor {
    if (self.isDisable) {
        return RGB_COLOR(225, 225, 225);
    }else if (self.isSelect) {
        return [UIColor whiteColor];
    }else if (self.isToday) {
        return [UIColor whiteColor];
    }else{
        return [UIColor blackColor];
    }
}

- (NSString *)getTextPrice {
    if (self.date) {
        if (self.isDisable) {
            return @"";
        }else{
            NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self.date];
            if ([component weekday] == 6 || [component weekday] == 7) {
                return self.priceSpecial;
            }else{
                return self.priceNormal;
            }
        }
    }else{
        return @"";
    }
}

- (UIColor *)getTextPriceColor {
    if (self.isSelect) {
        return [UIColor whiteColor];
    }else{
        NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self.date];
        if ([component weekday] == 6 || [component weekday] == 7) {
            return [UIColor purpleColor];
        }else{
            return [UIColor orangeColor];
        }
    }
}

- (UIColor *)getBackgroundColor {
    if (self.isSelect) {
        return RGB_COLOR(84, 125, 190);
    }else{
        return [UIColor clearColor];
    }
}

- (UIColor *)getBackgroundColorViewToDay {
    if (self.isToday) {
        return RGB_COLOR(84, 125, 190);
    }else{
        return [UIColor clearColor];
    }
}

@end
