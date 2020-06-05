//
//  BookCleanServiceViewController.m
//  MyHome
//
//  Created by HuCuBi on 5/16/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "BookCleanServiceViewController.h"
#import "BookingPaymentViewController.h"

@interface BookCleanServiceViewController ()

@end

@implementation BookCleanServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIDatePicker *dateOfBirthPicker = [[UIDatePicker alloc]init];
    [dateOfBirthPicker setDate:[NSDate date]];
    [dateOfBirthPicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [dateOfBirthPicker addTarget:self action:@selector(choseDateDoB) forControlEvents:UIControlEventValueChanged];
    [self.textFieldDateTime setInputView:dateOfBirthPicker];
}

- (void)choseDateDoB {
    UIDatePicker *picker = (UIDatePicker*)self.textFieldDateTime.inputView;
    self.textFieldDateTime.text = [self formatDate:picker.date];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (IBAction)selectDob:(id)sender {
    [self choseDateDoB];
}

- (IBAction)dismissView:(id)sender {
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

- (IBAction)bookCleanService:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dictParam];
    [dict setValue:[self makeNote] forKey:@"NOTES"];
    
    [self bookCleanRoom:dict];
}

- (NSString *)makeNote {
    NSString *note = [NSString stringWithFormat:@"SĐT Khách: %@\nTên khách: %@\nSố lượng khách: %@\nGiờ check-in: %@\n%@",self.textFieldPhone.text, self.textFieldName.text,self.textFieldQuantity.text,self.textFieldDateTime.text,self.textViewNote.text];
    
    return note;;
}

- (void)bookCleanRoom : (NSDictionary *)param {
    [CallAPI callApiService:@"book/booking_services2" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
        if ( [userInfo[@"USER_TYPE"] intValue] == 0 || [userInfo[@"USER_TYPE"] intValue] == 4) { //Là admin hoặc qldondep thì đặt trả sau luôn
            NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                    @"ID_BOOK_SERVICE":dictData[@"ID_BOOK_SERVICE"],
                                    @"KD_PAID":@"1"
            };
            [self selectKindOfPay:param];
        }else{
            [Utils alertWithCancelProcess:@"Thông báo" content:@"Đặt dịch vụ dọn nhà thành công. Vui lòng chọn hình thức thanh toán" titleOK:@"Trả trước" titleCancel:@"Trả sau" viewController:nil completion:^{
                BookingPaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingPaymentViewController"];
                vc.isPaymentClean = YES;
                vc.totalPrice = [dictData[@"PRICE"] longLongValue];
                vc.content = dictData[@"CONTENT"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                        @"ID_BOOK_SERVICE":dictData[@"ID_BOOK_SERVICE"],
                                        @"KD_PAID":@"0"
                };
                [self selectKindOfPay:param];
            } cancel:^{
                NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                        @"ID_BOOK_SERVICE":dictData[@"ID_BOOK_SERVICE"],
                                        @"KD_PAID":@"1"
                };
                [self selectKindOfPay:param];
            }];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBookingRoomStatus object:nil];
    }];
}

- (void)selectKindOfPay : (NSDictionary *)param {
    [CallAPI callApiService:@"book/kd_paid" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBookingRoomStatus object:nil];
        [self dismissView:nil];
    }];
}

@end
