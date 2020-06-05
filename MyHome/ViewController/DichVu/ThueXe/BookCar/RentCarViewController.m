//
//  RentCarViewController.m
//  MyHome
//
//  Created by HuCuBi on 3/22/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "RentCarViewController.h"
#import "CommonTableViewController.h"
#import "CKCalendarView.h"
#import "InformationViewController.h"

@interface RentCarViewController ()

@end

@implementation RentCarViewController {
    NSArray *arrayJourney;
    NSDictionary *dictJourney;
    
    NSArray *arrayCar;
    NSDictionary *dictCar;
    
    UIView *viewCalendar;
    CKCalendarView *calendarView;
    
    NSDictionary *dictInfoUser;
    NSDictionary *dictPrice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isPresentView) {
        self.viewNavigation.hidden = NO;
        self.heightViewNavigation.constant = 50;
    }else{
        self.viewNavigation.hidden = YES;
        self.heightViewNavigation.constant = 0;
    }
    
    [self getUserInfo];
    
    [self createCalendar];
    
    UIDatePicker *timePicker = [[UIDatePicker alloc]init];
    [timePicker setDate:[NSDate date]];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker addTarget:self action:@selector(choseTime) forControlEvents:UIControlEventValueChanged];
    [self.textFieldTime setInputView:timePicker];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:kUpdateUserInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kJourney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kRentCar" object:nil];
}

- (void)choseTime {
    UIDatePicker *picker = (UIDatePicker*)self.textFieldTime.inputView;
    self.textFieldTime.text = [self formatDate:picker.date];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectTime:(id)sender {
    [self choseTime];
}

- (IBAction)selectJourney:(id)sender {
    if (arrayJourney != nil) {
        CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
        vc.arrayItem = arrayJourney;
        vc.typeView = kJourney;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self getListJourney];
    }
}

- (IBAction)selectCar:(id)sender {
    if (arrayCar != nil) {
        CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
        vc.arrayItem = arrayCar;
        vc.typeView = kRentCar;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self getListCar];
    }
}

- (IBAction)selectDate:(id)sender {
    [self hideKeyboard];
    [self showCalendar];
}

- (IBAction)enterExtraPrice:(id)sender {
    self.textFieldExtraPrice.text = [Utils strCurrency:self.textFieldExtraPrice.text];
}

- (IBAction)rentCar:(id)sender {
    if ([self checkEnoughInfo]) {
        [self rentCar];
    }
}

- (BOOL)checkEnoughInfo {
    BOOL isOK = YES;
    
    if ([Utils lenghtText:dictInfoUser[@"SO_TK"]] == 0 || [Utils lenghtText:dictInfoUser[@"TEN_NH"]] == 0 || [Utils lenghtText:dictInfoUser[@"TEN_TK"]] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng cập nhật tài khoản ngân hàng của bạn để nhận được tiền thanh toán đặt xe" viewController:nil completion:^{
            InformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
            vc.isEdit = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else if ([Utils lenghtText:self.textFieldJourney.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng chọn hành trình" viewController:nil completion:^{
            [self selectJourney:nil];
        }];
    }else if ([Utils lenghtText:self.textFieldCar.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng chọn xe thuê" viewController:nil completion:^{
            [self selectCar:nil];
        }];
    }else if ([Utils lenghtText:self.textFieldName.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng nhập tên khách hàng" viewController:nil completion:^{
            [self.textFieldName becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPhoneNumber.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng nhập số điện thoại khách hàng" viewController:nil completion:^{
            [self.textFieldPhoneNumber becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPhoneNumber.text] < 10) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Số điện thoại khách hàng không đúng" viewController:nil completion:^{
            [self.textFieldPhoneNumber becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldAddDon.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng nhập địa chỉ đón khách" viewController:nil completion:^{
            [self.textFieldAddDon becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldDate.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng nhập ngày đón" viewController:nil completion:^{
            [self selectDate:nil];
        }];
    }else if ([Utils lenghtText:self.textFieldTime.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng nhập giờ đón" viewController:nil completion:^{
            [self.textFieldTime becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldAddDen.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Vui lòng nhập địa chỉ trả khách" viewController:nil completion:^{
            [self.textFieldAddDen becomeFirstResponder];
        }];
    }else if ([self checkTime]/60/60 > 24) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Thời gian đón không hợp lệ. Mời chọn lại" viewController:nil completion:^{
            
        }];
    }
    
    return isOK;
}

- (NSInteger)checkTime {
    NSString *time = [NSString stringWithFormat:@"%@ %@",self.textFieldDate.text, self.textFieldTime.text];
    
    NSDate *date = [self getDateFromStringDate:time];
    
    return [self _numberOfDaysFromDate:date toDate:[NSDate date]];
}

- (NSInteger)_numberOfDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    return [endDate timeIntervalSinceDate:startDate];
}

- (NSDate *)getDateFromStringDate : (NSString *)date {
    NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
    [clientDateFormatter setDateFormat:@"dd/MM/yyyy hh:mm"];
    
    NSDate *clientDate = [clientDateFormatter dateFromString:date];
    
    return clientDate;
}

- (void)hideKeyboard {
    [self.textFieldDate resignFirstResponder];
    [self.textFieldAddDon resignFirstResponder];
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldName resignFirstResponder];
    [self.textFieldCar resignFirstResponder];
    [self.textFieldJourney resignFirstResponder];
    [self.textFieldCost resignFirstResponder];
    [self.textFieldNote resignFirstResponder];
    [self.textFieldTime resignFirstResponder];
    [self.textFieldExtraPrice resignFirstResponder];
}

