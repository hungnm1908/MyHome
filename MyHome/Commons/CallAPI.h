//
//  CallAPI.h
//  NoiBaiAirPort
//
//  Created by HuCuBi on 6/1/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "AFHTTPSessionManager.h"
#import "JSONKit.h"

@interface CallAPI : NSObject

+ (void)callApiService : (NSString *)service dictParam:(NSDictionary *)dictParam isGetError:(BOOL)isGetError viewController : (UIViewController *)vc completeBlock:(void(^)(NSDictionary *dictData))block;

+ (void)login : (NSDictionary *)param viewController : (UIViewController *)vc completeBlock:(void(^)(NSDictionary *dictData))block;

@end






























