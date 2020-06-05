//
//  Utils.m
//  NoiBaiAirPort
//
//  Created by HuCuBi on 5/23/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import "Utils.h"
#import "IQKeyboardManager.h"
#import <sys/utsname.h>
#import "AppDelegate.h"
#import <SSKeychain/SSKeychain.h>
#import "CallAPI.h"

@implementation Utils
    
+ (void)configKeyboard {
    //ONE LINE OF CODE.
    //Enabling keyboard manager(Use this line to enable managing distance between keyboard & textField/textView).
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    //(Optional)Set Distance between keyboard & textField, Default is 10.
    //[[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    
    //(Optional)Enable autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard. Default is NO.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //(Optional)Setting toolbar behaviour to IQAutoToolbarBySubviews to manage previous/next according to UITextField's hierarchy in it's SuperView. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order. Default is `IQAutoToolbarBySubviews`.
    //[[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //(Optional)Resign textField if touched outside of UITextField/UITextView. Default is NO.
    //[[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //(Optional)Giving permission to modify TextView's frame. Default is NO.
    //[[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    
    //(Optional)Show TextField placeholder texts on autoToolbar. Default is NO.
    //    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
    [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:YES];
}

+ (void)alertError:(NSString *)title content:(NSString *)content viewController : (UIViewController *)vc completion:(void(^)(void))completion {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:content
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *btnCancel = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    completion();
                                }];
    [alert addAction:btnCancel];
    
    if (vc) {
        [vc presentViewController:alert animated:YES completion:nil];
    }else{
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
    }
}
    
    //Thông báo alert
+ (void)alert:(NSString *)title content:(NSString *)content titleOK:(NSString *)titleOK titleCancel:(NSString *)titleCancel viewController : (UIViewController *)vc completion:(void(^)(void))completion {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:content
                                preferredStyle:UIAlertControllerStyleAlert];
    
    if ([title isEqualToString:NSLocalizedString(@"Warning", nil)]) {
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:25.0]
                      range:NSMakeRange(0, title.length)];
        [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, title.length)];
        [alert setValue:hogan forKey:@"attributedTitle"];
    }
    
    if (titleCancel) {
        UIAlertAction *btnCancel = [UIAlertAction
                                    actionWithTitle:titleCancel
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
        [alert addAction:btnCancel];
        [btnCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    }
    
    if (titleOK) {
        UIAlertAction *btnOK = [UIAlertAction
                                actionWithTitle:titleOK
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    completion();
                                }];
        [alert addAction:btnOK];
    }
    
    if (vc) {
        [vc presentViewController:alert animated:YES completion:nil];
    }else{
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)alertWithCancelProcess:(NSString *)title content:(NSString *)content titleOK:(NSString *)titleOK titleCancel:(NSString *)titleCancel viewController : (UIViewController *)vc completion:(void(^)(void))completion cancel:(void(^)(void))cancel {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:content
                                preferredStyle:UIAlertControllerStyleAlert];
    
    if ([title isEqualToString:NSLocalizedString(@"Warning", nil)]) {
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:25.0]
                      range:NSMakeRange(0, title.length)];
        [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, title.length)];
        [alert setValue:hogan forKey:@"attributedTitle"];
    }
    
    if (titleCancel) {
        UIAlertAction *btnCancel = [UIAlertAction
                                    actionWithTitle:titleCancel
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        cancel();
                                    }];
        [alert addAction:btnCancel];
        [btnCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    }
    
    if (titleOK) {
        UIAlertAction *btnOK = [UIAlertAction
                                actionWithTitle:titleOK
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    completion();
                                }];
        [alert addAction:btnOK];
    }
    
    if (vc) {
        [vc presentViewController:alert animated:YES completion:nil];
    }else{
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)alertPayBalanceForCTV : (NSDictionary *)dictCTV viewController : (UIViewController *)vc completeBlock:(void(^)(NSString *content))block {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Thanh toán hoa hồng"
                                                                              message: [NSString stringWithFormat:@"Nhập vào số tiền hoa hồng bạn đã thanh toán cho CTV %@",dictCTV[@"FULL_NAME"]]
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Số tiền đã thanh toán";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Nội dung thanh toán";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    UIAlertAction *btnOK = [UIAlertAction
                            actionWithTitle:@"Cập nhật"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                NSArray * textfields = alertController.textFields;
                                UITextField * namefield = textfields[0];
                                NSLog(@"%@",namefield.text);
                                block(namefield.text);
                            }];
    [alertController addAction:btnOK];
    
    UIAlertAction *btnCancel = [UIAlertAction
                                actionWithTitle:@"Hủy bỏ"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    [alertController dismissViewControllerAnimated:YES completion:nil];
                                }];
    [alertController addAction:btnCancel];
    [btnCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    if (vc) {
        [vc presentViewController:alertController animated:YES completion:nil];
    }else{
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alertController animated:YES completion:nil];
    }
}

