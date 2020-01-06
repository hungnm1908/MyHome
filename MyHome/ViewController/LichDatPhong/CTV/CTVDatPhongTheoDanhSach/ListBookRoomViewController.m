//
//  ListBookRoomViewController.m
//  MyHome
//
//  Created by Macbook on 8/15/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListBookRoomViewController.h"
#import "ListBookRoomTableViewCell.h"
#import "BookingPaymentViewController.h"

@interface ListBookRoomViewController ()

@end

@implementation ListBookRoomViewController {
    NSDictionary *userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
}

- (NSString *)getDateFromDate : (NSString *)date {
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    [serverDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.000Z'"];
    NSDate *dateServer = [serverDateFormatter dateFromString:date];
    
    if (dateServer) {
        NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
        [clientDateFormatter setDateFormat:@"dd/MM/yyyy - HH:mm"];
        NSString *clientDate = [clientDateFormatter stringFromDate:dateServer];
        
        return clientDate;
    }else{
        return date;
    }
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListBookRoomTableViewCell";
    ListBookRoomTableViewCell *cell = (ListBookRoomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:self.arrayBookRoom[indexPath.row]];
    
    cell.labelNameRoom.text = [NSString stringWithFormat:@"%@ ",dict[@"ROOM_NAME"]];
    cell.labelNameGuest.text = [NSString stringWithFormat:@"%@ ",dict[@"BOOK_NAME"]];
    cell.labelDateBook.text = [NSString stringWithFormat:@"%@ - %@",dict[@"START_TIME"],dict[@"END_TIME"]];
    cell.labelTimeBook.text = [self getDateFromDate:dict[@"BOOKING_TIME"]];
    
    cell.labelStatusRoom.text = [NSString stringWithFormat:@"%@ ",dict[@"BOOK_STATUS_NAME"]];
    cell.labelStatusRoom.textColor = [self getColorStatusRoom:[dict[@"BOOK_STATUS"] intValue]];
    
    cell.labelStatusBilling.text = [NSString stringWithFormat:@"%@ ",dict[@"BILLING_STATUS_NAME"]];
    cell.labelStatusBilling.textColor = [self getColorStatusBilling:[dict[@"BILLING_STATUS"] intValue]];
    
    cell.iconLock.hidden = [Utils lenghtText:dict[@"CONTENT"]] != 0;
    
    if ([userInfo[@"USER_TYPE"] intValue] == 0) {//đăng nhập là admin
        cell.btnStatus.hidden = NO;
    }else{
        cell.btnStatus.hidden = [Utils lenghtText:dict[@"CONTENT"]] != 0;
    }
    [cell.btnStatus addTarget:self action:@selector(unlockRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([dict[@"IS_BOOK_SERVICES"] intValue] == 0) {
        cell.btnCleanRoom.enabled = YES;
        [cell.btnCleanRoom addTarget:self action:@selector(processService:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCleanRoom setTitle:@"  ĐẶT DỌN NHÀ  " forState:UIControlStateNormal];
        cell.btnCleanRoom.backgroundColor = RGB_COLOR(74, 187, 0);
    }else {
        if ([dict[@"STATUS_SERVICE"] intValue] == 0) {
            cell.btnCleanRoom.enabled = YES;
            [cell.btnCleanRoom addTarget:self action:@selector(processService:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnCleanRoom setTitle:@"  CHỜ THANH TOÁN  " forState:UIControlStateNormal];
            cell.btnCleanRoom.backgroundColor = RGB_COLOR(240, 10, 10);
        }else{
            cell.btnCleanRoom.enabled = NO;
            [cell.btnCleanRoom setTitle:@"  ĐÃ THANH TOÁN  " forState:UIControlStateNormal];
            cell.btnCleanRoom.backgroundColor = [UIColor grayColor];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayBookRoom.count;
}

- (void)processService: (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:self.arrayBookRoom[hitIndex.row]];
    
    if ([dict[@"IS_BOOK_SERVICES"] intValue] == 0) {
        [self cleanRoom:dict];
    }else {
        if ([dict[@"STATUS_SERVICE"] intValue] == 0) {
            [self payCleanRoom:dict];
        }else{
            
        }
    }
}

- (UIColor *)getColorStatusBilling : (int)trangThaiThanhToan {
    UIColor *color = [UIColor blackColor];
    switch (trangThaiThanhToan) {
        case 0:
        {
            color = RGB_COLOR(240, 10, 10);
        }
            break;
            
        case 1:
        {
            color = RGB_COLOR(250, 171, 28);
        }
            break;
            
        case 2:
        {
            color = RGB_COLOR(25, 200, 50);
        }
            break;
            
        default:
            break;
    }
    return color;
}

- (UIColor *)getColorStatusRoom : (int)trangThaiBook {
    UIColor *color = [UIColor blackColor];
    switch (trangThaiBook) {
        case 0:
        {
            color = RGB_COLOR(240, 10, 10);
        }
            break;
            
        case 1:
        {
            color = RGB_COLOR(250, 171, 28);
        }
            break;
            
        case 2:
        {
            color = RGB_COLOR(25, 200, 50);
        }
            break;
            
        default:
            break;
    }
    return color;
}

#pragma mark CallAPI

- (void)unlockRoom : (id)sender {
    if ([userInfo[@"USER_TYPE"] intValue] == 0) {//đăng nhập là admin
        
    }else{
        [Utils alert:@"Mở khóa nhà" content:@"Bạn chắc chắn muốn mở khóa nhà ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
            CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
            NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
            
            NSDictionary *dict = [Utils converDictRemoveNullValue:self.arrayBookRoom[hitIndex.row]];
            
            NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                    @"ID_BOOKROOM":[NSString stringWithFormat:@"%@",dict[@"ID"]],
                                    @"BOOKING_STATUS":@"3"
                                    };
            
            [CallAPI callApiService:@"book/change_booking" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
                [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBookingRoomStatus object:nil];
                }];
            }];
        }];
    }
}

- (void)cleanRoom : (NSDictionary *)dict {
    [Utils alert:@"Dọn nhà" content:@"Bạn chắc chắn muốn đặt dịch vụ dọn nhà ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                @"GENLINK":dict[@"GENLINK"],
                                @"CHECKIN":dict[@"START_TIME"],
                                @"CHECKOUT":dict[@"END_TIME"],
                                @"ID_BOOKROOM":dict[@"ID"],
                                };
        
        [CallAPI callApiService:@"book/booking_services2" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
            [Utils alertError:@"Thông báo" content:@"Đặt dịch vụ dọn nhà thành công. Vui lòng thanh toán bằng cách chuyển khoản theo các thông tin sau." viewController:nil completion:^{
                BookingPaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingPaymentViewController"];
                vc.isPaymentClean = YES;
                vc.totalPrice = [dictData[@"PRICE"] longLongValue];
                vc.content = dictData[@"CONTENT"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBookingRoomStatus object:nil];
            }];
        }];
    }];
}

- (void)payCleanRoom : (NSDictionary *)dict {
    [Utils alert:@"Thanh toán dịch vụ" content:@"Đặt dịch vụ dọn nhà thành công. Vui lòng thanh toán bằng cách chuyển khoản theo các thông tin sau." titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        BookingPaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingPaymentViewController"];
        vc.isPaymentClean = YES;
        vc.totalPrice = [dict[@"MONEY_SERVICES"] longLongValue];
        vc.content = dict[@"CONTENT_SERVICES"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
