//
//  NewReportViewController.m
//  MyHome
//
//  Created by HuCuBi on 3/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "NewReportViewController.h"
#import "NewReportTableViewCell.h"
#import "CommonTableViewController.h"

@interface NewReportViewController ()

@end

@implementation NewReportViewController {
    NSArray *arrayRoom;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getListMyRoom];
    
    [self getDoanhThuThang];
    
    [self getChiPhiThang];
    
    [self getReportAll];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kMyHome" object:nil];
}

- (IBAction)selectHome:(id)sender {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = arrayRoom;
    vc.typeView = kMyHome;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark CallAPI

- (void)getNumberBookDay : (NSString *)genlink {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK":genlink
    };
    
    [CallAPI callApiService:@"report/rp_book_month" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayBook = dictData[@"INFO"];
        NSDictionary *dictLastMonth = arrayBook[0];
        NSDictionary *dictThisMonth = arrayBook[1];
        
        self.labelMonth.text = [NSString stringWithFormat:@"Số ngày đặt phòng trong tháng %@",dictThisMonth[@"MONTH"]];
        self.labelReport.text = [NSString stringWithFormat:@"%@/%@ ngày",dictThisMonth[@"TOTALDAY"],dictThisMonth[@"NUMBER_OF_DAYS"]];
        
        int day = [dictThisMonth[@"TOTALDAY"] intValue] - [dictLastMonth[@"TOTALDAY"] intValue];
        if (day == 0) {
            self.imageReport.image = [UIImage imageNamed:@"icon_equal"];
            self.labelMonthReport.text = @"";
        }else if (day < 0) {
            self.imageReport.image = [UIImage imageNamed:@"arrow_down"];
            self.labelMonthReport.text = [NSString stringWithFormat:@"%d ngày so với tháng trước",day*(-1)];
            self.labelMonthReport.textColor = [UIColor redColor];
        }else{
            self.imageReport.image = [UIImage imageNamed:@"arrow_up"];
            self.labelMonthReport.text = [NSString stringWithFormat:@"%d ngày so với tháng trước",day];
            self.labelMonthReport.textColor = RGB_COLOR(0, 146, 32);
        }
    }];
}

- (void)getListMyRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"OPT":@""
                            };
    
    [CallAPI callApiService:@"room/get_mylist_room" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayRoom = dictData[@"INFO"];
        if (self->arrayRoom.count > 0) {
            NSDictionary *firstRoom = self->arrayRoom[0];
            self.labelHome.text = firstRoom[@"NAME"];
            [self getNumberBookDay:firstRoom[@"GENLINK"]];
        }else{
            self.viewReportDayHome.hidden = YES;
            self.heightViewReportDayHome.constant = 0;
        }
    }];
}

- (void)getDoanhThuThang {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
                            };
    
    [CallAPI callApiService:@"report/rp_revenue" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        
        NSArray *arrayRevenue = dictData[@"INFO"];
        NSDictionary *dictLastMonth = arrayRevenue[0];
        NSDictionary *dictThisMonth = arrayRevenue[1];
        
        long long compare = [dictThisMonth[@"REVENUE"] longLongValue] - [dictLastMonth[@"REVENUE"] longLongValue];
        NSString *compareValue = @"";
        NSString *imageName = @"";
        UIColor *color;
        if (compare == 0) {
            compareValue = @"";
            imageName = @"icon_equal";
            color = RGB_COLOR(255, 165, 0);
        }else if (compare < 0) {
            compareValue = [NSString stringWithFormat:@"%lld",compare*(-1)];
            imageName = @"arrow_down";
            color = [UIColor redColor];
        }else{
            compareValue = [NSString stringWithFormat:@"%lld",compare];
            imageName = @"arrow_up";
            color = RGB_COLOR(0, 146, 32);
        }
        
        self.labelDoanhThuThang.text = [NSString stringWithFormat:@"%@ vnđ",[Utils strCurrency:dictThisMonth[@"REVENUE"]]];
        self.labelDoanhThuThangSoVoiThangTruoc.text = [[Utils strCurrency:compareValue] stringByAppendingString:@" vnđ"];
        self.labelDoanhThuThangSoVoiThangTruoc.textColor = color;
        self.imageDoanhThuThang.image = [UIImage imageNamed:imageName];
    }];
}

- (void)getChiPhiThang {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
                            };
    
    [CallAPI callApiService:@"report/rp_cost" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        
        NSArray *arrayRevenue = dictData[@"INFO"];
        NSDictionary *dictLastMonth = arrayRevenue[0];
        NSDictionary *dictThisMonth = arrayRevenue[1];
        
        long long compare = [dictThisMonth[@"COST"] longLongValue] - [dictLastMonth[@"COST"] longLongValue];
        NSString *compareValue = @"";
        NSString *imageName = @"";
        UIColor *color;
        if (compare == 0) {
            compareValue = @"";
            imageName = @"icon_equal";
            color = RGB_COLOR(255, 165, 0);
        }else if (compare < 0) {
            compareValue = [NSString stringWithFormat:@"%lld",compare*(-1)];
            imageName = @"arrow_down";
            color = [UIColor redColor];
        }else{
            compareValue = [NSString stringWithFormat:@"%lld",compare];
            imageName = @"arrow_up";
            color = RGB_COLOR(0, 146, 32);
        }
        
        self.labelChiPhiThang.text = [NSString stringWithFormat:@"%@ vnđ",[Utils strCurrency:dictThisMonth[@"COST"]]];
        self.labelChiPhiSoThangTruoc.text = [[Utils strCurrency:compareValue] stringByAppendingString:@" vnđ"];
        self.labelChiPhiSoThangTruoc.textColor = color;
        self.iamgeChiPhiThang.image = [UIImage imageNamed:imageName];
    }];
}

- (void)getReportAll {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
    };
    
    [CallAPI callApiService:@"report/rp_profit" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        
        NSArray *arrayRevenue = dictData[@"INFO"];
        NSDictionary *dictResult = arrayRevenue[0];
        
        self.labelDuNo.text = [NSString stringWithFormat:@"%@ vnđ",[Utils strCurrency:dictResult[@"BALANCE"]]];
        self.labelDuNo.textColor = [dictResult[@"BALANCE"] longLongValue] > 0 ? UIColor.blueColor : UIColor.redColor;
        self.labelDoanhThuTronDoi.text = [NSString stringWithFormat:@"%@ vnđ",[Utils strCurrency:dictResult[@"PROFIT"]]];
    }];
    
}

- (void)reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kMyHome"]) {
        NSDictionary *dictHome = notif.object;
        if (dictHome.allKeys.count != 0) {
            self.labelHome.text = [NSString stringWithFormat:@"%@",dictHome[@"NAME"]];
            [self getNumberBookDay:dictHome[@"GENLINK"]];
        }
    }
}

@end