+ (void)alertWithNoteTitle : (NSString *)title message: (NSString *)message titleOK: (NSString *)titleOk titleCancel: (NSString *)titleCancel viewController : (UIViewController *)vc completeBlock:(void(^)(NSString *content))block {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: title
                                                                              message: message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Nội dung lời nhắn";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    UIAlertAction *btnOK = [UIAlertAction
                            actionWithTitle:titleOk
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                NSArray * textfields = alertController.textFields;
                                UITextField * namefield = textfields[0];
                                NSLog(@"%@",namefield.text);
                                block(namefield.text);
                            }];
    [alertController addAction:btnOK];
    
    UIAlertAction *btnCancel = [UIAlertAction
                                actionWithTitle:titleCancel
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    [alertController dismissViewControllerAnimated:YES completion:nil];
                                }];
    [alertController addAction:btnCancel];
    [btnCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    
    if (vc) {
        [vc presentViewController:alertController animated:YES completion:nil];
    }else{
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alertController animated:YES completion:nil];
    }
}
    
+ (float)lenghtText : (NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {
        NSString *result = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string isEqualToString:@"null"]) {
            result = @"";
        }
        
        return result.length;
    }else{
        return 0;
    }
}

+ (void)processNotification :(NSDictionary *)userInfo {
    UITabBarController *tabBar = (UITabBarController *)[self appDelegate].window.rootViewController;
    
    int type = [userInfo[@"type"] intValue] ;
    
    if (type == 2 || type == 3 || type == 4 || type == 5 || type == 6 || type == 7) {
        [tabBar setSelectedIndex:1];
    }else if (type == 8) {
        [tabBar setSelectedIndex:2];
    }else if (type == 9) {
        [tabBar setSelectedIndex:3];
    }else{
        
    }
}

+ (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (NSString *)myDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *myDeviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ListIphone" ofType:@"plist"];
    NSArray *listIphone = [[NSArray arrayWithContentsOfFile:plistPath]copy];
    
    for (NSDictionary *dic in listIphone) {
        NSString *model = [dic valueForKey:@"model"];
        if ([myDeviceModel isEqualToString:model]) {
            myDeviceModel = [dic valueForKey:@"iPhone"];
        }
    }
    
    return myDeviceModel;
}