#pragma mark CKCalendar

- (void)createCalendar {
    viewCalendar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    viewCalendar.backgroundColor = [UIColor clearColor];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    btnClose.backgroundColor = [UIColor blackColor];
    btnClose.alpha = 0.6;
    [btnClose addTarget:self action:@selector(closeCalendar) forControlEvents:UIControlEventTouchUpInside];
    [viewCalendar addSubview:btnClose];
    
    calendarView = [[CKCalendarView alloc] init];
    calendarView.center = viewCalendar.center;
    [viewCalendar addSubview:calendarView];
    calendarView.delegate = self;
}

- (void)showCalendar {
    
    [[[self appDelegate] window] addSubview:viewCalendar];
}

- (void)closeCalendar {
    [viewCalendar removeFromSuperview];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    if ([self _numberOfDaysFromDate:date toDate:[NSDate date]]/60/60 > 24) {
        [Utils alertError:@"Thông báo" content:@"Ngày đón không hợp lệ. Mời chọn lại" viewController:nil completion:^{
            
        }];
    }else{
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *day = [dateFormatter stringFromDate:date];
        
        self.textFieldDate.text = day;
        
        [self closeCalendar];
        calendarView = nil;
    }
}

#pragma mark CallAPI

- (void)getListJourney {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
                            };
    
    [CallAPI callApiService:@"bookcar/get_route" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayJourney = dictData[@"INFO"];
        if (self->arrayJourney.count > 0) {
            [self selectJourney:nil];
        }else{
            [Utils alertError:@"Thông báo" content:@"Không có hành trình nào" viewController:nil completion:^{
                
            }];
        }
    }];
}

- (void)getListCar {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
                            };
    
    [CallAPI callApiService:@"bookcar/get_car" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayCar = dictData[@"INFO"];
        if (self->arrayCar.count > 0) {
            [self selectCar:nil];
        }else{
            [Utils alertError:@"Thông báo" content:@"Không có xe thuê" viewController:nil completion:^{
                
            }];
        }
    }];
}

- (void)getPriceRentCar {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ROUTE_TYPE":dictJourney[@"id"],
                            @"CAR_TYPE":dictCar[@"id"]
    };
    
    [CallAPI callApiService:@"bookcar/get_price_estimates" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->dictPrice = dictData[@"INFO"];
        self.textFieldCost.text = [[Utils strCurrency:self->dictPrice[@"price"]] stringByAppendingString:@"VNĐ"];
    }];
}

- (void)rentCar {
    long long radaPrice = [dictPrice[@"price"] longLongValue];
    long long extraPrice = [[[self.textFieldExtraPrice.text stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"VNĐ" withString:@""] longLongValue];
    long long totalPrice = radaPrice + extraPrice;
    
    NSString *paymentType = self.segmentTypePay.selectedSegmentIndex == 0 ? @"0" : @"2";
    NSString *time = [NSString stringWithFormat:@"%@ %@:00",self.textFieldDate.text,self.textFieldTime.text];
    
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"BOOKER_TEL":dictInfoUser[@"MOBILE"],
                            @"BOOKER_NAME":[Utils lenghtText:dictInfoUser[@"FULL_NAME"]] > 0 ? dictInfoUser[@"FULL_NAME"] : @"",
                            @"SO_TK":dictInfoUser[@"SO_TK"],
                            @"TEN_TK":dictInfoUser[@"TEN_TK"],
                            @"TEN_NH":dictInfoUser[@"TEN_NH"],
                            @"TEN_CN":[Utils lenghtText:dictInfoUser[@"TEN_CN"]] > 0 ? dictInfoUser[@"TEN_CN"] : @"",
                            @"CAR_TYPE":dictCar[@"id"],
                            @"ROUTE_TYPE":dictJourney[@"id"],
                            @"RADA_PRICE":[NSString stringWithFormat:@"%lld",radaPrice],
                            @"TOTAL_PRICE":[NSString stringWithFormat:@"%lld",totalPrice],
                            @"EXTRA_PRICE":[NSString stringWithFormat:@"%lld",extraPrice],
                            @"CUSTOMER_TEL":self.textFieldPhoneNumber.text,
                            @"CUSTOMER_NAME":self.textFieldName.text,
                            @"PAYMENT_TYPE":paymentType,
                            @"ADDRESS_SOURCE":self.textFieldAddDon.text,
                            @"ADDRESS_DES":@"",
                            @"SCHEDULE":time
                            
    };
    
    [CallAPI callApiService:@"bookcar/bookcar" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
            if (self.isPresentView) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}

- (void)getUserInfo {
    NSDictionary *dictParam = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                @"USERID":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
    };
    
    [CallAPI callApiService:@"user/get_info" dictParam:dictParam isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->dictInfoUser = dictData[@"INFO"][0];
    }];
}

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kJourney"]) {
        dictJourney = notif.object;
        self.textFieldJourney.text = dictJourney[@"name"];
    }else if ([notif.name isEqualToString:@"kRentCar"]) {
        dictCar = notif.object;
        self.textFieldCar.text = dictCar[@"name"];
    }
    
    if (dictCar.count > 0 && dictJourney.count > 0) {
        [self getPriceRentCar];
    }else{
        self.textFieldCost.text = @"";
    }
}

@end
