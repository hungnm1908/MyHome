//
//  ChangePasswordViewController.h
//  EVNCPCCSKH
//
//  Created by Macbook on 8/1/19.
//  Copyright © 2019 EVNCPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordViewController : BaseViewController

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldOldPassword;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldNewPassword;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldConfirmPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imageShowOldPass;
@property (weak, nonatomic) IBOutlet UIImageView *imageShowNewPass;
@property (weak, nonatomic) IBOutlet UIImageView *imageShowRePass;

@end

NS_ASSUME_NONNULL_END