+ (NSString *)getDateFromDate : (NSDate *)date {
    NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
    [clientDateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *clientDate = [clientDateFormatter stringFromDate:date];
    
    return clientDate;
}

+ (NSDate *)getDateFromStringDate : (NSString *)date {
    NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
    [clientDateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *clientDate = [clientDateFormatter dateFromString:date];
    
    if (clientDate == nil) {
        [clientDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.000Z'"];
        clientDate = [clientDateFormatter dateFromString:date];
    }
    
    return clientDate;
}

+ (NSString *)getDayName : (NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayName = [dateFormatter stringFromDate:date];
    
    if ([dayName isEqualToString:@"Monday"]) {
        dayName = @"Thứ Hai";
    }else if ([dayName isEqualToString:@"Tuesday"]) {
        dayName = @"Thứ Ba";
    }else if ([dayName isEqualToString:@"Wednesday"]) {
        dayName = @"Thứ Tư";
    }else if ([dayName isEqualToString:@"Thursday"]) {
        dayName = @"Thứ Năm";
    }else if ([dayName isEqualToString:@"Friday"]) {
        dayName = @"Thứ Sáu";
    }else if ([dayName isEqualToString:@"Saturday"]) {
        dayName = @"Thứ Bẩy";
    }else if ([dayName isEqualToString:@"Sunday"]) {
        dayName = @"Chủ Nhật";
    }
    
    return dayName;
}

+ (NSInteger)_numberOfDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    [calender setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger startDay = [calender ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:startDate];
    NSInteger endDay = [calender ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:endDate];
    return endDay - startDay;
}

+ (NSDate *)_nextDay:(NSDate *)date {
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    [calender setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [calender dateByAddingComponents:comps toDate:date options:0];
}

//Sửa các link bị lỗi font
+ (NSString *)convertStringUrl : (NSString *)stringUrl {
    if (![stringUrl isKindOfClass:[NSNull class]] && stringUrl.length > 0) {
        NSString *linkImage = @"";
        if ([stringUrl hasPrefix:@"https://"]) {
            linkImage = @"https://";
        }else if ([stringUrl hasPrefix:@"http://"]) {
            linkImage = @"http://";
        }
        NSArray *arrayStr = [[stringUrl stringByReplacingOccurrencesOfString:linkImage withString:@""] componentsSeparatedByString:@"/"];
        NSString *escapedString = @"";
        
        for (NSString *str in arrayStr) {
            NSString *strCon = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            escapedString = [[escapedString stringByAppendingString:@"/"] stringByAppendingString:strCon];
        }
        
        escapedString = [escapedString substringFromIndex:1];
        escapedString = [escapedString stringByReplacingOccurrencesOfString:@"%3F" withString:@"?"];
        escapedString = [escapedString stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
        return [linkImage stringByAppendingString:escapedString];
    }else{
        return @"";
    }
}

+ (UIImage *)scaleImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(newSize / image.size.width, newSize / image.size.width);
    CGPoint origin = CGPointMake(0, 0);
    
    float newHeight = image.size.height * newSize / image.size.width;
    
    CGSize size = CGSizeMake(newSize, newHeight);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (BOOL)checkFromDate : (NSString *)fromDate  {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateFrom = [dateFormatter dateFromString:fromDate];

    if([[NSDate date] timeIntervalSinceDate:dateFrom] > 0.5*24*60*60) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)checkFromDateToUpdate : (NSString *)fromDate  {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *dateFrom = [dateFormatter dateFromString:fromDate];

    if([[NSDate date] timeIntervalSinceDate:dateFrom] > 0) {
        return YES;
    }else{
        return NO;
    }
    
}

+ (NSTimeInterval)getDurationFromDate : (NSString *)fromDate toDate : (NSString *)toDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss'.0'"];
    NSDate *dateFrom = [dateFormatter dateFromString:fromDate];
    NSDate *dateTo = [dateFormatter dateFromString:toDate];
    
    if (!dateFrom && !dateTo) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.000Z'"];
        dateFrom = [dateFormatter dateFromString:fromDate];
        dateTo = [dateFormatter dateFromString:toDate];
    }
    
    if (!dateFrom && !dateTo) {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        dateFrom = [dateFormatter dateFromString:fromDate];
        dateTo = [dateFormatter dateFromString:toDate];
    }
    
    return [dateFrom timeIntervalSinceDate:dateTo];
}


//format định dạng tiền tệ
+ (NSString *)strCurrency:(NSString *)price{
    price = [NSString stringWithFormat:@"%@",price];
    
    if (price.length == 0) {
        return @"0";
    }else{
        NSString *price1 = [price stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *numberPrice = [[NSNumber alloc]initWithLongLong:[price1 longLongValue]];
        NSString *strPrice = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:numberPrice]];
        strPrice = [strPrice stringByReplacingOccurrencesOfString:@"," withString:@"."];
        return strPrice;
    }
}

+ (NSString *)convertNumber : (NSString *)number {
    long long quantity = [number longLongValue];
    
    if (quantity < 1000) {
        return [NSString stringWithFormat:@"%lld",quantity];
    }else if (quantity >= 1000 && quantity < 1000000) {
        return [NSString stringWithFormat:@"%.0fK",(float)quantity/1000];
    }else{
        return [NSString stringWithFormat:@"%.3fK",(float)quantity/1000000];
    }
}

+ (NSString *)changeVietNamese : (NSString *)string {
    NSString *standard = [string stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    standard = [standard stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    NSData *decode = [standard dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *ansi = [[NSString alloc] initWithData:decode encoding:NSASCIIStringEncoding];
    //        NSLog(@"ANSI: %@", ansi);
    return ansi;
}

+ (NSMutableDictionary *)converDictRemoveNullValue : (NSDictionary *)dict {
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    for (NSString * key in [dict allKeys]) {
        if (![[dict objectForKey:key] isKindOfClass:[NSNull class]]){
            [newDict setObject:[dict objectForKey:key] forKey:key];
        }else{
            [newDict setObject:@"" forKey:key];
        }
    }
    
    return newDict;
}

+ (BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmail = [emailTest evaluateWithObject:checkString];
    return isEmail;
}

+ (BOOL)checkFromDate : (NSString *)fromDate toDate : (NSString *)toDate view:(UIViewController *)vc {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *dateFrom = [dateFormatter dateFromString:fromDate];
    NSDate *dateTo = [dateFormatter dateFromString:toDate];
    
    if (fromDate.length == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn ngày bắt đầu" viewController:vc completion:^{
            
        }];
        return NO;
    }else if (toDate.length == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn ngày kết thúc" viewController:vc completion:^{
            
        }];
        return NO;
    }else{
        if( [dateFrom timeIntervalSinceDate:dateTo] > 0 ) {
            [Utils alertError:@"Thời gian không hợp lệ" content:@"Ngày bắt đầu phải trước ngày kết thúc" viewController:vc completion:^{
                
            }];
            return NO;
        }else{
            return YES;
        }
    }
}

+ (NSAttributedString *)htmlStringWithContent : (NSString *)content fontName : (NSString *)fontName fontSize : (float)fontSize color :(NSString *)color isCenter : (BOOL) isCenter {
    if ([content isKindOfClass:[NSString class]]) {
        NSString *htmlStr = [content stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&#92;" withString:@"\\"];
        
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        if (!font) {
            font = [UIFont systemFontOfSize:fontSize];
            //        font = [UIFont boldSystemFontOfSize:fontSize];
        }
        
        htmlStr = [htmlStr stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;color:#%@;}</style>",font.fontName,font.pointSize,color]];
        
        NSString * htmlString = [NSString stringWithFormat:@"<html><body> %@ </body></html>",htmlStr];
        if (isCenter) {
            htmlString = [NSString stringWithFormat:@"<center>%@</center>",htmlString];
        }
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        return attrStr;
    }else{
        return [[NSAttributedString alloc] initWithString:@""];
    }
}

+ (NSString *)convertHTML:(NSString *)html {
    if ([html isKindOfClass:[NSString class]]) {
        //
        //    NSScanner *myScanner;
        //    NSString *text = nil;
        //    myScanner = [NSScanner scannerWithString:html];
        //
        //    while ([myScanner isAtEnd] == NO) {
        //
        //        [myScanner scanUpToString:@"<" intoString:NULL] ;
        //
        //        [myScanner scanUpToString:@">" intoString:&text] ;
        //
        //        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        //    }
        //    //
        //    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSAttributedString *test = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
        html = [test string];
        
        return html;
    }else{
        return @"";
    }
}

+ (void)checkAppVersion {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultCurrentAppVersion];
    
    if (![appVersion isEqualToString:currentVersion]) {
        [self updateAppInfo];
    }
}

+ (void)updateAppInfo {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName];
    NSString *osVersion = [NSString stringWithFormat:@"%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultDeviceToken];
    NSString *deviceModel = [Utils myDeviceModel];
    NSString *uuid = [Utils getUniqueDeviceIdentifierAsString];
    
    NSDictionary *param = @{@"USERNAME":userName?userName:@"",
                            @"VERSION":appVersion,
                            @"DEVICE_MODEL":deviceModel,
                            @"DEVICE_TYPE":@"1",
                            @"OS_VERSION":osVersion,
                            @"TOKEN_KEY":deviceToken?deviceToken:@"",
                            @"UUID":uuid
                            };
    
    [CallAPI callApiService:@"user/update_device" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        if (deviceToken) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsSendToken];
        }
        [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:kUserDefaultCurrentAppVersion];
    }];
}

