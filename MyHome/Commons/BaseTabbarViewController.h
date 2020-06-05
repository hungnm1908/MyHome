//
//  BaseTabbarViewController.h
//  MyHome
//
//  Created by Macbook on 11/13/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "AppDelegate.h"
#import "JVFloatLabeledTextField.h"
#import "TextFiledChoseDate.h"
#import "VariableStatic.h"
#import "MyButton.h"
#import "MyImageView.h"
#import "MyCustomView.h"
#import "CallAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTabbarViewController : UIViewController<UIGestureRecognizerDelegate>

@property UIButton *buttonThongBao;

@end

NS_ASSUME_NONNULL_END
