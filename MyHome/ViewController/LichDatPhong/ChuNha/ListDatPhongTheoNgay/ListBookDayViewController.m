//
//  ListBookDayViewController.m
//  MyHome
//
//  Created by Macbook on 10/3/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListBookDayViewController.h"
#import "ListBookDayTableViewCell.h"
#import "InformationViewController.h"

@interface ListBookDayViewController ()

@end

@implementation ListBookDayViewController {
    NSMutableArray *arrayMonth;
    NSMutableDictionary *listDate;
    NSMutableArray *arrayBookDate;
    NSCalendar *calendar;
    NSMutableArray *arrayBookRoomIsBilling;
    
    BOOL isSettup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayBookRoomIsBilling = [NSMutableArray array];
    for (NSDictionary *dict in self.arrayBookReport) {
        if ([dict[@"BILLING_STATUS"] intValue] != 0) {
            [arrayBookRoomIsBilling addObject:dict];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isSettup) {
        isSettup = YES;
        [self settupCalendar];
    }
}

- (void)settupCalendar {
    calendar = [NSCalendar autoupdatingCurrentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    listDate = [NSMutableDictionary dictionary];
    
    arrayMonth = [NSMutableArray array];
    NSDate *startDate = [Utils getDateFromStringDate:self.startDate];
    NSDate *endDate = [Utils getDateFromStringDate:self.endDate];
    NSDate *nextDate = startDate;
    NSString *month = @"";
    
    while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
        NSString *newMonth = [self getMonthFromDate:nextDate];
        if (![month isEqualToString:newMonth]) {
            month = newMonth;
            [arrayMonth addObject:month];
            [listDate setObject:[NSMutableArray array] forKey:month];
        }
        [[listDate objectForKey:month] addObject:nextDate];
        nextDate = [Utils _nextDay:nextDate];
    }
    
    arrayBookDate = [NSMutableArray array];
    for (NSDictionary *dict in arrayBookRoomIsBilling) {
        NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
        NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
        NSDate *nextDate = startDate;
        while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
            [arrayBookDate addObject:nextDate];
            nextDate = [Utils _nextDay:nextDate];
        }
    }
    
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[self getIndexToday] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSString *)getDateFromDate : (NSDate *)date {
    NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
    [clientDateFormatter setDateFormat:@"dd"];
    
    NSString *day = [clientDateFormatter stringFromDate:date];
    
    return day;
}

- (NSString *)getMonthFromDate : (NSDate *)date {
    NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
    [clientDateFormatter setDateFormat:@"MM/yyyy"];
    
    NSString *month = [clientDateFormatter stringFromDate:date];
    
    return month;
}

- (NSDate *)getDateFromStringDate : (NSString *)date {
    NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
    [clientDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [clientDateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *clientDate = [clientDateFormatter dateFromString:date];
    
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    [calender setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:clientDate];
    NSDate *firstDate = [calender dateFromComponents:comps];
    return firstDate;
}

- (NSDate *)_nextDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [calendar dateByAddingComponents:comps toDate:date options:0];
}

- (NSDate *)_previousDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    return [calendar dateByAddingComponents:comps toDate:date options:0];
}

- (NSInteger)_numberOfDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSInteger startDay = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:startDate];
    NSInteger endDay = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:endDate];
    return endDay - startDay;
}