+ (NSString *)getUniqueDeviceIdentifierAsString {
    
    NSString *appID=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appID account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appID account:@"incoding"];
    }
    
    return strApplicationUUID;
}

+ (NSData *)generatePostDataForData:(NSData *)uploadData filename:(NSString *)filename {
    // Generate the post header
    NSString *post = [NSString stringWithCString:"--AaB03x\r\nContent-Disposition: form-data; name=\"file\"; filename=\"myfilenamehere1234\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" encoding:NSASCIIStringEncoding];
    
    post=[post stringByReplacingOccurrencesOfString:@"myfilenamehere1234" withString:filename];
    // Get the post header int ASCII format:
    NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // Generate the mutable data variable:
    NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] ];
    [postData setData:postHeaderData];
    
    // Add the image:
    [postData appendData: uploadData];
    
    // Add the closing boundry:
    [postData appendData: [@"\r\n--AaB03x--" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    // Return the post data:
    return postData;
}

+ (NSData *)generatePostDataFromArray:(NSArray *)arrayUploadData {
    NSMutableData *finalPostData = [[NSMutableData alloc] init];
    NSString *boundary = @"AaB03x";
    [finalPostData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    int i=0;
    for(NSDictionary *dict in arrayUploadData) {
        if (dict[@"imge"]) {
            long CurrentTime = [[NSDate date] timeIntervalSince1970] + i;
            NSString *strNameImage = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%ld.png\"\r\n",CurrentTime];
            [finalPostData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [finalPostData appendData:[strNameImage dataUsingEncoding:NSUTF8StringEncoding]];
            [finalPostData appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSData *imageData = UIImagePNGRepresentation(dict[@"imge"]);
            [finalPostData appendData:[NSData dataWithData:imageData]];
            [finalPostData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            i++;
        }
    }
    
    [finalPostData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString* newStr2 = [[NSString alloc] initWithData:finalPostData encoding:NSASCIIStringEncoding];
    return finalPostData;
}

+ (void)uploadFiles:(NSArray *)arrayUploadFile completeBlock:(void(^)(NSString *urlImage))completion {
    [SVProgressHUD show];
    NSData *postData = [Utils generatePostDataFromArray:arrayUploadFile];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *url = @"http://onmyhome.vn/UploadFileResize";
//    NSString *url = @"http://onmyhome.vn/UploadAvaResize";
    
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
    [uploadRequest setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:uploadRequest
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [SVProgressHUD dismiss];
                                                        NSLog(@"\n%@\n%@",url,error);
                                                        [Utils alertError:@"Lỗi kết nối" content:@"Đề nghị kiểm tra wifi hoặc kết nối dữ liệu của thiết bị" viewController:nil completion:^{
                                                            
                                                        }];
                                                    } else {
                                                        [SVProgressHUD dismiss];
                                                        NSString* urlImage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        NSLog(@"\n%@\n%@",url,urlImage);
                                                        completion(urlImage);
                                                    }
                                                }];
    [dataTask resume];
}

+ (void)uploadFile:(NSData *)fileData fileName:(NSString *)stringFileName completeBlock:(void(^)(NSString *urlImage))completion {
    if (fileData && stringFileName) {
        [SVProgressHUD show];
        NSData *postData = [Utils generatePostDataForData:fileData filename:stringFileName];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSString *url = @"http://onmyhome.vn/UploadAvaResize";
        
        NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [uploadRequest setHTTPMethod:@"POST"];
        [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
        [uploadRequest setHTTPBody:postData];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:uploadRequest
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            [SVProgressHUD dismiss];
                                                            NSLog(@"\n%@\n%@",url,error);
                                                            [Utils alertError:@"Lỗi kết nối" content:@"Đề nghị kiểm tra wifi hoặc kết nối dữ liệu của thiết bị" viewController:nil completion:^{
                                                                
                                                            }];
                                                        } else {
                                                            [SVProgressHUD dismiss];
                                                            NSString* urlImage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                            NSLog(@"\n%@\n%@",url,urlImage);
                                                            urlImage = [urlImage stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                            urlImage = [urlImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                                            completion(urlImage);
                                                        }
                                                    }];
        [dataTask resume];
    }else{
        completion(@"");
    }
}

+ (NSString *)hexadecimalStringFromData:(NSData *)data {
  NSUInteger dataLength = data.length;
  if (dataLength == 0) {
    return nil;
  }

  const unsigned char *dataBuffer = (const unsigned char *)data.bytes;
  NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
  for (int i = 0; i < dataLength; ++i) {
    [hexString appendFormat:@"%02x", dataBuffer[i]];
  }
  return [hexString copy];
}

+ (void)checkUpdate {
    NSString *mVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    [CallAPI callApiService:@"get_version" dictParam:@{} isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        if (dictData) {
            if ([dictData[@"ERROR"] isEqualToString:@"0000"]) {
                NSArray *arrayVersion = dictData[@"INFO"];
                NSDictionary *iosVersion;
                for (NSDictionary *dict in arrayVersion) {
                    if ([dict[@"NAME"] isEqualToString:@"IOS"]) {
                        iosVersion = dict;
                        break;
                    }
                }
                NSString *version = iosVersion[@"VERSION"];
                if ([mVersion isEqualToString:version]) {
                    NSLog(@"Phien ban OK");
                }else{
                    [self alertUpdateVersion:iosVersion];
                }
            }else{
                
            }
        }else{
            
        }
    }];
}

+ (void)alertUpdateVersion : (NSDictionary *)dictData {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Thông báo"
                                message:@"MyHome đã có phiên bản mới. Cập nhật để tiếp tục sử dụng"
                                preferredStyle:UIAlertControllerStyleAlert];
    if ([dictData[@"MUST_UPDATE"] intValue] == 1) {
        UIAlertAction *btnOK = [UIAlertAction
                                actionWithTitle:@"Cập nhật"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    NSString *ringtunesAppStoreURL = @"https://apps.apple.com/us/app/myhome/id1476078746?ls=1";
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ringtunesAppStoreURL]];
                                    [SVProgressHUD showWithStatus:@"Vui lòng cập nhật phiên bản mới"];
                                }];
        [alert addAction:btnOK];
    }else{
        UIAlertAction *btnOK = [UIAlertAction
                                actionWithTitle:@"Cập nhật"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    NSString *ringtunesAppStoreURL = @"https://apps.apple.com/us/app/myhome/id1476078746?ls=1";
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ringtunesAppStoreURL]];
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                }];
        [alert addAction:btnOK];
        
        UIAlertAction *btnCancel = [UIAlertAction
                                    actionWithTitle:@"Để sau"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
        [btnCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alert addAction:btnCancel];
    }
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
    
}

