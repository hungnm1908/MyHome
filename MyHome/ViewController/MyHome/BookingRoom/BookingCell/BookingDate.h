//
//  BookingDate.h
//  MyHome
//
//  Created by Macbook on 9/27/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookingDate : NSObject

@property NSDate *date;
@property NSString *priceNormal;
@property NSString *priceSpecial;
@property BOOL isDisable;
@property BOOL isDisableFirstDate;
@property BOOL isDisableEndDate;
@property BOOL isToday;
@property BOOL isSelect;
@property BOOL isBillingFirstDate;
@property BOOL isBillingEndDate;
@property BOOL isDiscountDate;
@property NSString *priceNormalCurrent;
@property NSString *priceSpecialCurrent;

- (NSString *)getTextDate;
- (UIColor *)getTextDateColor;

- (NSString *)getTextPrice;
- (UIColor *)getTextPriceColor;

- (UIColor *)getBackgroundColor;
- (UIColor *)getBackgroundColorViewToDay;

- (UIColor *)getDisableStartViewColor;
- (UIColor *)getDisableEndViewColor;

- (NSString *)getTextCurrentPrice;

@end

NS_ASSUME_NONNULL_END
