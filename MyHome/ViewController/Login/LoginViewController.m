//
//  LoginViewController.m
//  MyHome
//
//  Created by HuCuBi on 8/4/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName];
//    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    self.textFieldUsername.text = username ? username : @"";
//    self.textFieldPassword.text = password ? password : @"";
    
    self.viewFingerPrintLogin.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
//    [self loginWithFingerPrint];
    [self.navigationController.navigationBar setHidden:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)signUp:(id)sender {
    [[self appDelegate].window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"]];
    [[self appDelegate].window makeKeyAndVisible];
}

- (IBAction)login:(id)sender {
    if ([Utils lenghtText:self.textFieldUsername.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa điền Tên Đăng Nhập" viewController:self completion:^{
            [self.textFieldUsername becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPassword.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa điền Mật Khẩu" viewController:self completion:^{
            [self.textFieldPassword becomeFirstResponder];
        }];
    }else{
        [self callApiLogin : self.textFieldUsername.text : self.textFieldPassword.text];
    }
}

- (IBAction)showPass:(id)sender {
    if (self.textFieldPassword.secureTextEntry == YES) {
        self.textFieldPassword.secureTextEntry = NO;
        [self.btnShowPass setImage:[UIImage imageNamed:@"icon_show_pass"] forState:UIControlStateNormal];
    }else{
        self.textFieldPassword.secureTextEntry = YES;
        [self.btnShowPass setImage:[UIImage imageNamed:@"icon_unshow_pass"] forState:UIControlStateNormal];
    }
}

- (IBAction)cancelLogin:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [[self appDelegate].window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"tabbarController"]];
    [[self appDelegate].window makeKeyAndVisible];
}

- (IBAction)cancelLoginByFingerPrint:(id)sender {
    self.viewFingerPrintLogin.hidden = YES;
}

- (void)loginWithFingerPrint {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultPassword];
    if (username && password) {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *myLocalizedReasonString = [NSString stringWithFormat:@"Tài khoản: %@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]];
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
           [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                         localizedReason:myLocalizedReasonString
                                   reply:^(BOOL success, NSError *error) {
                                       if (success) {
                                           [self callApiLogin:username :password];
                                       } else {
                                           switch (error.code) {
                                               case LAErrorAuthenticationFailed:
                                                   NSLog(@"Authentication Failed");
                                                   break;
                                                    
                                               case LAErrorUserCancel:
                                                   NSLog(@"User pressed Cancel button");
                                                   break;
                                                    
                                               case LAErrorUserFallback:
                                                   NSLog(@"User pressed \"Enter Password\"");
                                                   break;
                                                    
                                               default:
                                                   NSLog(@"Touch ID is not configured");
                                                   break;
                                           }
                                           NSLog(@"Authentication Fails");
                                       }
                                   }];
        } else {
           NSLog(@"Can not evaluate Touch ID");
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldUsername) {
        [self.textFieldPassword becomeFirstResponder];
        return NO;
    }else if (textField == self.textFieldPassword) {
        [textField resignFirstResponder];
        [self login:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark CallAPI

- (void)callApiLogin : (NSString *)userName : (NSString *)password {
    NSDictionary *param = @{@"USERNAME":userName,
                            @"PASSWORD":password
                            };
    
    [CallAPI callApiService:@"user/login" dictParam:param isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
        [[NSUserDefaults standardUserDefaults] setObject:[Utils converDictRemoveNullValue:dictData] forKey:kUserDefaultUserInfo];
        [[NSUserDefaults standardUserDefaults] setObject:param[@"USERNAME"] forKey:kUserDefaultUserName];
        [[NSUserDefaults standardUserDefaults] setObject:param[@"PASSWORD"] forKey:kUserDefaultPassword];
        [[NSUserDefaults standardUserDefaults] setObject:dictData[@"TOKEN"] forKey:kUserDefaultToken];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsLogin];
        
        [[[self appDelegate] window] setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tabbarController"]];
        
        [Utils updateAppInfo];
    }];
}

@end