+ (NSDate *)getFirstDayOfThisMonth {
    NSDate *curDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:curDate];
    [comp setDay:1];
    NSDate *firstDateMonth = [calendar dateFromComponents:comp];
    
    return firstDateMonth;
}

+ (NSDate *)getLastDayOfMonth : (int)number {
    NSDate *curDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:curDate];
    // set last of month
    [comps setMonth:[comps month]+number];
    [comps setDay:0];
    NSDate *lastDateMonth = [calendar dateFromComponents:comps];
    
    return lastDateMonth;
}

+ (BOOL)isShowPromotion : (NSDictionary *)dictG {
    NSDictionary *dict = [self converDictRemoveNullValue:dictG];
    NSDate *endDate = [Utils getDateFromStringDate:dict[@"PROMO_ED_TIME"]];
    
    if ([endDate isKindOfClass:[NSNull class]] || endDate == nil) {
        return NO;
    }else{
        if ([[NSDate date] timeIntervalSinceDate:endDate] <= 0) {
            return YES;
        }else{
            return NO;
        }
    }
}

+ (BOOL)isTimePromotion : (NSDictionary *)dictG : (NSDate *)cDate{
    NSDictionary *dict = [self converDictRemoveNullValue:dictG];
    NSDate *startDate = [Utils getDateFromStringDate:dict[@"PROMO_ST_TIME"]];
    NSDate *endDate = [Utils getDateFromStringDate:dict[@"PROMO_ED_TIME"]];
    
    if ([startDate isKindOfClass:[NSNull class]] || [endDate isKindOfClass:[NSNull class]] || startDate == nil || endDate == nil) {
        return NO;
    }else{
        if ([startDate timeIntervalSinceDate:cDate] <= 0 && [cDate timeIntervalSinceDate:endDate] <= 0) {
            return YES;
        }else{
            return NO;
        }
    }
}

