//
//  RoomPriceListViewController.m
//  MyHome
//
//  Created by Macbook on 8/28/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "RoomPriceListViewController.h"

@interface RoomPriceListViewController ()

@end

@implementation RoomPriceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dictRoom = [Utils converDictRemoveNullValue:self.dictRoom];
    
    [self fillInfo];
}

- (void)fillInfo {
    self.textFieldGiaNgayThuong.text = [Utils strCurrency:self.dictRoom[@"PRICE"]];
    self.textFieldGiaDacBiet.text = [Utils strCurrency:self.dictRoom[@"PRICE_SPECIAL"]];
    self.textFieldPhiThemNguoi.text = [Utils strCurrency:self.dictRoom[@"PRICE_EXTRA"]];
    self.textFieldPhiDonDep.text = [Utils strCurrency:self.dictRoom[@"CLEAN_ROOM"]];
    
    self.textFieldSoKhachTieuChuan.text = [NSString stringWithFormat:@"%@",self.dictRoom[@"MAX_GUEST"]];
    self.textFieldSoKhachToiDa.text = [NSString stringWithFormat:@"%@",self.dictRoom[@"MAX_GUEST_EXIST"]];
    
    int isPolicy = [[NSString stringWithFormat:@"%@",self.dictRoom[@"POLICY_CANCLE"]] intValue];
    if (isPolicy == 0) {
        [self.swithAllowCancel setOn:NO];
    }else{
        [self.swithAllowCancel setOn:YES];
    }
    
    if ([self.dictRoom[@"DISCOUNT"] longLongValue] > 0) {
        self.viewDiscount.hidden = NO;
        self.textFieldDiscountValue.text = [Utils strCurrency:self.dictRoom[@"DISCOUNT"]];
        self.textFieldDiscountPercent.text = [NSString stringWithFormat:@"%@",self.dictRoom[@"PERCENT"]];
        self.textFieldStartDate.text = [Utils getDateFromDate:[Utils getDateFromStringDate:self.dictRoom[@"PROMO_ST_TIME"]]];
        self.textFieldEndDate.text = [Utils getDateFromDate:[Utils getDateFromStringDate:self.dictRoom[@"PROMO_ED_TIME"]]];
    }else{
        self.viewDiscount.hidden = YES;
        self.heightViewDiscount.constant = 0;
    }
}

- (IBAction)update:(id)sender {
    if ([self isEnoughInfo]) {
        [self updateHomeInfo];
    }
}

- (IBAction)enterPrice:(UITextField *)sender {
    sender.text = [Utils strCurrency:sender.text];
}


- (BOOL)isEnoughInfo {
    BOOL isOK = YES;
    
    if ([Utils lenghtText:self.textFieldGiaNgayThuong.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Giá ngày thường" viewController:nil completion:^{
            [self.textFieldGiaNgayThuong becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldGiaDacBiet.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Giá cuối tuần, lễ tết" viewController:nil completion:^{
            [self.textFieldGiaDacBiet becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPhiDonDep.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Phí dọn dẹp" viewController:nil completion:^{
            [self.textFieldPhiDonDep becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldSoKhachTieuChuan.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Số khách tiêu chuẩn" viewController:nil completion:^{
            [self.textFieldSoKhachTieuChuan becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldSoKhachToiDa.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Số khách tối đa" viewController:nil completion:^{
            [self.textFieldGiaNgayThuong becomeFirstResponder];
        }];
    }else if ([self.textFieldSoKhachTieuChuan.text intValue] > [self.textFieldSoKhachToiDa.text intValue]) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Số khách tiêu chuẩn không được vượt quá số khách tối đa" viewController:nil completion:^{
            [self.textFieldSoKhachTieuChuan becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPhiThemNguoi.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Phụ phí thêm khách" viewController:nil completion:^{
            [self.textFieldPhiThemNguoi becomeFirstResponder];
        }];
    }
    
    return isOK;
}

- (NSString *)convertPrice : (NSString *)strPrice {
    strPrice = [strPrice stringByReplacingOccurrencesOfString:@"." withString:@""];
    strPrice = [strPrice stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return strPrice;
}

#pragma mark CallAPI

- (void)updateHomeInfo {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"NAME":@"",
                            @"ADDRESS":@"",
                            @"PRICE":[self convertPrice:self.textFieldGiaNgayThuong.text],
                            @"PRICE_SPECIAL":[self convertPrice:self.textFieldGiaDacBiet.text],
                            @"PRICE_EXTRA":[self convertPrice:self.textFieldPhiThemNguoi.text],
                            @"MAX_GUEST":self.textFieldSoKhachTieuChuan.text,
                            @"MAX_ROOM":@"",
                            @"MAX_BED":@"",
                            @"CLEAN_ROOM":[self convertPrice:self.textFieldPhiDonDep.text],
                            @"DESCRIPTION":@"",
                            @"INFOMATION":@"",
                            @"POLICY_CANCLE":[NSString stringWithFormat:@"%@",self.swithAllowCancel.isOn?@"1":@"0"],
                            @"GENLINK":[NSString stringWithFormat:@"%@",self.dictRoom[@"GENLINK"]],
                            @"PROVINCE_ID":@"",
                            @"LOCATION_ID":@"",
                            @"COVER":@"",
                            @"MAX_GUEST_EXIST":self.textFieldSoKhachToiDa.text
                            };
    
    [CallAPI callApiService:@"room/edit_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertWithCancelProcess:@"Thông báo" content:@"Cập nhật thông tin giá thành công. Bạn muốn tiếp tục cập nhật thông tin tiện ích ?" titleOK:@"Đồng ý" titleCancel:@"Để sau" viewController:nil completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateRoomInforPrice object:param];
        } cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
