//
//  SearchResultViewController.m
//  MyHome
//
//  Created by Macbook on 8/7/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ThirdHomeTableViewCell.h"
#import "HomeDetailViewController.h"
#import "CommonTableViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController {
    CKCalendarView *calendarView;
    NSDate *fromDate;
    NSDate *toDate;
    
    BOOL isFromDate;
    UIView *viewCalendar;
    
    NSDictionary *dictProvince;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self createCalendar];
    [self settupRangerSlider];
    [self fillInformation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kProvince" object:nil];
}

- (IBAction)showSearchView:(id)sender {
    self.viewSearch.hidden = !self.viewSearch.hidden;
}

- (IBAction)closeSearchView:(id)sender {
    self.viewSearch.hidden = YES;
}

- (IBAction)search:(id)sender {
    if ([self checkEnoughInfo]) {
        self.viewSearch.hidden = YES;
        [self getListSearch];
    }
}

- (IBAction)selectFromDate:(id)sender {
    isFromDate = YES;
    [self showCalendar];
}

- (IBAction)selectToDate:(id)sender {
    isFromDate = NO;
    [self showCalendar];
}

- (IBAction)selectProvince:(id)sender {
    if ([VariableStatic sharedInstance].arrayProvince) {
        CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
        vc.arrayItem = [VariableStatic sharedInstance].arrayProvince;
        vc.typeView = kProvince;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self getProvince];
    }
}

- (BOOL)checkEnoughInfo {
    BOOL isOk = YES;
    
    if ([Utils lenghtText:self.textFieldFromDate.text] > 0 && [Utils lenghtText:self.textFieldToDate.text] > 0) {
        if ([Utils getDurationFromDate:self.textFieldFromDate.text toDate:self.textFieldToDate.text] > 0) {
            isOk = NO;
            [Utils alertError:@"Thông báo" content:@"Ngày bắt đầu đến phải trước ngày rời đi" viewController:nil completion:^{
                [self.textFieldToDate becomeFirstResponder];
            }];
        }
    }
    
    return isOk;
}

- (void)fillInformation {
    if (self.paramSearch.allKeys.count == 0) {
        [self showSearchView:nil];
    }else{
        self.textFieldTP.text = [self getNameTP:self.paramSearch[@"ID_PROVINCE"]];
        self.textFieldNameSearch.text = self.paramSearch[@"LOCATION"];
        self.textFieldFromDate.text = self.paramSearch[@"CHECKIN"];
        self.textFieldToDate.text = self.paramSearch[@"CHECKOUT"];
        self.textFieldNumberCustomer.text = self.paramSearch[@"PEOPLE"];
        self.labelMinCost.text = self.paramSearch[@"PRICE_FROM"];
        self.labelMaxCost.text = self.paramSearch[@"PRICE_TO"];
        
        [self getListSearch];
    }
}

- (NSString *)getNameTP : (NSString *)idProvince {
    NSString *nameProvince = @"";
    for (NSDictionary *dict in self.arrayBanner) {
        if ([dict[@"ID_PROVINCE"] isEqualToString:idProvince]) {
            nameProvince = dict[@"CITY_NAME"];
            dictProvince = @{@"MATP":dict[@"ID_PROVINCE"],
                             @"NAME":dict[@"CITY_NAME"],
                             @"OD":@"100",
                             @"TYPE":@"Thành phố"
            };
            break;
        }
    }
    return nameProvince;
}

- (void)createCalendar {
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
    self.viewSearch.hidden = YES;
    [self.textFieldNameSearch resignFirstResponder];
    [self.textFieldNumberCustomer resignFirstResponder];
    [[[self appDelegate] window] addSubview:viewCalendar];
}

