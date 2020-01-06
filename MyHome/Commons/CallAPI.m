//
//  CallAPI.m
//  NoiBaiAirPort
//
//  Created by HuCuBi on 6/1/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import "CallAPI.h"


@implementation CallAPI

+ (void)callApiService : (NSString *)service dictParam:(NSDictionary *)dictParam isGetError:(BOOL)isGetError viewController : (UIViewController *)vc completeBlock:(void(^)(NSDictionary *dictData))block {
    
    [SVProgressHUD show];
    
    NSString *url = [kService stringByAppendingString:service];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager.requestSerializer setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0;
    
    if (![service isEqualToString:@"user/login"] &&
        ![service isEqualToString:@"user/reg_user"] &&
        ![service isEqualToString:@"get_type"] &&
        ![service isEqualToString:@"get_city"] &&
        ![service isEqualToString:@"get_cover_idx"]) {
        NSString *token = [NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultToken]];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    
    NSLog(@"\n%@\n%@",url,dictParam);
    [manager POST:url parameters:dictParam progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dictResult = [responseObject mutableObjectFromJSONData];
        NSLog(@"\n%@\n%@",url,dictResult);
        
        if ([dictResult[@"ERROR"]  isEqual:@"0000"]) {
            block(dictResult);
        }else if ([dictResult[@"ERROR"]  isEqual:@"0002"]) {
            [Utils alertError:@"Thông báo" content:@"Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại." viewController:vc completion:^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                [[self appDelegate].window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
                [[self appDelegate].window makeKeyAndVisible];
            }];
        }else{
            if (isGetError) {
                block(dictResult);
            }else{
                [Utils alertError:@"Thông báo" content:dictResult[@"RESULT"] viewController:vc completion:^{
                    
                }];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        if (isGetError) {
            block(nil);
        }else{
            [Utils alertError:@"Lỗi kết nối" content:@"Đề nghị kiểm tra wifi hoặc kết nối dữ liệu của thiết bị" viewController:vc completion:^{
                
            }];
        }
    }];
}

+ (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (void)uploadFile:(NSData *)fileData fileName:(NSString *)stringFileName cType:(NSString *)stringCType completeBlock:(void(^)(NSDictionary *dictData))completion {
    [SVProgressHUD show];
    NSData *postData = [Utils generatePostDataForData:fileData filename:stringFileName];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *url = [kService stringByAppendingString:@"UploadAvaResize"];
    
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
    NSString *token = [NSString stringWithFormat:@"bearer %@",[[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultToken]];
    [uploadRequest setValue:token forHTTPHeaderField:@"Authorization"];
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
                                                        NSDictionary *dictResult = [data mutableObjectFromJSONData];
                                                        if ([dictResult[@"ERROR"] isEqualToString:@"0000"]) {
                                                            completion(dictResult);
                                                        }else{
                                                            [Utils alertError:@"Thông báo" content:dictResult[@"RESULT"] viewController:nil completion:^{
                                                                
                                                            }];
                                                        }
                                                        NSLog(@"\n%@\n%@",url,dictResult);
                                                    }
                                                }];
    [dataTask resume];
}


@end