+ (NSString *)getBalance : (NSDictionary *)dictG {
    NSDictionary *dict = [self converDictRemoveNullValue:dictG];
    
    long long priceValue = 0;
    if ([self isShowPromotion:dict]) {
        priceValue = [dict[@"PRICE"] longLongValue] - [dict[@"DISCOUNT"] longLongValue];
    }else{
        priceValue = [dict[@"PRICE"] longLongValue];
    }
    long long valueBalance = priceValue*15/100;
    NSString *balance = [Utils strCurrency:[NSString stringWithFormat:@"%lld",valueBalance]];
    
    return balance;
}

+ (NSString *)getPrice : (NSDictionary *)dictG {
    NSDictionary *dict = [self converDictRemoveNullValue:dictG];
    long long priceValue = 0;
    
    if ([self isShowPromotion:dict]) {
        priceValue = [dict[@"PRICE"] longLongValue] - [dict[@"DISCOUNT"] longLongValue];
    }else{
        priceValue = [dict[@"PRICE"] longLongValue];
    }
    NSString *price = [Utils strCurrency:[NSString stringWithFormat:@"%lld",priceValue]];
    
    return price;
}

+ (NSString *)getPriceSpeacil : (NSDictionary *)dictG {
    NSDictionary *dict = [self converDictRemoveNullValue:dictG];
    long long priceValue = 0;
    
    if ([self isShowPromotion:dict]) {
        priceValue = [dict[@"PRICE_SPECIAL"] longLongValue] - [dict[@"DISCOUNT"] longLongValue];
    }else{
        priceValue = [dict[@"PRICE_SPECIAL"] longLongValue];
    }
    NSString *price = [Utils strCurrency:[NSString stringWithFormat:@"%lld",priceValue]];
    
    return price;
}

