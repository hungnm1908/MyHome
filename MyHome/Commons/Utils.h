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

#define kService @"http://api.onmyhome.vn/"
#define kImageLink @"http://onmyhome.vn/"

#define kUpdateRoomInfor @"kUpdateRoomInfor"
#define kUpdateRoomInforProperty @"kUpdateRoomInforProperty"
#define kUpdateRoomInforPrice @"kUpdateRoomInforPrice"
#define kCreateRoomSuccess @"kCreateRoomSuccess"
#define kUpdateCustomerInfo @"kUpdateCustomerInfo"
#define kUpdateBookingRoomStatus @"kUpdateBookingRoomStatus"
#define kUpdateNotification @"kUpdateNotification"
#define kUpdateUserInfo @"kUpdateUserInfo"
#define kUpdateChiaDonChoCheckIn @"kUpdateChiaDonChoCheckIn"

#define kUserDefaultUserName @"kUserName"
#define kUserDefaultToken @"kToken"
#define kUserDefaultUserInfo @"kUserInfo"
#define kUserDefaultPassword @"kPassword"
#define kUserDefaultIsLogin @"kIsLogin"
#define kUserDefaultCodeActive @"kCodeActive"
#define kUserDefaultDeviceToken @"kDeviceTokenNew"
#define kUserDefaultIsSendToken @"kIsSendToken"
#define kUserDefaultCurrentAppVersion @"CurrentAppVersion"
#define kUserDefaultIsClickBanner @"kUserDefaultIsClickBanner"

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

+ (NSDate *)getDateFromStringDate : (NSString *)date;

+ (NSString *)getDayName : (NSDate *)date;

+ (NSInteger)_numberOfDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

+ (NSDate *)_nextDay:(NSDate *)date;

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

+ (void)updateAppInfo;

+ (void)checkAppVersion;

+ (NSData *)generatePostDataForData:(NSData *)uploadData filename:(NSString *)filename;

+ (void)uploadFile:(NSData *)fileData fileName:(NSString *)stringFileName completeBlock:(void(^)(NSString *urlImage))completion;

+ (NSData *)generatePostDataFromArray:(NSArray *)arrayUploadData;

+ (void)uploadFiles:(NSArray *)arrayUploadFile completeBlock:(void(^)(NSString *urlImage))completion;

+ (NSString *)hexadecimalStringFromData:(NSData *)data;

+ (void)checkUpdate;

+ (BOOL)checkFromDateToUpdate : (NSString *)fromDate;

+ (NSDate *)getFirstDayOfThisMonth;

+ (NSDate *)getLastDayOfMonth : (int)number;

+ (BOOL)isTimePromotion : (NSDictionary *)dictG : (NSDate *)cDate;

+ (BOOL)isShowPromotion : (NSDictionary *)dictG;

+ (NSString *)getBalance : (NSDictionary *)dictG;

+ (NSString *)getPrice : (NSDictionary *)dictG;

+ (NSString *)getPriceSpeacil : (NSDictionary *)dictG;

+ (long long)getPriceSpeacilValue : (NSDictionary *)dictG;

+ (long long)getPriceValue : (NSDictionary *)dictG;

+ (void)callSupport : (NSString *)phone;

+ (int)placeInWeekForDate:(NSDate *)date;

+ (void)alertWithNoteTitle : (NSString *)title message: (NSString *)message titleOK: (NSString *)titleOk titleCancel: (NSString *)titleCancel viewController : (UIViewController *)vc completeBlock:(void(^)(NSString *content))block;

@end
