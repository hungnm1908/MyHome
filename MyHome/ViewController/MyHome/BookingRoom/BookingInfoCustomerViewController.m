//
//  BookingInfoCustomerViewController.m
//  MyHome
//
//  Created by Macbook on 9/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "BookingInfoCustomerViewController.h"
#import "BookingPaymentViewController.h"

@interface BookingInfoCustomerViewController ()

@end

@implementation BookingInfoCustomerViewController {
    long long totalPrice;
    long long totalPriceRoom;
    long long priceCleanRoom;
    long long priceExtendGuest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dictRoom = [Utils converDictRemoveNullValue:self.dictRoom];
    
    [self fillInfo];
}

- (void)fillInfo {
    NSString *link = [self.dictRoom[@"COVER"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    link = [Utils convertStringUrl:link];
    link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
    NSURL *urlImage = [NSURL URLWithString:link];
    [self.imageRoomCover sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
    
    self.labelNameRoom.text = self.dictRoom[@"NAME"];
    self.labelAddressRoom.text = self.dictRoom[@"ADDRESS"];
    
    NSDate *startDate = self.dictBookingDate[@"StartDate"];
    NSDate *endDate = self.dictBookingDate[@"EndDate"];
    self.labelNumberDay.text = [NSString stringWithFormat:@"%d ngày\n%d đêm",(int)[Utils _numberOfDaysFromDate:startDate toDate:endDate]+1,(int)[Utils _numberOfDaysFromDate:startDate toDate:endDate]];
    self.labelNumberDay2.text = [NSString stringWithFormat:@"Giá nhà (%d đêm)",(int)[Utils _numberOfDaysFromDate:startDate toDate:endDate]];
    
    self.labelStartDate.text = [Utils getDateFromDate:startDate];
    self.labelStartWeekDay.text = [Utils getDayName:startDate];
    
    self.labelEndDate.text = [Utils getDateFromDate:endDate];
    self.labelEndWeekDay.text = [Utils getDayName:endDate];
    
    int soKhachToiDa = [self.dictRoom[@"MAX_GUEST_EXIST"] intValue];
    int soKhachTieuChuan = [self.dictRoom[@"MAX_GUEST"] intValue];
    if (soKhachToiDa < soKhachTieuChuan) {
        soKhachToiDa = soKhachTieuChuan;
    }
    self.stepperNumberGuest.maximumValue = soKhachToiDa;
    self.labelNotificationMoreGuest.text = [NSString stringWithFormat:@"Chỗ ở sẽ thu thêm phí từ khách thứ %d trở đi, tối đa là %d khách. Phí thu thêm khách là %@ VNĐ/người",soKhachTieuChuan,soKhachToiDa,[Utils strCurrency:self.dictRoom[@"PRICE_EXTRA"]]];
    
    [self getTotalPrice];
}

- (void)getTotalPrice {
    NSMutableArray *arrayDate = [NSMutableArray array];
    NSDate *startDate = self.dictBookingDate[@"StartDate"];
    NSDate *endDate = self.dictBookingDate[@"EndDate"];
    NSDate *nextDate = startDate;
    while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] > 0) {
        [arrayDate addObject:nextDate];
        nextDate = [Utils _nextDay:nextDate];
    }
    
    int specialNumberDay = 0;
    int normalDiscountNumberDay = 0;
    int specialDiscountNumberDay = 0;
//    int normalNumberDay = 0;
    
    for (NSDate *date in arrayDate) {
        NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
        if ([component weekday] == 6 || [component weekday] == 7) {
            if ([Utils isTimePromotion:self.dictRoom :date]) {
                specialDiscountNumberDay++;
            }else{
                specialNumberDay++;
            }
        }else{
            if ([Utils isTimePromotion:self.dictRoom :date]) {
                normalDiscountNumberDay++;
            }else{
//                normalNumberDay++;
            }
        }
    }
    int normalNumberDay = (int)[Utils _numberOfDaysFromDate:startDate toDate:endDate] - specialNumberDay - normalDiscountNumberDay - specialDiscountNumberDay;
    
    
    long long priceDiscountNomarl = normalDiscountNumberDay * [Utils getPriceValue:self.dictRoom];
    long long priceDiscountSpecial = specialDiscountNumberDay * [Utils getPriceSpeacilValue:self.dictRoom];
    long long priceRoomNomarl = normalNumberDay * ([self.dictRoom[@"PRICE"] longLongValue]);
    long long priceRoomSpecial = specialNumberDay * ([self.dictRoom[@"PRICE_SPECIAL"] longLongValue]);
    totalPriceRoom = priceRoomNomarl + priceRoomSpecial + priceDiscountNomarl + priceDiscountSpecial;
    
    self.labelPriceNomarDay.text = [NSString stringWithFormat:@"%@ vnđ x %d",[Utils strCurrency:self.dictRoom[@"PRICE"]],normalNumberDay];
    self.labelPriceSpeacialDay.text = [NSString stringWithFormat:@"%@ vnđ x %d",[Utils strCurrency:self.dictRoom[@"PRICE_SPECIAL"]],specialNumberDay];
    self.labelTotalPriceRoom.text = [NSString stringWithFormat:@"%@ VNĐ",[Utils strCurrency:[NSString stringWithFormat:@"%lld",totalPriceRoom]]];
    
    self.labelNormalDiscountPrice.text = [NSString stringWithFormat:@"%@ vnđ x %d",[Utils getPrice:self.dictRoom],normalDiscountNumberDay];
    self.labelSpeacilDiscountPrice.text = [NSString stringWithFormat:@"%@ vnđ x %d",[Utils getPriceSpeacil:self.dictRoom],specialDiscountNumberDay];
    
    if (normalDiscountNumberDay > 0) {
        self.viewNormalDiscount.hidden = NO;
    }else{
        self.viewNormalDiscount.hidden = YES;
        self.heightViewNormalDiscount.constant = 0;
    }
    
    if (specialDiscountNumberDay > 0) {
        self.viewSpeacilDiscount.hidden = NO;
    }else{
        self.viewSpeacilDiscount.hidden = YES;
        self.heightViewSpeacilDiscount.constant = 0;
    }
    
    int soKhachToiDa = [self.dictRoom[@"MAX_GUEST"] intValue];
    if (self.dictRoom[@"MAX_GUEST_EXIST"]) {
        soKhachToiDa = [self.dictRoom[@"MAX_GUEST_EXIST"] intValue];
    }
    int soKhachTieuChuan = [self.dictRoom[@"MAX_GUEST"] intValue];
    int soKhachDangKy = self.stepperNumberGuest.value;
    int soKhachTangThem = soKhachDangKy-soKhachTieuChuan;
    if (soKhachTangThem < 0) {
        soKhachTangThem = 0;
    }
    long long phuPhiThemNguoi = [self.dictRoom[@"PRICE_EXTRA"] longLongValue];
    priceExtendGuest = soKhachTangThem * phuPhiThemNguoi;
    self.labelPriceMoreGuest.text = [NSString stringWithFormat:@"%@ vnđ x %d",[Utils strCurrency:self.dictRoom[@"PRICE_EXTRA"]],soKhachTangThem];
    
    int numberDay = (int)[Utils _numberOfDaysFromDate:startDate toDate:endDate];
    if (numberDay < 4) {
        priceCleanRoom = [self.dictRoom[@"CLEAN_ROOM"] longLongValue];
        self.labelSubPrice.text = [NSString stringWithFormat:@"%@ vnđ",[Utils strCurrency:self.dictRoom[@"CLEAN_ROOM"]]];
    }else if (numberDay >= 4 && numberDay <= 6) {
        priceCleanRoom = [self.dictRoom[@"CLEAN_ROOM"] longLongValue]*2;
        self.labelSubPrice.text = [NSString stringWithFormat:@"%@ vnđ x 2",[Utils strCurrency:self.dictRoom[@"CLEAN_ROOM"]]];
    }else{
        priceCleanRoom = [self.dictRoom[@"CLEAN_ROOM"] longLongValue]*3;
        self.labelSubPrice.text = [NSString stringWithFormat:@"%@ vnđ x 3",[Utils strCurrency:self.dictRoom[@"CLEAN_ROOM"]]];
    }
    
    long long totalSubPrice = priceCleanRoom + priceExtendGuest;
    self.labelTotalSubPrice.text = [NSString stringWithFormat:@"%@ VNĐ",[Utils strCurrency:[NSString stringWithFormat:@"%lld",totalSubPrice]]];
    
    totalPrice = totalPriceRoom + totalSubPrice;
    self.labelTotalPrice.text = [NSString stringWithFormat:@"%@ VNĐ",[Utils strCurrency:[NSString stringWithFormat:@"%lld",totalPrice]]];
}

- (BOOL)checkEnoughInfo {
    BOOL isOK = YES;
    
    if ([Utils lenghtText:self.textFieldNameGuest.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập tên khách hàng" viewController:nil completion:^{
            [self.textFieldNameGuest becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPhoneNumberGuest.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập số điện thoại khách hàng" viewController:nil completion:^{
            [self.textFieldPhoneNumberGuest becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldPhoneNumberGuest.text] < 10) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Số điện thoại khách hàng chưa chính xác" viewController:nil completion:^{
            [self.textFieldPhoneNumberGuest becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldCMTGuest.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập số Chứng Minh Nhân Dân khách hàng" viewController:nil completion:^{
            [self.textFieldCMTGuest becomeFirstResponder];
        }];
    }
    
    return isOK;
}

- (IBAction)changeNumberGuest:(id)sender {
    self.labelNumberGuest.text = [NSString stringWithFormat:@"%d",(int)self.stepperNumberGuest.value];
    if ([self.dictRoom[@"MAX_GUEST_EXIST"] intValue] > 0 && [self.dictRoom[@"PRICE_EXTRA"] longLongValue] > 0) {
        [self getTotalPrice];
    }
}

- (IBAction)bookRoom:(id)sender {
    if ([self checkEnoughInfo]) {
        [Utils alert:@"Xác nhận" content:@"Bạn đồng ý đặt nhà ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
            [self book];
        }];
    }
}

