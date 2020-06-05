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
    manager.requestSerializer.timeoutInterval = 60.0;
    
    if (![service isEqualToString:@"user/login"] &&
        ![service isEqualToString:@"user/reg_user"] &&
        ![service isEqualToString:@"get_type"] &&
        ![service isEqualToString:@"get_city"] &&
        ![service isEqualToString:@"get_cover_idx"]) {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultToken];
        if (token) {
            token = [NSString stringWithFormat:@"bearer %@",token];
        }else{
            token = @"bearer abc";
        }
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    
    NSLog(@"\n%@\n%@",url,dictParam);
          
    [manager POST:url parameters:dictParam headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        NSDictionary *dictResult = [responseObject mutableObjectFromJSONData];
        NSLog(@"\n%@\n%@",url,dictResult);
        
        if ([dictResult[@"ERROR"]  isEqual:@"0000"]) {
            block(dictResult);
        }else if ([dictResult[@"ERROR"]  isEqual:@"0002"]) {
            NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName];
            NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultPassword];
            if (user && pass) {
                NSDictionary *param = @{@"USERNAME":user,
                                        @"PASSWORD":pass
                };
                [self login:param viewController : (UIViewController *)vc completeBlock:^(NSDictionary *dictData) {
                    [self callApiService:service dictParam:dictParam isGetError:isGetError viewController:vc completeBlock:^(NSDictionary *dictData) {
                        
                    }];
                }];
            }else{
                [Utils alertError:@"Thông báo" content:@"Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại." viewController:vc completion:^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    [[self appDelegate].window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
                    [[self appDelegate].window makeKeyAndVisible];
                }];
            }
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

+ (void)login : (NSDictionary *)param viewController : (UIViewController *)vc completeBlock:(void(^)(NSDictionary *dictData))block {
    [CallAPI callApiService:@"user/login" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        if ([dictData[@"ERROR"]  isEqual:@"0000"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[Utils converDictRemoveNullValue:dictData] forKey:kUserDefaultUserInfo];
            [[NSUserDefaults standardUserDefaults] setObject:param[@"USERNAME"] forKey:kUserDefaultUserName];
            [[NSUserDefaults standardUserDefaults] setObject:param[@"PASSWORD"] forKey:kUserDefaultPassword];
            [[NSUserDefaults standardUserDefaults] setObject:dictData[@"TOKEN"] forKey:kUserDefaultToken];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsLogin];
            block(dictData);
        }else{
            [Utils alertError:@"Thông báo" content:@"Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại." viewController:vc completion:^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                [[self appDelegate].window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
                [[self appDelegate].window makeKeyAndVisible];
            }];
        }
    }];
}

+ (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end























