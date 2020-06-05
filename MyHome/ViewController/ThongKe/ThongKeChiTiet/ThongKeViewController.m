//
//  ThongKeViewController.m
//  MyHome
//
//  Created by Macbook on 8/15/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ThongKeViewController.h"
#import "CommonTableViewController.h"

@interface ThongKeViewController ()

@end

@implementation ThongKeViewController {
    float currentHeightViewSearch;
    
    NSMutableDictionary *dictReport;
    NSMutableArray *arraySection;
    
    CKCalendarView *calendarView;
    NSDate *fromDate;
    NSDate *toDate;
    
    BOOL isFromDate;
    UIView *viewCalendar;
    
    NSDictionary *dictHome;
    NSArray *arrayHome;
    
    BOOL isSettup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (isSettup == NO) {
        isSettup = YES;
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self createCalendar];
        [self getListThongKe];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kMyHome" object:nil];
    }
}

- (IBAction)selectMyHome:(id)sender {
    if (arrayHome.count > 0) {
        [self selectHome];
    }else{
        [self getListMyRoom];
    }
}

- (void)getReport {
    arraySection = [NSMutableArray array];
    dictReport = [NSMutableDictionary dictionary];
    [self.tableView reloadData];
    [self getListThongKe];
}

- (IBAction)selectFromDate:(id)sender {
    isFromDate = YES;
    [self showCalendar];
}

- (IBAction)selectToDate:(id)sender {
    isFromDate = NO;
    [self showCalendar];
}

- (void)selectHome {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = arrayHome;
    vc.typeView = kMyHome;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)createCalendar {
    NSString *firstDay = [@"01/" stringByAppendingString:self.month];
    self.textFieldFromDate.text = firstDay;
    
    NSString *monthReport = [[self.month componentsSeparatedByString:@"/"] firstObject];
    NSString *lastDay = [NSString stringWithFormat:@"%@/%@",[self getLastDayOfMonth:[monthReport intValue]],self.month];
    self.textFieldToDate.text = lastDay;
    
    viewCalendar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    viewCalendar.backgroundColor = [UIColor clearColor];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    btnClose.backgroundColor = [UIColor blackColor];
    btnClose.alpha = 0.6;
    [btnClose addTarget:self action:@selector(closeCalendar) forControlEvents:UIControlEventTouchUpInside];
    [viewCalendar addSubview:btnClose];
    
    calendarView = [[CKCalendarView alloc] init];
    if (fromDate) {
        [calendarView setMonthShowing:fromDate];
        [calendarView selectDate:fromDate makeVisible:NO];
    }
    
    calendarView.center = viewCalendar.center;
    [viewCalendar addSubview:calendarView];
    calendarView.delegate = self;
}

- (void)showCalendar {
    [self.textFieldNameHome resignFirstResponder];
    [[[self appDelegate] window] addSubview:viewCalendar];
}

- (void)closeCalendar {
    [viewCalendar removeFromSuperview];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *day = [dateFormatter stringFromDate:date];
    
    if (isFromDate) {
        self.textFieldFromDate.text = day;
    }else{
        self.textFieldToDate.text = day;
    }
    
    [self closeCalendar];
    calendarView = nil;
    
    [self getReport];
}

- (NSString *)getLastDayOfMonth : (int)month {
    if (month == 2) {
        return @"28";
    }else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12){
        return @"31";
    }else{
        return @"30";
    }
}

