//
//  ConfirmOTPViewController.h
//  HappyLuckySale
//
//  Created by Macbook on 5/17/19.
//  Copyright © 2019 HuCuBi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AccountKit/AKFAccountKit.h>
#import <AccountKit/AKFPhoneNumber.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOTPViewController : UIViewController<AKFViewControllerDelegate>

@property NSDictionary *dictRegister;
@property NSDictionary *dictLogin;

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatarShop;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOTP;

@end

NS_ASSUME_NONNULL_END
