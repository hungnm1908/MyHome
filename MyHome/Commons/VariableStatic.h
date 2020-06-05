//
//  VariableStatic.h
//  mBCCS
//
//  Created by DVGT on 8/2/17.
//  Copyright © 2017 HuCuBi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface VariableStatic : NSObject

+ (VariableStatic *)sharedInstance;

- (void)cleanData;

@property NSArray *arrayProvince;
@property NSArray *arrayUserType;
@property BOOL isBooking;
@property BOOL warningTogether;
@property NSArray *arrayBanner;

@end
