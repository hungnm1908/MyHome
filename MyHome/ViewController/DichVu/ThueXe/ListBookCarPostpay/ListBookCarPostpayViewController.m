//
//  ListBookCarPostpayViewController.m
//  MyHome
//
//  Created by HuCuBi on 5/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "ListBookCarPostpayViewController.h"
#import "ListBookCarPostpayTableViewCell.h"
#import "DetailBookCarViewController.h"
#import "BookingPaymentViewController.h"

@interface ListBookCarPostpayViewController ()

@end

@implementation ListBookCarPostpayViewController {
    NSArray *arrayBookCar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getListBookCar];
    
    [self.tableView addSubview:self.refreshControl];
}

- (void)handleRefresh : (id)sender {
    arrayBookCar = [NSArray array];
    [self.tableView reloadData];
    [self getListBookCar];
    [self.refreshControl endRefreshing];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListBookCarPostpayTableViewCell";
    ListBookCarPostpayTableViewCell *cell = (ListBookCarPostpayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookCar[indexPath.row]];
    
    cell.labelCodeBooking.text = [NSString stringWithFormat:@"Mã đơn hàng: %@",dict[@"BILL_CODE"]];
    cell.labelStatus.text = [NSString stringWithFormat:@"  %@  ",dict[@"BILL_NAME"]];
    cell.labelStatus.backgroundColor = [self getColorStatus:dict];
    cell.labelNameBooker.text = dict[@"BOOKER_NAME"];
    cell.labelHanhTrinh.text = [NSString stringWithFormat: @"%@\n%@ - %@",dict[@"TEN_TK"],dict[@"TEN_NH"],dict[@"SO_TK"]];
    cell.labelTypeCar.text = [NSString stringWithFormat: @"%@ ",dict[@"MESSAGE_INFO"]];
    cell.labelTime.text = [Utils strCurrency:dict[@"EXTRA_PRICE"]];
    cell.labelPrice.text = [Utils strCurrency:dict[@"TOTAL_PRICE"]];
    cell.labelNameCustomer.text = dict[@"CUSTOMER_NAME"];
    cell.labelPhoneCustomer.text = dict[@"CUSTOMER_TEL"];
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    
    if (userType == 0) {
        int status = [dict[@"BILL_STATUS"] intValue];
        if (status == 1) {
            cell.btnAccept.hidden = YES;
            cell.heightBtnAccept.constant = 0;
        }else{
            cell.btnAccept.hidden = NO;
            cell.heightBtnAccept.constant = 30;
        }
        [cell.btnAccept setTitle:@"Duyệt đơn" forState:UIControlStateNormal];
        [cell.btnAccept addTarget:self action:@selector(acceptOrder:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.btnAccept setTitle:@"Thanh toán" forState:UIControlStateNormal];
        [cell.btnAccept addTarget:self action:@selector(payment:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayBookCar.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookCar[indexPath.row]];
//
//    DetailBookCarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailBookCarViewController"];
//    vc.dictBookCar = dict;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)acceptOrder: (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookCar[hitIndex.row]];
    
    [Utils alert:@"Thông báo" content:@"Bạn chắc chắn xác nhận đơn này đã thanh toán" titleOK:@"Xác nhận" titleCancel:@"Hủy bỏ" viewController:self completion:^{
        [self updateBilling:dict];
    }];
}

- (UIColor *) getColorStatus : (NSDictionary *)dict {
    int status = [dict[@"BILL_STATUS"] intValue];
    if (status == 1) {
        return RGB_COLOR(75, 109, 179);
    }else{
        return RGB_COLOR(255, 38, 0);
    }
}

- (NSString *)converDate : (NSString *)date {
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    [serverDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *serverDate = [serverDateFormatter dateFromString:date];
    
    NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
    [clientDateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *clientDate = [clientDateFormatter stringFromDate:serverDate];
    
    return clientDate;
}

#pragma mark CallAPI

- (void)getListBookCar {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
                            };
    
    [CallAPI callApiService:@"bookcar/get_list_bookcar_pre" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayBookCar = dictData[@"INFO"];
        if (self->arrayBookCar.count > 0) {
            self.labelNotice.hidden = YES;
        }else{
            self.labelNotice.hidden = NO;
        }
        [self.tableView reloadData];
    }];
}

- (void)updateBilling : (NSDictionary *)dict {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID":dict[@"ID"]};
    
    [CallAPI callApiService:@"bookcar/update_billing" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [self getListBookCar];
    }];
}

- (void)payment : (NSDictionary *)dict {
    [Utils alertError:@"Thông báo" content:@"Bạn đã đặt xe thành công. Vui lòng thanh toán bằng cách chuyển khoản theo các thông tin sau." viewController:nil completion:^{
        BookingPaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingPaymentViewController"];
        vc.totalPrice = [dict[@"TOTAL_PRICE"] longLongValue];
        vc.content = dict[@"BILL_CODE"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
