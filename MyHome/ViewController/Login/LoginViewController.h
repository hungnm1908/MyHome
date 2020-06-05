//
//  LoginViewController.h
//  MyHome
//
//  Created by HuCuBi on 8/4/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnShowPass;
@property (weak, nonatomic) IBOutlet UIView *viewFingerPrintLogin;


@end
