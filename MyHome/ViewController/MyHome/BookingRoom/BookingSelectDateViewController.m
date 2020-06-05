//
//  BookingSelectDateViewController.m
//  MyHome
//
//  Created by Macbook on 9/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "BookingSelectDateViewController.h"
#import "BookingInfoCustomerViewController.h"
#import "BookingSelectDayCollectionViewCell.h"
#import "BookingDate.h"

@interface BookingSelectDateViewController ()

@end

@implementation BookingSelectDateViewController {
    NSDictionary *dictBookingDate;
    NSCalendar *calender;
    
    NSMutableArray *arrayMonth;
    NSMutableDictionary *listBookingDate;
    
    BOOL isSelectStartDate;
    NSDate *startDate;
    NSDate *endDate;
    NSMutableArray *arraySelectDate;
    
    NSMutableArray *arrayDisableDate;
    NSMutableArray *arrayDisableStartDate;
    NSMutableArray *arrayDisableEndDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSelectStartDate = YES;
    
    calender = [NSCalendar autoupdatingCurrentCalendar];
    [calender setTimeZone:[NSTimeZone systemTimeZone]];
    
    if (self.isLookRoom) {
        self.labelStart.text = @"Ngày bắt đầu";
        self.labelEnd.text = @"Ngày kết thúc";
        [self.btnContinue setTitle:@"Khóa nhà" forState:UIControlStateNormal];
    }
    
    [self getListBookRoom];
}

- (IBAction)continue:(id)sender {
    if ([self checkEnoughInfo]) {
        if (self.isLookRoom) {
            [self lookRoom];
        }else{
            [self bookingContinue];
        }
    }
}

- (IBAction)removeSelectDay:(id)sender {
    arraySelectDate = [NSMutableArray array];
    [self.collectionView reloadData];
    isSelectStartDate = YES;
    self.labelStartDay.text = @" ";
    self.labelStartDate.text = @"dd/MM/yyyy";
    self.labelEndDay.text = @" ";
    self.labelEndDate.text = @"dd/MM/yyyy";
    self.labelNumberDate.text = @"-";
}

- (BOOL)checkEnoughInfo {
    BOOL isOK = YES;
    
    if (startDate == nil || self.labelStartDate.text.length == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn ngày bắt đầu" viewController:nil completion:^{
            
        }];
    }else if (endDate == nil || self.labelEndDate.text.length == 0){
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn ngày kết thúc" viewController:nil completion:^{
            
        }];
    }else if ([self _numberOfDaysFromDate:startDate toDate:endDate] < 0){
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Thời gian không hợp lệ. Ngày bắt đầu phải trước ngày kết thúc" viewController:nil completion:^{
            
        }];
    }else if ([self _numberOfDaysFromDate:startDate toDate:endDate] == 0){
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Thời gian không hợp lệ. Yêu cầu ở ít nhất 2 ngày 1 đêm" viewController:nil completion:^{
            
        }];
    }
    
    return isOK;
}