- (void)closeCalendar {
    self.viewSearch.hidden = NO;
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

#pragma mark RangerSlider

- (void)settupRangerSlider {
    [self.rangeSlider addTarget:self action:@selector(rangeSliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    long long leftValue = [self.paramSearch[@"PRICE_FROM"] longLongValue]/100000;
    long long rightValue = [self.paramSearch[@"PRICE_TO"] longLongValue]/100000;
    
    [self.rangeSlider setMinValue:0 maxValue:150];
    [self.rangeSlider setLeftValue:leftValue rightValue:rightValue];
    
    self.rangeSlider.minimumDistance = 1;
    
    [self rangeSliderValueDidChange:self.rangeSlider];
}

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider {
    NSLog(@"%0.0f - %0.0f", slider.leftValue, slider.rightValue);
    
    long long leftValue = ((int)slider.leftValue)*100000;
    long long rightValue = ((int)slider.rightValue)*100000;
    
    self.labelMinCost.text = [NSString stringWithFormat:@"%@ vnđ",[Utils strCurrency:[NSString stringWithFormat:@"%0.0lld",leftValue]]];
    self.labelMaxCost.text = [NSString stringWithFormat:@"%@ vnđ",[Utils strCurrency:[NSString stringWithFormat:@"%0.0lld",rightValue]]];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ThirdHomeTableViewCell";
    ThirdHomeTableViewCell *cell = (ThirdHomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:_arrayHouses[indexPath.row]];
    
    cell.labelNameItem.text = dict[@"NAME"];
    cell.labelInforItem.text = [NSString stringWithFormat:@"%@\n\n%@ khách - %@ phòng - %@ giường",dict[@"ADDRESS"],dict[@"MAX_GUEST"],dict[@"MAX_ROOM"],dict[@"MAX_BED"]];
    cell.labelCostItem.text = [NSString stringWithFormat:@"%@ vnđ/đêm",[Utils getPrice:dict]];
    cell.labelDiscount.text = [NSString stringWithFormat:@"Hoa hồng: %@ vnđ/đêm",[Utils getBalance:dict]];
    
    if ([Utils isShowPromotion:dict]) {
        cell.viewCurrentCostItem.hidden = NO;
        cell.labelPercent.hidden = NO;
        cell.labelPercent.text = [NSString stringWithFormat:@"  - %@%c  ",dict[@"PERCENT"],'%'];
        cell.labelCurrentCostItem.text = [NSString stringWithFormat:@"%@ vnđ/đêm",[Utils strCurrency:dict[@"PRICE"]]];
    }else{
        cell.viewCurrentCostItem.hidden = YES;
        cell.labelPercent.hidden = YES;
    }
    
    NSString *link = [dict[@"COVER"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    link = [Utils convertStringUrl:link];
    link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
    NSURL *urlImage = [NSURL URLWithString:link];
    [cell.imageItem sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]]; 
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayHouses.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetailViewController"];
    vc.dictHome = [Utils converDictRemoveNullValue:_arrayHouses[indexPath.row]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark CallAPI

- (void)getListSearch {
    NSString *minCost = [self.labelMinCost.text stringByReplacingOccurrencesOfString:@" vnđ" withString:@""];
    minCost = [minCost stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *maxCost = [self.labelMaxCost.text stringByReplacingOccurrencesOfString:@" vnđ" withString:@""];
    maxCost = [maxCost stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"LOCATION" : self.textFieldNameSearch.text,
                            @"CHECKIN" : self.textFieldFromDate.text,
                            @"CHECKOUT" : self.textFieldToDate.text,
                            @"PEOPLE" : self.textFieldNumberCustomer.text,
                            @"PRICE_FROM" : minCost,
                            @"PRICE_TO" : maxCost,
                            @"AMENITIES" : @"",
                            @"ID_PROVINCE" : dictProvince?dictProvince[@"MATP"]:@"",
                            };
    
    [CallAPI callApiService:@"room/search_home2" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self.arrayHouses = dictData[@"INFO"];
        self.navigationItem.title = [NSString stringWithFormat:@"%@ (%lu)",self->dictProvince ? self->dictProvince[@"NAME"] : @"Kết quả tìm kiếm",(unsigned long)self.arrayHouses.count];
        [self.tableView reloadData];
    }];
}

- (void)getProvince {
    [CallAPI callApiService:@"get_city" dictParam:@{@"USERNAME":@""} isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
        [VariableStatic sharedInstance].arrayProvince = dictData[@"INFO"];
        
        [self selectProvince:nil];
    }];
}

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kProvince"]) {
        dictProvince = notif.object;
        self.textFieldTP.text = dictProvince[@"NAME"];
    }
}

@end