- (NSIndexPath *)getIndexToday {
    NSString *thisMonth = [self getMonthFromDate:[NSDate date]];
    NSArray *arrayDate = listDate[thisMonth];
    if (arrayDate) {
        int section=0;
        for (NSString *month in arrayMonth) {
            if ([month isEqualToString:thisMonth]) {
                break;
            }
            section++;
        }
        
        int row=0;
        for (NSDate *date in arrayDate) {
            if ([self date:date isSameDayAsDate:[NSDate date]]) {
                break;
            }
            row++;
        }
        return [NSIndexPath indexPathForRow:row inSection:section];
    }else{
        return [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

- (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2 {
    // Both dates must be defined, or they're not the same
    if (date1 == nil || date2 == nil) {
        return NO;
    }
    
    NSDateComponents *day = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date1];
    NSDateComponents *day2 = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date2];
    return ([day2 day] == [day day] &&
            [day2 month] == [day month] &&
            [day2 year] == [day year] &&
            [day2 era] == [day era]);
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListBookDayTableViewCell";
    ListBookDayTableViewCell *cell = (ListBookDayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *month = arrayMonth[indexPath.section];
    NSArray *arrayDate = listDate[month];
    NSDate *date = arrayDate[indexPath.row];
    
    cell.labelDate.text = [self getDateFromDate:date];
    
    if ([arrayBookDate containsObject:date]) {
        NSDictionary *dict = [self getBookDictFromDate:date];
        
        if ([self checkIsLockFromDate:date]) {
            cell.labelNameGuset.text = @"Chủ nhà tự khóa";
            cell.labelStatusBill.text = @"(bấm để mở khóa)";
            cell.labelStatusRoom.text = @"";
            [cell.btnLock addTarget:self action:@selector(unlockRoom:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.labelNameGuset.text = [NSString stringWithFormat:@"Người đặt: %@",dict[@"BOOK_NAME"]];
            cell.labelStatusBill.text = [NSString stringWithFormat:@"Trạng thái thanh toán: %@",dict[@"BILLING_STATUS_NAME"]];
            cell.labelStatusRoom.text = [NSString stringWithFormat:@"Trạng thái nhà: %@",dict[@"BOOK_STATUS_NAME"]];
        }
        cell.btnLock.hidden = ![self checkIsLockFromDate:date];
    }else{
        cell.labelNameGuset.text = @"";
        cell.labelStatusBill.text = @"";
        cell.labelStatusRoom.text = @"";
        cell.btnLock.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *month = arrayMonth[section];
    NSArray *arrayDate = listDate[month];
    return arrayDate.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrayMonth.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return arrayMonth[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, headerView.bounds.size.width-16*2, headerView.bounds.size.height-8*2)];
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 7;
    label.backgroundColor = RGB_COLOR(84, 125, 190);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = arrayMonth[section];
    [headerView addSubview:label];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *month = arrayMonth[indexPath.section];
    NSArray *arrayDate = listDate[month];
    NSDate *date = arrayDate[indexPath.row];
    
    if ([arrayBookDate containsObject:date]) {
        NSDictionary *dict = [self getBookDictFromDate:date];
        if (![self checkIsLockFromDate:date]) {
            InformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
            vc.userID = dict[@"USERID"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSDictionary *)getBookDictFromDate : (NSDate *)date {
    for (NSDictionary *dict in arrayBookRoomIsBilling) {
        NSMutableArray *arrayBookDates = [NSMutableArray array];
        NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
        NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
        NSDate *nextDate = startDate;
        while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
            [arrayBookDates addObject:nextDate];
            nextDate = [Utils _nextDay:nextDate];
        }
        
        if ([arrayBookDates containsObject:date]) {
            return dict;
        }
    }
    
    return @{};
}

- (BOOL)checkIsLockFromDate : (NSDate *)date {
    for (NSDictionary *dict in arrayBookRoomIsBilling) {
        NSMutableArray *arrayBookDates = [NSMutableArray array];
        NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
        NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
        NSDate *nextDate = startDate;
        while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
            [arrayBookDates addObject:nextDate];
            nextDate = [Utils _nextDay:nextDate];
        }
        
        if ([arrayBookDates containsObject:date] && [Utils lenghtText:dict[@"CONTENT"]] == 0) {
            return YES;
        }
    }
    
    return NO;
}

- (void)unlockRoom : (id)sender {
    [Utils alert:@"Mở khóa nhà" content:@"Bạn chắc chắn muốn mở khóa nhà ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        NSString *month = self->arrayMonth[hitIndex.section];
        NSArray *arrayDate = self->listDate[month];
        NSDate *date = arrayDate[hitIndex.row];
        
        NSDictionary *dict = [self getBookDictFromDate:date];
        
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


@end
