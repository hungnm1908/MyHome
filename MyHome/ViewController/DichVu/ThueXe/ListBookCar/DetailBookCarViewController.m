//
//  DetailBookCarViewController.m
//  MyHome
//
//  Created by HuCuBi on 4/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "DetailBookCarViewController.h"

@interface DetailBookCarViewController ()

@end

@implementation DetailBookCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fillInfo];
}

- (void)fillInfo {
    self.navigationItem.title = @"Chi tiết đơn hàng";
    
    self.labelCodeBooking.text = [NSString stringWithFormat:@"Mã đơn hàng: %@",self.dictBookCar[@"id"]];
    self.labelStatus.text = [self getStatus:self.dictBookCar];
    self.labelStatus.backgroundColor = [self getColorStatus:self.dictBookCar];
    self.labelInfo.text = [NSString stringWithFormat:@"%@ - %@",self.dictBookCar[@"route_name"],self.dictBookCar[@"car_name"]];
    self.labelDate.text = [self converDate:self.dictBookCar[@"appoint_date"]];
    self.labelTime.text = [self converTime:self.dictBookCar[@"appoint_date"]];
    self.labelNameCustomer.text = self.dictBookCar[@"customer_name"];
    self.labelPhoneCustomer.text = self.dictBookCar[@"customer_phone"];
    self.labelDetail.text = self.dictBookCar[@"note"];
    self.labelHanhTrinh.text = self.dictBookCar[@"location"];
}

- (NSString *) getStatus : (NSDictionary *)dict {
    int status = [dict[@"state"] intValue];
    NSString *str = @"";
    switch (status) {
        case -1:
            str = @"  Khách hàng hủy đơn   ";
            break;
            
        case 1:
            str = @"  Lái xe đã nhận chuyến   ";
            break;
            
        case 5:
            str = @"  Không tìm được lái xe phù hợp   ";
            break;
            
        case 6:
            str = @"  Hoàn thành   ";
            break;
            
        default:
            str = @"  Đang kết nối   ";
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
    [clientDateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *clientDate = [clientDateFormatter stringFromDate:serverDate];
    
    return clientDate;
}

- (NSString *)converTime : (NSString *)date {
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    [serverDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *serverDate = [serverDateFormatter dateFromString:date];
    
    NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
    [clientDateFormatter setDateFormat:@"HH:mm"];
    NSString *clientDate = [clientDateFormatter stringFromDate:serverDate];
    
    return clientDate;
}

- (IBAction)cancelBook:(id)sender {
    [Utils alertError:@"Thông báo" content:@"Chức năng đang xây dựng" viewController:nil completion:^{
        
    }];
}

#pragma mark CallAPI



@end
