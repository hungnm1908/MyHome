//
//  SignUpViewController.m
//  MyHome
//
//  Created by Macbook on 7/22/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "SignUpViewController.h"
#import "CommonTableViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController {
    NSDictionary *dictTypeUser;
    NSDictionary *dictTP;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    self.textFieldUserName.text = self.phoneNumber;
    self.textFieldUserName.enabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kProvince" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kUserType" object:nil];
}

- (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)login:(id)sender {
    [[self appDelegate].window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
    [[self appDelegate].window makeKeyAndVisible];
}

- (IBAction)selectTypeUser:(id)sender {
    [self getTypeUser];
}

- (IBAction)selectTinhTP:(id)sender {
    [self getProvince];
}

- (IBAction)signUp:(id)sender {
    if ([self isEnoughInfo]) {
        [self signUp];
    }
}

- (IBAction)changeAcc:(UITextField *)sender {
    NSString *acc = sender.text;
    acc = [acc stringByReplacingOccurrencesOfString:@" " withString:@""];
    acc = [acc lowercaseString];
    self.textFieldUserName.text = [Utils changeVietNamese:acc];
}

- (IBAction)showPass:(id)sender {
    if (self.textFieldPassword.secureTextEntry == YES) {
        self.textFieldPassword.secureTextEntry = NO;
        self.imageShowPass.image = [UIImage imageNamed:@"icon_unshow_pass"];
    }else{
        self.textFieldPassword.secureTextEntry = YES;
        self.imageShowPass.image = [UIImage imageNamed:@"icon_show_pass"];
    }
}

- (IBAction)showRePass:(id)sender {
    if (self.textFieldConfirmPassword.secureTextEntry == YES) {
        self.textFieldConfirmPassword.secureTextEntry = NO;
        self.imageShowPass.image = [UIImage imageNamed:@"icon_unshow_pass"];
    }else{
        self.textFieldConfirmPassword.secureTextEntry = YES;
        self.imageShowRepass.image = [UIImage imageNamed:@"icon_show_pass"];
    }
}

- (BOOL) isAllDigits : (NSString *)phone {
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [phone rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound && phone.length > 0;
}

- (BOOL)isEnoughInfo {
    BOOL isOk = NO;
    
    if ([Utils lenghtText:self.textFieldLoaiNguoiDung.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn loại người dùng" viewController:self completion:^{
            [self getTypeUser];
        }];
    }else if ([Utils lenghtText:self.textFieldUserName.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Số điện thoại" viewController:self completion:^{
            [self.textFieldUserName becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldUserName.text] < 10) {
        [Utils alertError:@"Thông báo" content:@"Số điện thoại không đúng định dạng" viewController:self completion:^{
            [self.textFieldUserName becomeFirstResponder];
        }];
    }else if ([self isAllDigits:self.textFieldUserName.text] == false) {
        [Utils alertError:@"Thông báo" content:@"Số điện thoại không đúng định dạng" viewController:self completion:^{
            [self.textFieldUserName becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPassword.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Mật khẩu" viewController:self completion:^{
            [self.textFieldPassword becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPassword.text] < 6) {
        [Utils alertError:@"Thông báo" content:@"Mật khẩu phải dài hơn 6 ký tự" viewController:self completion:^{
            [self.textFieldPassword becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldConfirmPassword.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Xác nhận mật khẩu" viewController:self completion:^{
            [self.textFieldConfirmPassword becomeFirstResponder];
        }];
    }else if (![self.textFieldConfirmPassword.text isEqualToString:self.textFieldPassword.text]) {
        [Utils alertError:@"Thông báo" content:@"Xác nhập mật khẩu không chính xác" viewController:self completion:^{
            [self.textFieldConfirmPassword becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldEmail.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Email" viewController:self completion:^{
            [self.textFieldEmail becomeFirstResponder];
        }];
    }else if (![Utils NSStringIsValidEmail:self.textFieldEmail.text]) {
        [Utils alertError:@"Thông báo" content:@"Email không chính xác" viewController:self completion:^{
            [self.textFieldEmail becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldTinhTP.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn Tỉnh/Thành phố" viewController:self completion:^{
            [self selectTinhTP:nil];
        }];
    }else if ([Utils lenghtText:self.textFieldAddress.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập địa chỉ" viewController:self completion:^{
            [self.textFieldAddress becomeFirstResponder];
        }];
    }else{
        isOk = YES;
    }
    
    return isOk;
}

- (void)selectUserType {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = [VariableStatic sharedInstance].arrayUserType;
    vc.typeView = kUserType;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)selectProvince {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = [VariableStatic sharedInstance].arrayProvince;
    vc.typeView = kProvince;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)myDismissKeyboard {
    [self.textFieldTinhTP resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldAddress resignFirstResponder];
    [self.textFieldFullName resignFirstResponder];
    [self.textFieldConfirmPassword resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
}

- (IBAction)cancelRegister:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [[self appDelegate].window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"tabbarController"]];
    [[self appDelegate].window makeKeyAndVisible];
}

#pragma mark TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldUserName) {
        [self.textFieldPassword becomeFirstResponder];
        return NO;
    }else if (textField == self.textFieldPassword) {
        [self.textFieldConfirmPassword becomeFirstResponder];
        return NO;
    }else if (textField == self.textFieldConfirmPassword) {
        [self.textFieldFullName becomeFirstResponder];
        return NO;
    }else if (textField == self.textFieldFullName) {
        [self.textFieldEmail becomeFirstResponder];
        return NO;
    }else if (textField == self.textFieldEmail) {
        [self selectTinhTP:nil];
        return NO;
    }else if (textField == self.textFieldAddress) {
        [self signUp:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length < 50 || string.length == 0){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark CallAPI

- (void)getTypeUser {
    [CallAPI callApiService:@"get_type" dictParam:@{@"USERNAME":@""} isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
        [VariableStatic sharedInstance].arrayUserType = dictData[@"INFO"];
        
        [self selectUserType];
    }];
}

- (void)getProvince {
    if ([VariableStatic sharedInstance].arrayProvince.count > 0) {
        [self selectProvince];
    }else{
        [CallAPI callApiService:@"get_city" dictParam:@{@"USERNAME":@""} isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
            [VariableStatic sharedInstance].arrayProvince = dictData[@"INFO"];
            
            [self selectProvince];
        }];
    }
}

- (void)signUp {
    NSDictionary *param = @{@"USERNAME":self.textFieldUserName.text,
                            @"PASSWORD":self.textFieldPassword.text,
                            @"EMAIL":self.textFieldEmail.text,
                            @"FULL_NAME":self.textFieldFullName.text,
                            @"USER_TYPE":dictTypeUser[@"USER_TYPE"],
                            @"MOBILE":self.textFieldUserName.text,
                            @"ADDRESS":self.textFieldAddress.text,
                            @"DES":@"",
                            @"ID_PROVINCE":dictTP[@"MATP"],
                            @"STK":@"",
                            @"TENTK":@"",
                            @"TENNH":@"",
                            @"TENCN":@""
                            };
    
    [CallAPI callApiService:@"user/reg_user" dictParam:param isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
        [[NSUserDefaults standardUserDefaults] setObject:dictData[@"CODE_ACTIVE"] forKey:kUserDefaultCodeActive];
        
        [Utils alertError:@"Thông báo" content:@"Chúc mừng bạn đã đăng ký tài khoản thành công" viewController:self completion:^{
            [self callApiLogin];
        }];
    }];
}

- (void)callApiLogin {
    NSDictionary *param = @{@"USERNAME":self.textFieldUserName.text,
                            @"PASSWORD":self.textFieldPassword.text
                            };
    
    [CallAPI callApiService:@"user/login" dictParam:param isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
        [[NSUserDefaults standardUserDefaults] setObject:[Utils converDictRemoveNullValue:dictData] forKey:kUserDefaultUserInfo];
        [[NSUserDefaults standardUserDefaults] setObject:param[@"USERNAME"] forKey:kUserDefaultUserName];
        [[NSUserDefaults standardUserDefaults] setObject:param[@"PASSWORD"] forKey:kUserDefaultPassword];
        [[NSUserDefaults standardUserDefaults] setObject:dictData[@"TOKEN"] forKey:kUserDefaultToken];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsLogin];
        
        [[[self appDelegate] window] setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tabbarController"]];
    }];
}

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kProvince"]) {
        dictTP = notif.object;
        self.textFieldTinhTP.text = dictTP[@"NAME"];
    }else if ([notif.name isEqualToString:@"kUserType"]) {
        dictTypeUser = notif.object;
        self.textFieldLoaiNguoiDung.text = dictTypeUser[@"TYPE_NAME"];
    }
}

@end