+ (long long)getPriceValue : (NSDictionary *)dictG {
    NSDictionary *dict = [self converDictRemoveNullValue:dictG];
    long long priceValue = 0;
    
    if ([self isShowPromotion:dict]) {
        priceValue = [dict[@"PRICE"] longLongValue] - [dict[@"DISCOUNT"] longLongValue];
    }else{
        priceValue = [dict[@"PRICE"] longLongValue];
    }
    
    return priceValue;
}

+ (long long)getPriceSpeacilValue : (NSDictionary *)dictG {
    NSDictionary *dict = [self converDictRemoveNullValue:dictG];
    long long priceValue = 0;
    
    if ([self isShowPromotion:dict]) {
        priceValue = [dict[@"PRICE_SPECIAL"] longLongValue] - [dict[@"DISCOUNT"] longLongValue];
    }else{
        priceValue = [dict[@"PRICE_SPECIAL"] longLongValue];
    }
    
    return priceValue;
}

+ (void)callSupport : (NSString *)phone {
    NSString *tel = [NSString stringWithFormat:@"tel://%@",phone];
    NSURL *URL = [NSURL URLWithString:tel];
    [[UIApplication sharedApplication] openURL:URL];
}

+ (int)placeInWeekForDate:(NSDate *)date {
    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    int start = 0;
    switch ([component weekday]) {
        case 1:
            //Sunday
            start = 6;
            break;
        case 2:
            //Monday
            start = 0;
            break;
            
        case 3:
            //Tuesday
            start = 1;
            break;
            
        case 4:
            //Wen
            start = 2;
            break;
            
        case 5:
            //Thur
            start = 3;
            break;
            
        case 6:
            //Thur
            start = 4;
            break;
            
        case 7:
            //Saturday
            start = 5;
            break;
            
        default:
            break;
    }
    return start;
}

@end




























