//
//  ListBookCalendarViewController.m
//  MyHome
//
//  Created by Macbook on 10/9/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListBookCalendarViewController.h"
#import "BookingSelectDayCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "BookingDate.h"
#import "BookingPaymentViewController.h"
#import "BookCleanServiceViewController.h"

@interface ListBookCalendarViewController ()

@end

@implementation ListBookCalendarViewController {
    NSDictionary *dictBookingDate;
    NSCalendar *calender;
    
    NSMutableArray *arrayMonth;
    NSMutableDictionary *listBookingDate;
    
    BOOL isSelectStartDate;
    NSMutableArray *arraySelectDate;
    NSDate *startDateLock;
    NSDate *endDateLock;
    
    NSMutableArray *arrayDisableDate;
    NSMutableArray *arrayDisableStartDate;
    NSMutableArray *arrayDisableEndDate;
    
    NSDictionary *userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    
    isSelectStartDate = YES;
    
    calender = [NSCalendar autoupdatingCurrentCalendar];
    [calender setTimeZone:[NSTimeZone systemTimeZone]];
    
    [self settupCalendar];
}

#pragma mark CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return arrayMonth.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BookingSelectDayCollectionViewCell";
    
    BookingSelectDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDateComponents *comps = arrayMonth[indexPath.section];
    NSArray *arrayBookingDate = [listBookingDate objectForKey:[NSString stringWithFormat:@"Tháng %ld, %ld",(long)comps.month,(long)comps.year]];
    BookingDate *bkDate = arrayBookingDate[indexPath.row];
    bkDate.isToday = [self _dateIsToday:bkDate.date];
    bkDate.isSelect = [arraySelectDate containsObject:bkDate.date];
    
    cell.labelDate.text = [bkDate getTextDate];
    cell.labelDate.textColor = [bkDate getTextDateColor];
    
    cell.labelPrice.text = [bkDate getTextPrice];
    cell.labelPrice.textColor = [bkDate getTextPriceColor];
    
    cell.backgroundColor = [bkDate getBackgroundColor];
    cell.viewIsToDay.backgroundColor = [bkDate getBackgroundColorViewToDay];
    cell.viewDisableEndDate.hidden = !bkDate.isDisableFirstDate;
    cell.viewDisableFirstDate.hidden = !bkDate.isDisableEndDate;
    cell.viewDisableEndDate.backgroundColor = [bkDate getDisableEndViewColor];
    cell.viewDisableFirstDate.backgroundColor = [bkDate getDisableStartViewColor];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int width = (int)([UIScreen mainScreen].bounds.size.width)/7;
    int height = width;
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([userInfo[@"USER_TYPE"] intValue] == 1 ||
        [userInfo[@"USER_TYPE"] intValue] == 0 ||
        [userInfo[@"USER_TYPE"] intValue] == 4) {//là chủ nhà hoặc admin hoặc qldondep mới được khóa nhà
        NSDateComponents *comps = arrayMonth[indexPath.section];
        NSArray *arrayBookingDate = [listBookingDate objectForKey:[NSString stringWithFormat:@"Tháng %ld, %ld",(long)comps.month,(long)comps.year]];
        BookingDate *bkDate = arrayBookingDate[indexPath.row];
        
        if (bkDate.date && [self checkSelectDate:bkDate.date]) {
            if (isSelectStartDate) {
                arraySelectDate = [NSMutableArray array];
                [arraySelectDate addObject:bkDate.date];
                [self.collectionView reloadData];
                
                startDateLock = bkDate.date;
                isSelectStartDate = NO;
            }else{
                endDateLock = bkDate.date;
                isSelectStartDate = YES;
                [self getArraySelectDate];
            }
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSDateComponents *comps = arrayMonth[indexPath.section];
        
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCollectionReusableView" forIndexPath:indexPath];
        headerView.labelTitle.text = [NSString stringWithFormat:@"Tháng %ld, %ld",(long)comps.month,(long)comps.year];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (BOOL)checkSelectDate : (NSDate *)dateSelect {
    BOOL isOK = YES;
    if ([self _numberOfDaysFromDate:dateSelect toDate:[NSDate date]]/60/60 > 24) {
        isOK = NO;
        [Utils alertError:@"Ngày chọn không hợp lệ" content:@"Ngày khóa nhà phải sau ngày hôm nay. Mời chọn lại" viewController:nil completion:^{
            
        }];
    } else {
        if (isSelectStartDate) {
            if ([arrayDisableStartDate containsObject:dateSelect]) {
                isOK = NO;
                [Utils alertError:@"Ngày bắt đầu không hợp lệ" content:@"Ngày đã chọn trùng với lịch đặt nhà đã có. Mời chọn lại" viewController:nil completion:^{
                    
                }];
            }else{
                isOK = YES;
            }
        }else{
            if ([self _numberOfDaysFromDate:startDateLock toDate:dateSelect] <= 0) {
                isOK = NO;
                [Utils alertError:@"Ngày kết thúc không hợp lệ" content:@"Ngày kết thúc phải sau ngày bắt đầu. Mời chọn lại" viewController:nil completion:^{
                    
                }];
            }else if ([arrayDisableEndDate containsObject:dateSelect]) {
                isOK = NO;
                [Utils alertError:@"Ngày kết thúc không hợp lệ" content:@"Ngày đã chọn trùng với lịch đặt nhà đã tồn tại. Mời chọn lại" viewController:nil completion:^{
                    
                }];
            }else if (![self checkEndDate:dateSelect]) {
                isOK = NO;
                [Utils alertError:@"Ngày kết thúc không hợp lệ" content:@"Trong nhưng ngày đã chọn, có ngày trùng với lịch đặt nhà đã tồn tại. Mời chọn lại" viewController:nil completion:^{
                    
                }];
            }else{
                isOK = YES;
            }
        }
    }
    
    
    return isOK;
}

- (void)getArraySelectDate {
    arraySelectDate = [NSMutableArray array];
    NSDate *nextDate = startDateLock;
    while ([Utils _numberOfDaysFromDate:nextDate toDate:endDateLock] >= 0) {
        [arraySelectDate addObject:nextDate];
        nextDate = [Utils _nextDay:nextDate];
    }
    [self.collectionView reloadData];
    [self performSelector:@selector(confirmLockRoom) withObject:nil afterDelay:1.0];
}

- (BOOL)checkEndDate : (NSDate *)selectDate {
    BOOL isOK = YES;
    
    NSMutableArray *arraySelect = [NSMutableArray array];
    NSDate *nextDate = [self _nextDay:startDateLock];
    while ([Utils _numberOfDaysFromDate:nextDate toDate:selectDate] >= 0) {
        [arraySelect addObject:nextDate];
        nextDate = [Utils _nextDay:nextDate];
    }
    
    for (NSDate *mDate in arraySelect) {
        if ([arrayDisableEndDate containsObject:mDate]) {
            isOK = NO;
            break;
        }
    }
    
    return isOK;
}

- (void)confirmLockRoom {
    NSString *strNumberLock = [NSString stringWithFormat:@"%d ngày\n%d đêm",(int)[Utils _numberOfDaysFromDate:startDateLock toDate:endDateLock]+1,(int)[Utils _numberOfDaysFromDate:startDateLock toDate:endDateLock]];
    
    NSString *strStartDateLock = [NSString stringWithFormat:@"%@ ngày %@",[Utils getDayName:startDateLock],[Utils getDateFromDate:startDateLock]];
    
    NSString *strEndDateLock = [NSString stringWithFormat:@"%@ ngày %@",[Utils getDayName:endDateLock],[Utils getDateFromDate:endDateLock]];
    
    NSString *content = [NSString stringWithFormat:@"Bạn muốn khóa nhà trong %@ ? (từ %@ đến %@)",strNumberLock,strStartDateLock,strEndDateLock];
    
    [Utils alertWithCancelProcess:@"Xác nhận khóa nhà" content:content titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        [self lookRoom];
    } cancel:^{
        self->arraySelectDate = [NSMutableArray array];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Calendar helpers

- (BOOL)checkIsBillingStartFromDate : (NSDate *)date {
    for (NSDictionary *dict in self.arrayBookReport) {
        NSMutableArray *arrayBookDates = [NSMutableArray array];
        NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
        NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
        NSDate *nextDate = startDate;
        while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
            [arrayBookDates addObject:nextDate];
            nextDate = [Utils _nextDay:nextDate];
        }
        
        if ([arrayBookDates containsObject:date]) {
            if ([dict[@"BILLING_STATUS"] intValue] != 0) {
                if ([date isEqualToDate:startDate]) {
                    return NO;
                }else{
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (BOOL)checkIsBillingEndFromDate : (NSDate *)date {
    for (NSDictionary *dict in self.arrayBookReport) {
        NSMutableArray *arrayBookDates = [NSMutableArray array];
        NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
        NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
        NSDate *nextDate = startDate;
        while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
            [arrayBookDates addObject:nextDate];
            nextDate = [Utils _nextDay:nextDate];
        }
        
        if ([arrayBookDates containsObject:date]) {
            if ([dict[@"BILLING_STATUS"] intValue] != 0) {
                if ([date isEqualToDate:endDate]) {
                    return NO;
                }else{
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (void)settupCalendar {
    arrayDisableDate = [NSMutableArray array];
    for (NSDictionary *dict in self.arrayBookReport) {
        NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
        NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
        NSDate *nextDate = startDate;
        while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
            [arrayDisableDate addObject:nextDate];
            nextDate = [Utils _nextDay:nextDate];
        }
    }
    
    arrayDisableStartDate = [NSMutableArray array];
    for (NSDictionary *dict in self.arrayBookReport) {
        NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
        NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
        NSDate *nextDate = startDate;
        while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] > 0) {
            [arrayDisableStartDate addObject:nextDate];
            nextDate = [Utils _nextDay:nextDate];
        }
    }
    
    arrayDisableEndDate = [NSMutableArray array];
    for (NSDictionary *dict in self.arrayBookReport) {
        NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
        NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
        NSDate *nextDate = [self _nextDay:startDate];
        while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
            [arrayDisableEndDate addObject:nextDate];
            nextDate = [Utils _nextDay:nextDate];
        }
    }
    
    unsigned int unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [calender components:unitFlags fromDate:[self _firstDayOfNextMonthContainingDate:self.startDate]  toDate:[self _firstDayOfNextMonthContainingDate:self.endDate]  options:0];
    int months = (int)[comps month];
    
    listBookingDate = [NSMutableDictionary dictionary];
    
    arrayMonth = [NSMutableArray array];
    NSDate *currentDate = self.startDate;
    NSDateComponents *thisComps = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    thisComps.day = 1;
    [arrayMonth addObject:thisComps];
    [listBookingDate setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"Tháng %ld, %ld",(long)thisComps.month,(long)thisComps.year]];
    
    for (int i=0; i<months; i++) {
        NSDateComponents *comps = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
        comps.day = 1;
        if (comps.month + 1 == 13) {
            comps.month = 1;
            comps.year = comps.year + 1;
        }else{
            comps.month = comps.month + 1;
        }
        [arrayMonth addObject:comps];
        
        [listBookingDate setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"Tháng %ld, %ld",(long)comps.month,(long)comps.year]];
        
        currentDate = [self _firstDayOfNextMonthContainingDate:currentDate];
    }
    
    for (NSDateComponents *comps in arrayMonth) {
        NSDate *firstDate = [calender dateFromComponents:comps];
        
        int start = [Utils placeInWeekForDate:firstDate];
        
        for (int i=0; i<42; i++) {
            if (i<start) {
                BookingDate *bkDate = [[BookingDate alloc] init];
                [[listBookingDate objectForKey:[NSString stringWithFormat:@"Tháng %ld, %ld",(long)comps.month,(long)comps.year]] addObject:bkDate];
            }else{
                NSDateComponents *day = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:firstDate];
                
                if (day.month == comps.month) {
                    BookingDate *bkDate = [[BookingDate alloc] init];

                    bkDate.isDisable = NO;
                    bkDate.isBillingFirstDate = [self checkIsBillingStartFromDate:firstDate];
                    bkDate.isBillingEndDate = [self checkIsBillingEndFromDate:firstDate];
                    bkDate.isDisableFirstDate = [arrayDisableStartDate containsObject:firstDate];
                    bkDate.isDisableEndDate = [arrayDisableEndDate containsObject:firstDate];
                    bkDate.date = firstDate;
                    [[listBookingDate objectForKey:[NSString stringWithFormat:@"Tháng %ld, %ld",(long)comps.month,(long)comps.year]] addObject:bkDate];
                    firstDate = [self _nextDay:firstDate];
                }else{
                    BookingDate *bkDate = [[BookingDate alloc] init];
                    [[listBookingDate objectForKey:[NSString stringWithFormat:@"Tháng %ld, %ld",(long)comps.month,(long)comps.year]] addObject:bkDate];
                }
            }
        }
    }
    
    [self.collectionView reloadData];
}

- (NSDate *)_firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    comps.day = 1;
    return [calender dateFromComponents:comps];
}

- (NSDate *)_firstDayOfNextMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    comps.day = 1;
    comps.month = comps.month + 1;
    return [calender dateFromComponents:comps];
}

- (NSComparisonResult)_compareByMonth:(NSDate *)date toDate:(NSDate *)otherDate {
    NSDateComponents *day = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    NSDateComponents *day2 = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:otherDate];
    
    if (day.year < day2.year) {
        return NSOrderedAscending;
    } else if (day.year > day2.year) {
        return NSOrderedDescending;
    } else if (day.month < day2.month) {
        return NSOrderedAscending;
    } else if (day.month > day2.month) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (BOOL)_dateIsToday:(NSDate *)date {
    return [self date:[NSDate date] isSameDayAsDate:date];
}

- (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2 {
    // Both dates must be defined, or they're not the same
    if (date1 == nil || date2 == nil) {
        return NO;
    }
    
    NSDateComponents *day = [calender components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date1];
    NSDateComponents *day2 = [calender components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date2];
    return ([day2 day] == [day day] &&
            [day2 month] == [day month] &&
            [day2 year] == [day year] &&
            [day2 era] == [day era]);
}

- (NSInteger)_numberOfWeeksInMonthContainingDate:(NSDate *)date {
    return [calender rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date].length;
}

- (NSDate *)_nextDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [calender dateByAddingComponents:comps toDate:date options:0];
}

- (NSDate *)_previousDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    return [calender dateByAddingComponents:comps toDate:date options:0];
}

- (NSInteger)_numberOfDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    return [endDate timeIntervalSinceDate:startDate];
}

- (BOOL)checkArrayDisaleDateContainDate : (NSDate *)date {
    for (NSDate *disableDate in arrayDisableDate) {
        if ([self date:disableDate isSameDayAsDate:date]) {
            return YES;
        }
    }
    return NO;
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

#pragma mark CallAPI

- (void)checkThisRoom : (NSDictionary *)dictHome {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : dictHome[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"/book/check_lock" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        if ([dictData[@"STATUS"] intValue] == 1) {
            
        }else{
            [Utils alertError:@"Thông báo" content:@"Bạn không được khóa nhà này" viewController:nil completion:^{

            }];
        }
    }];
}

- (void)lookRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK":self.dictRoom[@"GENLINK"],
                            @"CHECKIN":[Utils getDateFromDate:startDateLock],
                            @"CHECKOUT":[Utils getDateFromDate:endDateLock],
    };
    
    [CallAPI callApiService:@"book/lockroom" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBookingRoomStatus object:nil];
        
        NSDictionary *paramCleanRoom = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                         @"GENLINK":self.dictRoom[@"GENLINK"],
                                         @"CHECKIN":param[@"CHECKIN"],
                                         @"CHECKOUT":param[@"CHECKOUT"],
                                         @"ID_BOOKROOM":dictData[@"ID_BOOKROOM"],
                                         @"NOTE":@""
        };
        
        BookCleanServiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookCleanServiceViewController"];
        vc.dictParam = paramCleanRoom;
        [[self appDelegate].window.rootViewController.view addSubview:vc.view];
        [[self appDelegate].window.rootViewController addChildViewController:vc];
        
//        if ( [self->userInfo[@"USER_TYPE"] intValue] == 0 || [self->userInfo[@"USER_TYPE"] intValue] == 4) {//Là admin hoặc qldondep thì đặt  dọn phòng luôn
//
//        }else{
//
//            [Utils alert:@"Thông báo" content:mes titleOK:@"Đồng ý" titleCancel:@"Để sau" viewController:nil completion:^{
//                [self bookCleanRoom:paramCleanRoom];
//            }];
//        }
    }];
    
}

@end
