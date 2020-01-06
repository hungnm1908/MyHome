//
//  BaseViewController.h
//  NoiBaiAirPort
//
//  Created by HuCuBi on 5/27/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
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

@interface BaseViewController : UIViewController

@property UIRefreshControl *refreshControl;
@property UIButton *buttonLeft;

@end