- (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ThongKeTableViewCell";
    ThongKeTableViewCell *cell = (ThongKeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *key = arraySection[indexPath.section];
    NSArray *arrayReport = dictReport[key];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayReport[indexPath.row]];
    
    long long loiNhuan = [dict[@"REVENUE"] longLongValue];
    long long chiPhi = [dict[@"SELL_COSTS"] longLongValue] + [dict[@"SERVICE_COSTS"] longLongValue] + [dict[@"OTHER_COSTS"] longLongValue];
    long long doanhThu = [dict[@"BOOK_PRICE"] longLongValue];
    
    cell.labelDoanhThu.text = [Utils strCurrency:[NSString stringWithFormat:@"%lld",doanhThu]];
    cell.labelChiPhi.text = [Utils strCurrency:[NSString stringWithFormat:@"%lld",chiPhi]];
    cell.labelLoiNhuan.text = [Utils strCurrency:[NSString stringWithFormat:@"%lld",loiNhuan]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = arraySection[section];
    NSArray *arrayReport = dictReport[key];
    return arrayReport.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arraySection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return arraySection[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *cellIdentifier = @"ThongKeSection";
    ThongKeSection *cell = (ThongKeSection *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *key = arraySection[section];
    cell.labelTitle.text = [[key componentsSeparatedByString:@"#"] lastObject];
    
    return cell;
}

#pragma mark CallAPI

- (void)getListThongKe {
    self.labelDoanhThuTong.text = @"0 vnđ";
    self.labelChiPhiTong.text = @"0 vnđ";
    self.labelLoiNhuan.text = @"0 vnđ";
    
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ROOM_NAME":dictHome ? dictHome[@"GENLINK"] : @"",
                            @"BOOKING_NAME":@"",
                            @"START_TIME":self.textFieldFromDate.text,
                            @"END_TIME":self.textFieldToDate.text
                            };
    
    [CallAPI callApiService:@"report/get_report_detail" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayReport = dictData[@"INFO"];
        self->dictReport = [NSMutableDictionary dictionary];
        self->arraySection = [NSMutableArray array];
        
        long long loiNhuanTong = 0;
        long long chiPhiTong = 0;
        long long doanhThuTong = 0;
        
        NSString *key = @"";
        long long total = 0;
        for (NSDictionary *dict in arrayReport) {
            total += [dict[@"REVENUE"] longLongValue];
            NSString *newKey = [NSString stringWithFormat:@"%@#%@",dict[@"GENLINK"],dict[@"ROOM_NAME"]];
            if (![key isEqualToString:newKey]) {
                key = newKey;
                [self->arraySection addObject:key];
                [self->dictReport setObject:[NSMutableArray array] forKey:key];
            }
            [self->dictReport[key] addObject:dict];
            
            long long loiNhuan = [dict[@"REVENUE"] longLongValue];
            long long chiPhi = [dict[@"SELL_COSTS"] longLongValue] + [dict[@"SERVICE_COSTS"] longLongValue] + [dict[@"OTHER_COSTS"] longLongValue];
            long long doanhThu = [dict[@"BOOK_PRICE"] longLongValue];
            
            loiNhuanTong += loiNhuan;
            chiPhiTong += chiPhi;
            doanhThuTong += doanhThu;
        }
        
        self.labelDoanhThuTong.text = [[Utils strCurrency:[NSString stringWithFormat:@"%lld",doanhThuTong]] stringByAppendingFormat:@" vnđ"];
        self.labelChiPhiTong.text = [[Utils strCurrency:[NSString stringWithFormat:@"%lld",chiPhiTong]] stringByAppendingFormat:@" vnđ"];
        self.labelLoiNhuan.text = [[Utils strCurrency:[NSString stringWithFormat:@"%lld",loiNhuanTong]] stringByAppendingFormat:@" vnđ"];
        
        [self.tableView reloadData];
    }];
}

- (void)getListMyRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"OPT":@""
                            };
    
    [CallAPI callApiService:@"room/get_mylist_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayHome = dictData[@"INFO"];
        [self selectHome];
    }];
}

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kMyHome"]) {
        dictHome = notif.object;
        if (dictHome.count > 0) {
            self.textFieldNameHome.text = dictHome[@"NAME"];
        }else{
            self.textFieldNameHome.text = @"- Tất cả -";
            dictHome = nil;
        }
        
        [self getReport];
    }
}

@end
