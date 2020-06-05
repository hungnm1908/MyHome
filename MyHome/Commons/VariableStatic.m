//
//  VariableStatic.m
//  mBCCS
//
//  Created by DVGT on 8/2/17.
//  Copyright © 2017 HuCuBi. All rights reserved.
//

#import "VariableStatic.h"

@implementation VariableStatic

+ (VariableStatic *)sharedInstance {
    // comment to develop multi-server base
    static VariableStatic *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[VariableStatic alloc] init];
        
    });
    
    return sharedInstance;
}

- (void)cleanData {
    
}

@end
