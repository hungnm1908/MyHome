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
        self.imageShowOldPass.image = [UIImage imageNamed:@"icon_unshow_pass"];
    }else{
        self.textFieldOldPassword.secureTextEntry = YES;
        self.imageShowOldPass.image = [UIImage imageNamed:@"icon_show_pass"];
    }
}

- (IBAction)showNewPass:(id)sender {
    if (self.textFieldNewPassword.secureTextEntry == YES) {
        self.textFieldNewPassword.secureTextEntry = NO;
        self.imageShowNewPass.image = [UIImage imageNamed:@"icon_unshow_pass"];
    }else{
        self.textFieldNewPassword.secureTextEntry = YES;
        self.imageShowNewPass.image = [UIImage imageNamed:@"icon_show_pass"];
    }
}

- (IBAction)showRePass:(id)sender {
    if (self.textFieldConfirmPassword.secureTextEntry == YES) {
        self.textFieldConfirmPassword.secureTextEntry = NO;
        self.imageShowRePass.image = [UIImage imageNamed:@"icon_unshow_pass"];
    }else{
        self.textFieldConfirmPassword.secureTextEntry = YES;
        self.imageShowRePass.image = [UIImage imageNamed:@"icon_show_pass"];
    }
}

- (IBAction)settupPassword:(id)sender {
    if ([Utils lenghtText:self.textFieldOldPassword.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập mật khẩu cũ" viewController:nil completion:^{
            [self.textFieldOldPassword becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldNewPassword.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập mật khẩu mới" viewController:nil completion:^{
            [self.textFieldNewPassword becomeFirstResponder];
        }];
    }else if ([self.textFieldNewPassword.text isEqualToString:self.textFieldOldPassword.text]) {
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
        [Utils alert:@"Đổi mật khẩu" content:@"Bạn chắc chắn muốn thay đổi mật khẩu" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
            [self changePassword];
        }];
    }
}

#pragma mark CallAPI

- (void)changePassword {
    NSDictionary *param= @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                           @"OLD_PASS":self.textFieldOldPassword.text,
                           @"NEW_PASS":self.textFieldNewPassword.text
    };
    
    [CallAPI callApiService:@"user/change_pass" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
