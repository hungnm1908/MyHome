//
//  HistoryPaymentRentCarViewController.m
//  MyHome
//
//  Created by HuCuBi on 4/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "HistoryPaymentRentCarViewController.h"
#import "HistoryPaymentRentCarTableViewCell.h"

@interface HistoryPaymentRentCarViewController ()

@end

@implementation HistoryPaymentRentCarViewController {
    NSArray *arrayHistory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getUserInfo];
    
    [self.tableView addSubview:self.refreshControl];
}

- (void)handleRefresh : (id)sender {
    arrayHistory = [NSArray array];
    [self.tableView reloadData];
    [self getUserInfo];
    [self.refreshControl endRefreshing];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HistoryPaymentRentCarTableViewCell";
    HistoryPaymentRentCarTableViewCell *cell = (HistoryPaymentRentCarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayHistory[indexPath.row]];
    
    cell.labelCode.text = dict[@"id"];
    cell.labelNote.text = dict[@"note"];
    cell.labelMoney.text = dict[@"money"];
    cell.labelAfterMoney.text = dict[@"after_money"];
    cell.labelCreateDate.text = [self converDate:dict[@"create_date"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayHistory.count;
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

- (void)getListHistory : (NSString *)phoneNumber {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"BOOKER_TEL":phoneNumber
                            };
    
    [CallAPI callApiService:@"bookcar/get_finance" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayHistory = dictData[@"INFO"][@"finances"];
        if (self->arrayHistory.count > 0) {
            self.labelNote.hidden = YES;
        }else{
            self.labelNote.hidden = NO;
        }
        [self.tableView reloadData];
    }];
}

- (void)getUserInfo {
    NSDictionary *dictParam = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                @"USERID":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
    };
    
    [CallAPI callApiService:@"user/get_info" dictParam:dictParam isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSDictionary *dictUser = dictData[@"INFO"][0];
        NSString *phoneNumber = dictUser[@"MOBILE"];
        if (phoneNumber.length > 0) {
            [self getListHistory:phoneNumber];
        }else{
            self.labelNote.hidden = NO;
        }
    }];
}

@end
