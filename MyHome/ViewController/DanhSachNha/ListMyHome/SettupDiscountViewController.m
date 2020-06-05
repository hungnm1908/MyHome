//
//  SettupDiscountViewController.m
//  MyHome
//
//  Created by Macbook on 2/19/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "SettupDiscountViewController.h"

@interface SettupDiscountViewController ()

@end

@implementation SettupDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)update:(id)sender {
    if ([self checkEnoughInfo]) {
        [Utils alert:@"Thông báo" content:@"Bạn chắc chắn muốn thiết lập giảm giá" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
            [self setDiscount];
        }];
    }
}

- (IBAction)selectStartDate:(id)sender {
    [self.textFieldStartDate becomeFirstResponder];
}

- (IBAction)selectEndDate:(id)sender {
    [self.textFieldEndDate becomeFirstResponder];
}

- (IBAction)selectPercent:(UISlider *)sender {
    self.textFieldPercent.text = [NSString stringWithFormat:@"%0.f",sender.value];
}

- (IBAction)enterPercent:(id)sender {
    float value = [self.textFieldPercent.text floatValue];
    
    if (value <= 10) {
        value = 10;
    }
    
    if (value >= 50) {
        value = 50;
    }
    
    self.sliderPercent.value = value;
    self.textFieldPercent.text = [NSString stringWithFormat:@"%0.f",value];
}

- (BOOL)checkEnoughInfo {
    BOOL isOk = YES;
    if ([Utils lenghtText:self.textFieldStartDate.text] == 0) {
        isOk = NO;
        [Utils alertError:@"Thông báo" content:@"Mời nhập ngày đến" viewController:nil completion:^{
            [self.textFieldStartDate becomeFirstResponder];
        }];
    }else if ([Utils getDurationFromDate:[Utils getDateFromDate:[NSDate date]] toDate:self.textFieldStartDate.text] > 0) {
        isOk = NO;
        [Utils alertError:@"Thông báo" content:@"Ngày bắt đầu phải sau ngày hiện tại" viewController:nil completion:^{
            [self.textFieldStartDate becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldEndDate.text] == 0) {
        isOk = NO;
        [Utils alertError:@"Thông báo" content:@"Mời nhập ngày rời đi" viewController:nil completion:^{
            [self.textFieldEndDate becomeFirstResponder];
        }];
    }else if ([Utils getDurationFromDate:self.textFieldStartDate.text toDate:self.textFieldEndDate.text] > 0) {
        isOk = NO;
        [Utils alertError:@"Thông báo" content:@"Ngày bắt đầu đến phải trước ngày kết thúc" viewController:nil completion:^{
            [self.textFieldEndDate becomeFirstResponder];
        }];
    }else{
        isOk = YES;
    }

    
    return isOk;
}

#pragma mark CallAPI

- (void)setDiscount {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : [NSString stringWithFormat:@"%@",self.dictHome[@"GENLINK"]],
                            @"PERCENT" : self.textFieldPercent.text,
                            @"START_TIME":self.textFieldStartDate.text,
                            @"END_TIME":self.textFieldEndDate.text
                            };
    
    [CallAPI callApiService:@"room/update_discount" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:@"Thiết lập giảm giá thành công" viewController:nil completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
