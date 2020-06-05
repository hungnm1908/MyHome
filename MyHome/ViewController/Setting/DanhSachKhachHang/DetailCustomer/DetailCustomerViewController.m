//
//  DetailCustomerViewController.m
//  MyHome
//
//  Created by Macbook on 10/8/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "DetailCustomerViewController.h"
#import "CommonTableViewController.h"

@interface DetailCustomerViewController ()

@end

@implementation DetailCustomerViewController {
    NSDictionary *dictTP;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isCreate) {
        self.navigationItem.title = @"Thêm mới Khách Hàng";
        [self.btnUpdate setTitle:@"THÊM MỚI" forState:UIControlStateNormal];
    }else{
        [self fillInfo];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kProvince" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kVnBank" object:nil];
}

- (void)fillInfo {
    self.textFieldName.text = [NSString stringWithFormat:@"%@ ",self.self.dictCustomer[@"NAME"]];
    self.textFieldPhoneNumber.text = [NSString stringWithFormat:@"%@ ",self.dictCustomer[@"MOBILE"]];
    self.textFieldEmail.text = [NSString stringWithFormat:@"%@ ",self.dictCustomer[@"EMAIL"]];
    self.textFieldAddress.text = [NSString stringWithFormat:@"%@ ",self.dictCustomer[@"ADDRESS"]];
    self.textFieldCMT.text = [NSString stringWithFormat:@"%@ ",self.dictCustomer[@"CMT"]];
    self.textFieldTP.text = [NSString stringWithFormat:@"%@ ",self.dictCustomer[@"PROVINCE_NAME"]];
    self.textFieldDoB.text = [NSString stringWithFormat:@"%@ ",self.dictCustomer[@"DOB"]];
    
    dictTP = @{@"MATP":[NSString stringWithFormat:@"%@",self.dictCustomer[@"ID_PROVINCE"]],
               @"NAME":[NSString stringWithFormat:@"%@",self.dictCustomer[@"PROVINCE_NAME"]]
                };
}

- (IBAction)selectAvatar:(id)sender {
    
}

- (IBAction)selectTP:(id)sender {
    if ([VariableStatic sharedInstance].arrayProvince.count > 0) {
        [self selectProvince];
    }else{
        [CallAPI callApiService:@"get_city" dictParam:@{@"USERNAME":@""} isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
            [VariableStatic sharedInstance].arrayProvince = dictData[@"INFO"];
            
            [self selectProvince];
        }];
    };
}

- (IBAction)selectBankName:(id)sender {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ListVnBank" ofType:@"plist"];
    NSArray *listVnBank = [[NSArray arrayWithContentsOfFile:plistPath] copy];
    
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.typeView = kVnBank;
    vc.arrayItem = listVnBank;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)update:(id)sender {
    if ([self isEnoughInfo]) {
        if (self.isCreate) {
            [self callAPICreateCustomer];
        }else{
            [self callAPIUpdate];
        }
    }
}

- (BOOL)isEnoughInfo {
    BOOL isOK = YES;
    
    if ([Utils lenghtText:self.textFieldCMT.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng nhập số Chứng Minh Nhân Dân của khách hàng" viewController:nil completion:^{
            [self.textFieldCMT becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPhoneNumber.text] == 0){
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng nhập số Điện Thoại của khách hàng" viewController:nil completion:^{
            [self.textFieldPhoneNumber becomeFirstResponder];
        }];
    }
    
    return isOK;
}

- (void)selectProvince {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = [VariableStatic sharedInstance].arrayProvince;
    vc.typeView = kProvince;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark CallAPI

- (void)callAPIUpdate {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID":self.dictCustomer[@"ID"],
                            @"NAME":self.textFieldName.text,
                            @"MOBILE":self.textFieldPhoneNumber.text,
                            @"EMAIL":self.textFieldEmail.text,
                            @"DOB":self.textFieldDoB.text,
                            @"ADDRESS":self.textFieldTenNganHang.text,
                            @"ID_PROVINCE":[NSString stringWithFormat:@"%@",dictTP[@"MATP"]],
                            @"CMT":self.textFieldCMT.text
                            };
    
    [CallAPI callApiService:@"contact/edit_contact" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCustomerInfo object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)callAPICreateCustomer {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"NAME":self.textFieldName.text,
                            @"MOBILE":self.textFieldPhoneNumber.text,
                            @"EMAIL":self.textFieldEmail.text,
                            @"CMT":self.textFieldCMT.text,
                            @"DOB":self.textFieldDoB.text,
                            @"ADDRESS":self.textFieldTenNganHang.text,
                            @"ID_PROVINCE":[NSString stringWithFormat:@"%@",dictTP[@"MATP"]]
                            };
    
    [CallAPI callApiService:@"contact/add_contact" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCustomerInfo object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark Notification

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kProvince"]) {
        dictTP = notif.object;
        self.textFieldTP.text = dictTP[@"NAME"];
    }else if ([notif.name isEqualToString:@"kVnBank"]) {
        NSDictionary *dictBank = notif.object;
        self.textFieldTenNganHang.text = dictBank[@"name"];
    }
}

@end
