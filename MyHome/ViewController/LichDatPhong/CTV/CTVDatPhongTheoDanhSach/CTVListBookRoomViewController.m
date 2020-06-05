//
//  CTVListBookRoomViewController.m
//  MyHome
//
//  Created by Macbook on 11/13/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "CTVListBookRoomViewController.h"
#import "CTVListBookRoomTableViewCell.h"
#import "BookingPaymentViewController.h"

@interface CTVListBookRoomViewController ()

@end

@implementation CTVListBookRoomViewController {
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
    static NSString *cellIdentifier = @"CTVListBookRoomTableViewCell";
    CTVListBookRoomTableViewCell *cell = (CTVListBookRoomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    cell.labelContent.text = dict[@"CONTENT"];
    if ([dict[@"BILLING_STATUS"] intValue] == 0) {
        cell.viewThanhToan.hidden = NO;
        cell.heightViewThanhToan.constant = 64;
    }else{
        cell.viewThanhToan.hidden = YES;
        cell.heightViewThanhToan.constant = 0;
    }
    [cell.btnThanhToan addTarget:self action:@selector(payBookingRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayBookRoom.count;
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

- (void)payBookingRoom : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:self.arrayBookRoom[hitIndex.row]];
    [Utils alert:@"Thanh toán tiền thuê nhà" content:@"Vui lòng thanh toán bằng cách chuyển khoản theo các thông tin sau." titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        BookingPaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingPaymentViewController"];
        vc.isPaymentClean = NO;
        vc.totalPrice = [dict[@"BOOKING_PRICE"] longLongValue];
        vc.content = dict[@"CONTENT"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
