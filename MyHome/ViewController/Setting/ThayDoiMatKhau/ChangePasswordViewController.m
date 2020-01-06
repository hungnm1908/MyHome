//
//  ChangePasswordViewController.m
//  EVNCPCCSKH
//
//  Created by Macbook on 8/1/19.
//  Copyright © 2019 EVNCPC. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)showOldPass:(id)sender {
    if (self.textFieldOldPassword.secureTextEntry == YES) {
        self.textFieldOldPassword.secureTextEntry = NO;
        self.imageShowOldPass.image = [UIImage imageNamed:@"icon_show_unpass"];
    }else{
        self.textFieldOldPassword.secureTextEntry = YES;
        self.imageShowOldPass.image = [UIImage imageNamed:@"icon_show_pass"];
    }
}

- (IBAction)showNewPass:(id)sender {
    if (self.textFieldNewPassword.secureTextEntry == YES) {
        self.textFieldNewPassword.secureTextEntry = NO;
        self.imageShowNewPass.image = [UIImage imageNamed:@"icon_show_unpass"];
    }else{
        self.textFieldNewPassword.secureTextEntry = YES;
        self.imageShowNewPass.image = [UIImage imageNamed:@"icon_show_pass"];
    }
}

- (IBAction)showRePass:(id)sender {
    if (self.textFieldConfirmPassword.secureTextEntry == YES) {
        self.textFieldConfirmPassword.secureTextEntry = NO;
        self.imageShowRePass.image = [UIImage imageNamed:@"icon_show_unpass"];
    }else{
        self.textFieldConfirmPassword.secureTextEntry = YES;
        self.imageShowRePass.image = [UIImage imageNamed:@"icon_show_pass"];
    }
}

- (IBAction)settupPassword:(id)sender {
    NSString *oldPass = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultPassword];
    
    if ([Utils lenghtText:self.textFieldOldPassword.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập mật khẩu cũ" viewController:nil completion:^{
            [self.textFieldOldPassword becomeFirstResponder];
        }];
    }else if (![self.textFieldOldPassword.text isEqualToString:oldPass]) {
        [Utils alertError:@"Thông báo" content:@"Mật khẩu cũ không chính xác" viewController:nil completion:^{
            [self.textFieldOldPassword becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldNewPassword.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập mật khẩu mới" viewController:nil completion:^{
            [self.textFieldNewPassword becomeFirstResponder];
        }];
    }else if ([self.textFieldNewPassword.text isEqualToString:oldPass]) {
        [Utils alertError:@"Thông báo" content:@"Mật khẩu mới không được trùng mật khẩu cũ" viewController:nil completion:^{
            [self.textFieldNewPassword becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldConfirmPassword.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa xác thực mật khẩu mới" viewController:nil completion:^{
            [self.textFieldConfirmPassword becomeFirstResponder];
        }];
    }else if (![self.textFieldConfirmPassword.text isEqualToString:self.textFieldNewPassword.text]) {
        [Utils alertError:@"Thông báo" content:@"Xác thực mật khẩu mới không chính xác" viewController:nil completion:^{
            [self.textFieldConfirmPassword becomeFirstResponder];
        }];
    }else{
        [Utils alertError:@"Thông báo" content:@"Thay đổi mật khẩu thành công" viewController:nil completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kUserDefaultIsPassword];
            [[NSUserDefaults standardUserDefaults] setObject:self.textFieldNewPassword.text forKey:kUserDefaultPassword];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

@end
