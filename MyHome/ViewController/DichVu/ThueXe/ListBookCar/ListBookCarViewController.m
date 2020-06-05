//
//  ListBookCarViewController.m
//  MyHome
//
//  Created by HuCuBi on 4/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "ListBookCarViewController.h"
#import "ListBookCarTableViewCell.h"
#import "DetailBookCarViewController.h"

@interface ListBookCarViewController ()

@end

@implementation ListBookCarViewController {
    NSArray *arrayBookCar;
    NSDictionary *dictUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getUserInfo];
    
    [self.tableView addSubview:self.refreshControl];
}

- (void)handleRefresh : (id)sender {
    arrayBookCar = [NSArray array];
    [self.tableView reloadData];
    [self getUserInfo];
    [self.refreshControl endRefreshing];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListBookCarTableViewCell";
    ListBookCarTableViewCell *cell = (ListBookCarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookCar[indexPath.row]];
    
    cell.labelCodeBooking.text = [NSString stringWithFormat:@"Mã đơn hàng: %@",dict[@"id"]];
    cell.labelStatus.text = [self getStatus:dict];
    cell.labelStatus.backgroundColor = [self getColorStatus:dict];
    cell.labelNameBooker.text = dictUser[@"FULL_NAME"];
    cell.labelHanhTrinh.text = dict[@"route_name"];
    cell.labelTypeCar.text = dict[@"car_name"];
    cell.labelTime.text = [self converDate:dict[@"appoint_date"]];
    cell.labelPrice.text = [Utils strCurrency:dict[@"cost"]];
    cell.labelNameCustomer.text = dict[@"customer_name"];
    cell.labelPhoneCustomer.text = dict[@"customer_phone"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayBookCar.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookCar[indexPath.row]];
    
    DetailBookCarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailBookCarViewController"];
    vc.dictBookCar = dict;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *) getStatus : (NSDictionary *)dict {
    int status = [dict[@"state"] intValue];
    NSString *str = @"";
    switch (status) {
        case -1:
            str = @"  Khách hàng hủy đơn  ";
            break;
            
        case 1:
            str = @"  Lái xe đã nhận chuyến  ";
            break;
            
        case 5:
            str = @"  Không tìm được lái xe phù hợp  ";
            break;
            
        case 6:
            str = @"  Hoàn thành  ";
            break;
            
        default:
            str = @"  Đang kết nối  ";
            break;
    }
    
    return str;
}

- (UIColor *) getColorStatus : (NSDictionary *)dict {
    int status = [dict[@"state"] intValue];
    UIColor *str ;
    switch (status) {
        case -1:
            str = RGB_COLOR(255, 38, 0);
            break;
            
        case 1:
            str = RGB_COLOR(75, 109, 179);
            break;
            
        case 5:
            str = RGB_COLOR(255, 38, 0);
            break;
            
        case 6:
            str = RGB_COLOR(0, 150, 255);
            break;
            
        default:
            str = UIColor.orangeColor;
            break;
    }
    
    return str;
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

- (void)getListBookCar : (NSString *)phoneNumber {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"BOOKER_TEL":phoneNumber
                            };
    
    [CallAPI callApiService:@"bookcar/get_list_bookcar" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayBookCar = dictData[@"INFO"];
        if (self->arrayBookCar.count > 0) {
            self.labelNotice.hidden = YES;
        }else{
            self.labelNotice.hidden = NO;
        }
        [self.tableView reloadData];
    }];
}

- (void)getUserInfo {
    NSDictionary *dictParam = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                @"USERID":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
    };
    
    [CallAPI callApiService:@"user/get_info" dictParam:dictParam isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->dictUser = dictData[@"INFO"][0];
        NSString *phoneNumber = self->dictUser[@"MOBILE"];
        if (phoneNumber.length > 0) {
            [self getListBookCar:phoneNumber];
        }else{
            self.labelNotice.hidden = NO;
        }
    }];
}

@end
