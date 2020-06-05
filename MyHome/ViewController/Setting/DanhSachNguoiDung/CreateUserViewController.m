//
//  CreateUserViewController.m
//  MyHome
//
//  Created by Macbook on 11/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "CreateUserViewController.h"
#import "CommonTableViewController.h"

@interface CreateUserViewController ()

@end

@implementation CreateUserViewController {
    NSDictionary *dictTypeUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kUserType" object:nil];
}

- (IBAction)selectTypeUser:(id)sender {
    [self getTypeUser];
}

- (IBAction)changeAcc:(UITextField *)sender {
    NSString *acc = sender.text;
    acc = [acc stringByReplacingOccurrencesOfString:@" " withString:@""];
    acc = [acc lowercaseString];
    self.textFieldUserName.text = [Utils changeVietNamese:acc];
}

- (IBAction)createNewUser:(id)sender {
    if ([self isEnoughInfo]) {
        [self createUser];
    }
}

- (BOOL)isEnoughInfo {
    BOOL isOk = NO;
    
    if ([Utils lenghtText:self.textFieldLoaiNguoiDung.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn loại người dùng" viewController:self completion:^{
            [self getTypeUser];
        }];
    }else if ([Utils lenghtText:self.textFieldUserName.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Tên đăng nhập" viewController:self completion:^{
            [self.textFieldUserName becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldMobile.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập số điện thoại" viewController:self completion:^{
            [self.textFieldMobile becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldEmail.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Email" viewController:self completion:^{
            [self.textFieldEmail becomeFirstResponder];
        }];
    }else if (![Utils NSStringIsValidEmail:self.textFieldEmail.text]) {
        [Utils alertError:@"Thông báo" content:@"Email không chính xác" viewController:self completion:^{
            [self.textFieldEmail becomeFirstResponder];
        }];
    }else{
        isOk = YES;
        [self myDismissKeyboard];
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

- (void)myDismissKeyboard {
    [self.textFieldMobile resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldAddress resignFirstResponder];
    [self.textFieldFullName resignFirstResponder];
    [self.textFieldLoaiNguoiDung resignFirstResponder];
    [self.textFieldUserName resignFirstResponder];
}

#pragma mark CallAPI

- (void)getTypeUser {
    if ([VariableStatic sharedInstance].arrayUserType.count > 0) {
        [self selectUserType];
    }else{
        [CallAPI callApiService:@"get_type" dictParam:@{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]} isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
            [VariableStatic sharedInstance].arrayUserType = dictData[@"INFO"];
            
            [self selectUserType];
        }];
    }
}

- (void)createUser {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"USERID":self.textFieldUserName.text,
                            @"MOBILE":self.textFieldMobile.text,
                            @"EMAIL":self.textFieldEmail.text,
                            @"FULL_NAME":self.textFieldFullName.text,
                            @"USER_TYPE":dictTypeUser[@"USER_TYPE"],
                            @"ADDRESS":self.textFieldAddress.text,
                            @"STATE":@"1"
                            };
    
    [CallAPI callApiService:@"user/adduser" dictParam:param isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
        
        [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:self completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kUserType"]) {
        dictTypeUser = notif.object;
        self.textFieldLoaiNguoiDung.text = dictTypeUser[@"TYPE_NAME"];
    }
}

@end
