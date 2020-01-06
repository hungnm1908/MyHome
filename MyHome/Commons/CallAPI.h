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

+ (void)callAPIService : (NSString *)service arrayParam:(NSArray *)arrayParam completeBlock:(void(^)(NSDictionary *dictData))block;

+ (void)signup : (NSString *)username  password : (NSString *)password giftCode : (NSString *)giftCode completeBlock:(void(^)(NSDictionary *dictData))block;

+ (void)login : (NSString *)username password : (NSString *)password completeBlock:(void(^)(NSDictionary *dictData))block;

@end






