#pragma mark CallAPI

- (void)book {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK":self.dictRoom[@"GENLINK"],
                            @"CHECKIN":self.labelStartDate.text,
                            @"CHECKOUT":self.labelEndDate.text,
                            @"BOOKING_PRICE":[NSString stringWithFormat:@"%lld",totalPrice],
                            @"CONTENT":@"",
                            @"NAME":self.textFieldNameGuest.text,
                            @"EMAIL":self.textFieldEmailGuest.text,
                            @"MOBILE":self.textFieldPhoneNumberGuest.text,
                            @"BIRTHDAY":self.textFieldDobGuest.text,
                            @"NUM_OF_GUEST":self.labelNumberGuest.text,
                            @"PRICE_TOTAL_NIGHT":[NSString stringWithFormat:@"%lld",totalPriceRoom],
                            @"CLEAN_FEE":[NSString stringWithFormat:@"%lld",priceCleanRoom],
                            @"ADD_GUEST_FEE":[NSString stringWithFormat:@"%lld",priceExtendGuest],
                            @"CMT":self.textFieldCMTGuest.text,
                            @"ADDRESS":self.textFieldAddressGuest.text
                            };
    
    [CallAPI callApiService:@"book/booking" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:@"Bạn đã đặt nhà thành công. Vui lòng thanh toán bằng cách chuyển khoản theo các thông tin sau." viewController:nil completion:^{
            BookingPaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingPaymentViewController"];
            vc.totalPrice = self->totalPrice;
            vc.content = dictData[@"CONTENT"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
}

@end