- (void)bookingContinue {
    BookingInfoCustomerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingInfoCustomerViewController"];
    vc.dictRoom = self.dictRoom;
    vc.dictBookingDate = @{@"StartDate":startDate,
                           @"EndDate":endDate};
    [self.navigationController pushViewController:vc animated:YES];
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
    
    cell.viewCurrentPrice.hidden = !bkDate.isDiscountDate;
    cell.labelCurrentPrice.text = [bkDate getTextCurrentPrice];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int width = (int)([UIScreen mainScreen].bounds.size.width)/7;
    int height = width;
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDateComponents *comps = arrayMonth[indexPath.section];
    NSArray *arrayBookingDate = [listBookingDate objectForKey:[NSString stringWithFormat:@"Tháng %ld, %ld",(long)comps.month,(long)comps.year]];
    BookingDate *bkDate = arrayBookingDate[indexPath.row];
    if (bkDate.date && [self checkSelectDate:bkDate.date]) {
        if (isSelectStartDate) {
            arraySelectDate = [NSMutableArray array];
            [arraySelectDate addObject:bkDate.date];
            [self.collectionView reloadData];
            
            self.labelEndDate.text = @"";
            self.labelEndDay.text = @"";
            self.labelNumberDate.text = @"-";
            
            self.labelStartDate.text = [Utils getDateFromDate:bkDate.date];
            self.labelStartDay.text = [Utils getDayName:bkDate.date];
            startDate = bkDate.date;
            isSelectStartDate = NO;
        }else{
            self.labelEndDate.text = [Utils getDateFromDate:bkDate.date];
            self.labelEndDay.text = [Utils getDayName:bkDate.date];
            
            endDate = bkDate.date;
            self.labelNumberDate.text = [NSString stringWithFormat:@"%d ngày\n%d đêm",(int)[Utils _numberOfDaysFromDate:startDate toDate:endDate]+1,(int)[Utils _numberOfDaysFromDate:startDate toDate:endDate]];
            isSelectStartDate = YES;
            [self getArraySelectDate];
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

- (void)getArraySelectDate {
    arraySelectDate = [NSMutableArray array];
    NSDate *nextDate = startDate;
    while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
        [arraySelectDate addObject:nextDate];
        nextDate = [Utils _nextDay:nextDate];
    }
    [self.collectionView reloadData];
}

- (BOOL)checkSelectDate : (NSDate *)dateSelect {
    BOOL isOK = YES;
    if ([self _numberOfDaysFromDate:dateSelect toDate:[NSDate date]]/60/60 > 24) {
        isOK = NO;
        [Utils alertError:@"Ngày chọn không hợp lệ" content:@"Ngày đặt nhà phải sau ngày hôm nay. Mời chọn lại" viewController:nil completion:^{
            
        }];
    } else if ([arrayDisableDate containsObject:dateSelect]) {
        isOK = NO;
        [Utils alertError:@"Ngày chọn không hợp lệ" content:@"Mời chọn lại" viewController:nil completion:^{
            
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
            if ([self _numberOfDaysFromDate:startDate toDate:dateSelect] <= 0) {
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

- (BOOL)checkEndDate : (NSDate *)selectDate {
    BOOL isOK = YES;
    
    NSMutableArray *arraySelect = [NSMutableArray array];
    NSDate *nextDate = [self _nextDay:startDate];
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

#pragma mark - Calendar helpers

- (void)settupCalendar {
    listBookingDate = [NSMutableDictionary dictionary];
    
    arrayMonth = [NSMutableArray array];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *thisComps = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currentDate];
    thisComps.day = 1;
    [arrayMonth addObject:thisComps];
    [listBookingDate setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"Tháng %ld, %ld",(long)thisComps.month,(long)thisComps.year]];
    
    for (int i=0; i<=11; i++) {
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
                    if ([self _numberOfDaysFromDate:firstDate toDate:[NSDate date]] > 0) {
                        bkDate.isDisable = YES;
                    }else{
                        if ([arrayDisableDate containsObject:firstDate]) {
                            bkDate.isDisable = YES;
                        }else{
                            bkDate.isDisable = NO;
                            bkDate.isDisableFirstDate = [arrayDisableStartDate containsObject:firstDate];
                            bkDate.isDisableEndDate = [arrayDisableEndDate containsObject:firstDate];
                        }
                    }
                    bkDate.date = firstDate;
                    
                    long long priceNormalValue = 0;
                    long long priceSpecialValue = 0;
                    
                    if ([Utils isTimePromotion:self.dictRoom:firstDate]) {
                        priceNormalValue = [self.dictRoom[@"PRICE"] longLongValue] - [self.dictRoom[@"DISCOUNT"] longLongValue];
                        priceSpecialValue = [self.dictRoom[@"PRICE_SPECIAL"] longLongValue] - [self.dictRoom[@"DISCOUNT"] longLongValue];
                        bkDate.isDiscountDate = YES;
                    }else{
                        priceNormalValue = [self.dictRoom[@"PRICE"] longLongValue];
                        priceSpecialValue = [self.dictRoom[@"PRICE_SPECIAL"] longLongValue];
                    }
                    
                    NSString *priceNormal = [NSString stringWithFormat:@"%lld",priceNormalValue];
                    NSString *priceSpecial = [NSString stringWithFormat:@"%lld",priceSpecialValue];
                    
                    NSString *priceCurrentNormal = [NSString stringWithFormat:@"%lld",[self.dictRoom[@"PRICE"] longLongValue]];
                    NSString *priceCurrentSpecial = [NSString stringWithFormat:@"%lld",[self.dictRoom[@"PRICE_SPECIAL"] longLongValue]];
                    
                    bkDate.priceNormal = [Utils convertNumber:priceNormal];
                    bkDate.priceSpecial = [Utils convertNumber:priceSpecial];
                    bkDate.priceNormalCurrent = [Utils convertNumber:priceCurrentNormal];
                    bkDate.priceSpecialCurrent = [Utils convertNumber:priceCurrentSpecial];
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
//
//    NSInteger startDay = [calender ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:startDate];
//    NSInteger endDay = [calender ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:endDate];
//    return endDay - startDay;
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
    [clientDateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSDate *clientDate = [clientDateFormatter dateFromString:date];
    
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    [calender setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:clientDate];
    NSDate *firstDate = [calender dateFromComponents:comps];
    return firstDate;
}

- (NSDate *)dateByAddingMonths : (NSDate *)date {
    NSDateComponents *comps = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    comps.year = comps.year + 1;
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *tDateMonth = [calender dateFromComponents:comps];
    
    return tDateMonth;
}

#pragma mark CallAPI

- (void)getListBookRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK":self.dictRoom[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"book/get_list_day" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        if ([dictData[@"ERROR"] isEqualToString:@"0000"]) {
            NSArray *arrayBook = dictData[@"INFO"];
            
            self->arrayDisableDate = [NSMutableArray array];
            for (NSDictionary *dict in arrayBook) {
                NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
                NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
                NSDate *nextDate = startDate;
                while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
                    [self->arrayDisableDate addObject:nextDate];
                    nextDate = [Utils _nextDay:nextDate];
                }
            }
            
            self->arrayDisableStartDate = [NSMutableArray array];
            for (NSDictionary *dict in arrayBook) {
                NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
                NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
                NSDate *nextDate = startDate;
                while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] > 0) {
                    [self->arrayDisableStartDate addObject:nextDate];
                    nextDate = [Utils _nextDay:nextDate];
                }
            }
            
            self->arrayDisableEndDate = [NSMutableArray array];
            for (NSDictionary *dict in arrayBook) {
                NSDate *startDate = [self getDateFromStringDate:dict[@"START_TIME"]];
                NSDate *endDate = [self getDateFromStringDate:dict[@"END_TIME"]];
                NSDate *nextDate = [self _nextDay:startDate];
                while ([Utils _numberOfDaysFromDate:nextDate toDate:endDate] >= 0) {
                    [self->arrayDisableEndDate addObject:nextDate];
                    nextDate = [Utils _nextDay:nextDate];
                }
            }
        }else{
            
        }
        [self settupCalendar];
    }];
}

- (void)lookRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK":self.dictRoom[@"GENLINK"],
                            @"CHECKIN":self.labelStartDate.text,
                            @"CHECKOUT":self.labelEndDate.text,
    };
    
    [CallAPI callApiService:@"book/lockroom" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
}

@end
