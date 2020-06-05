//
//  SignUpViewController.h
//  MyHome
//
//  Created by Macbook on 7/22/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : BaseViewController<UITextFieldDelegate>

@property NSString *phoneNumber;

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldLoaiNguoiDung;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldFullName;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldTinhTP;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldConfirmPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imageShowPass;
@property (weak, nonatomic) IBOutlet UIImageView *imageShowRepass;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;


@end

NS_ASSUME_NONNULL_END
