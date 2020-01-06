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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    int type = [userInfo[@"type"] intValue] ;
    
    switch (type) {
        case 1:
        {
            
        }
            break;
            
        default:
            break;
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
    
    NSLog(@"========= %f =========",[[NSDate date] timeIntervalSinceDate:dateFrom]);
    if([[NSDate date] timeIntervalSinceDate:dateFrom] > 0.5*24*60*60) {
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
        return [NSString stringWithFormat:@"%.0f n",(float)quantity/1000];
    }else{
        return [NSString stringWithFormat:@"%.0f tr",(float)quantity/1000000];
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

@end




























