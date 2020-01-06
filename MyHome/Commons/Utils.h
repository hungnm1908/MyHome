//
//  Utils.h
//  NoiBaiAirPort
//
//  Created by HuCuBi on 5/23/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#import <sys/utsname.h>

#define RGB_COLOR(r, g, b)                [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define kService @"http://node.f5sell.com/"

typedef enum : NSUInteger {
    typeGioiThieu = 1,
    typeChinhSach = 2,
    typeDaoTao = 3,
    typeTinTuc = 4,
} newsType;

@interface Utils : NSObject

+ (void)configKeyboard;

+ (void)alert:(NSString *)title content:(NSString *)content titleOK:(NSString *)titleOK titleCancel:(NSString *)titleCancel viewController : (UIViewController *)vc completion:(void(^)(void))completion;

+ (void)alertError:(NSString *)title content:(NSString *)content viewController : (UIViewController *)vc completion:(void(^)(void))completion;

+ (void)alertWithCancelProcess:(NSString *)title content:(NSString *)content titleOK:(NSString *)titleOK titleCancel:(NSString *)titleCancel viewController : (UIViewController *)vc completion:(void(^)(void))completion cancel:(void(^)(void))cancel;

+ (float)lenghtText : (NSString *)string;

+ (void)processNotification :(NSDictionary *)userInfo;

+ (NSString *)myDeviceModel;

+ (NSString *)getDateFromDate : (NSDate *)date;

+ (NSString *)convertStringUrl : (NSString *)stringUrl;

+ (UIImage *)scaleImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;

+ (BOOL)checkFromDate : (NSString *)fromDate;

//format định dạng tiền tệ
+ (NSString *)strCurrency:(NSString *)price;

+ (NSString *)convertNumber:(NSString *)number;

+ (NSTimeInterval)getDurationFromDate : (NSString *)fromDate toDate : (NSString *)toDate;

+ (NSString *)changeVietNamese : (NSString *)string;

+ (NSMutableDictionary *)converDictRemoveNullValue : (NSDictionary *)dict;

+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;

+ (void)alertPayBalanceForCTV : (NSDictionary *)dictCTV viewController : (UIViewController *)vc completeBlock:(void(^)(NSString *content))block;

+ (BOOL)checkFromDate : (NSString *)fromDate toDate : (NSString *)toDate view:(UIViewController *)vc;

+ (NSAttributedString *)htmlStringWithContent : (NSString *)content fontName : (NSString *)fontName fontSize : (float)fontSize color :(NSString *)color isCenter : (BOOL) isCenter;

+ (NSString *)convertHTML:(NSString *)html;

@end
