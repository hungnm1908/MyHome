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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self createCalendar];
    [self getListThongKe];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kMyHome" object:nil];
}

- (IBAction)selectMyHome:(id)sender {
    if (arrayHome.count > 0) {
        [self selectHome];
    }else{
        [self getListMyRoom];
    }
}

- (IBAction)showViewSearch:(id)sender {
    self.heightViewSearch.constant = currentHeightViewSearch;
    self.viewSearch.hidden = NO;
}

- (IBAction)hideViewSearch:(id)sender {
    currentHeightViewSearch = self.heightViewSearch.constant;
    self.heightViewSearch.constant = 30;
    self.viewSearch.hidden = YES;
}

- (IBAction)getReport:(id)sender {
    arraySection = [NSMutableArray array];
    dictReport = [NSMutableDictionary dictionary];
    [self.tableView reloadData];
    
    [self hideViewSearch:nil];
    [self.textFieldNameBooker resignFirstResponder];
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
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)createCalendar {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    self.textFieldToDate.text = now;
    
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateStyle:NSDateFormatterShortStyle];
    [yearFormatter setDateFormat:@"MM/yyyy"];
    NSString *from = [@"01/" stringByAppendingString:[yearFormatter stringFromDate:[NSDate date]]];
    self.textFieldFromDate.text = from;
    
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
    [self.textFieldNameBooker resignFirstResponder];
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
    
    cell.labelNameRoom.text = dict[@"BOOK_NAME"];
    cell.labelTime.text = [NSString stringWithFormat:@"từ : %@\nđến : %@",dict[@"START_TIME"],dict[@"END_TIME"]];
    cell.labelMoney.text = [Utils strCurrency:dict[@"REVENUE"]];
    
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
    
    cell.labelTitle.text = arraySection[section];
    
    return cell;
}

#pragma mark CallAPI

- (void)getListThongKe {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOKROOM":@"",
                            @"ROOM_NAME":self.textFieldNameHome.text,
                            @"BOOKING_NAME":self.textFieldNameBooker.text,
                            @"START_TIME":self.textFieldFromDate.text,
                            @"END_TIME":self.textFieldToDate.text
                            };
    
    [CallAPI callApiService:@"room/get_report" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayReport = dictData[@"INFO"];
        self->dictReport = [NSMutableDictionary dictionary];
        self->arraySection = [NSMutableArray array];
        NSString *key = @"";
        long long total = 0;
        for (NSDictionary *dict in arrayReport) {
            total += [dict[@"REVENUE"] longLongValue];
            if (![key isEqualToString:dict[@"ROOM_NAME"]]) {
                key = dict[@"ROOM_NAME"];
                [self->arraySection addObject:key];
                [self->dictReport setObject:[NSMutableArray array] forKey:key];
            }
            [self->dictReport[key] addObject:dict];
        }
        self.labelTotal.text = [NSString stringWithFormat:@"%@ vnđ",[Utils strCurrency:[NSString stringWithFormat:@"%lld",total]]];
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
        self.textFieldNameHome.text = dictHome[@"NAME"];
    }
}

@end
