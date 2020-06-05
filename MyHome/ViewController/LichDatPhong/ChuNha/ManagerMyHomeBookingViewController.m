//
//  ManagerMyHomeBookingViewController.m
//  MyHome
//
//  Created by Macbook on 10/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ManagerMyHomeBookingViewController.h"
#import "CommonTableViewController.h"
#import "ListBookCalendarViewController.h"
#import "ListBookRoomViewController.h"
#import "ListBookDayViewController.h"

@interface ManagerMyHomeBookingViewController ()

@end

@implementation ManagerMyHomeBookingViewController {
    NSDictionary *dictHome;
    NSArray *arrayMyHomes;
    BOOL isSettup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textFieldDateStart.text = [Utils getDateFromDate:[Utils getFirstDayOfThisMonth]];
    self.textFieldDateEnd.text = [Utils getDateFromDate:[Utils getLastDayOfMonth:5]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kMyHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:kCreateRoomSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:kUpdateRoomInforProperty object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:kUpdateBookingRoomStatus object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isSettup) {
        isSettup = YES;
        
        [self getListHome];
    }
}

- (IBAction)selectStartDate:(id)sender {
    [self.textFieldDateStart becomeFirstResponder];
}

- (IBAction)selectEndDate:(id)sender {
    [self.textFieldDateEnd becomeFirstResponder];
}

- (IBAction)selectHome:(id)sender {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = arrayMyHomes;
    vc.typeView = kMyHome;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)search:(id)sender {
    [self.textFieldDateStart resignFirstResponder];
    [self.textFieldDateEnd resignFirstResponder];
    if ([self isEnoughInfo]) {
        [self getListBookRoom];
    }
}

- (IBAction)changeViewReport:(UISegmentedControl *)sender {
    CGPoint point = CGPointMake(self.scrollView.bounds.size.width*sender.selectedSegmentIndex, 0);
    [self.scrollView setContentOffset:point animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = (int)scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    self.segmentControl.selectedSegmentIndex = currentPage;
}

- (BOOL)isEnoughInfo {
    BOOL isOK = YES;
    
    if (dictHome == nil) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn nhà cần tra cứu" viewController:nil completion:^{
            [self selectHome:nil];
        }];
    }else if (![Utils checkFromDate:self.textFieldDateStart.text toDate:self.textFieldDateEnd.text view:self]) {
        isOK = NO;
    }
    
    return isOK;
}

- (void)addSubViewCalendar : (NSArray *)arrayBookReport {
    for (UIView *subView in self.viewCalendar.subviews) {
        [subView removeFromSuperview];
    }
    
    ListBookCalendarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListBookCalendarViewController"];
    vc.dictRoom = dictHome;
    vc.arrayBookReport = arrayBookReport;
    vc.startDate = [Utils getDateFromStringDate:self.textFieldDateStart.text];
    vc.endDate = [Utils getDateFromStringDate:self.textFieldDateEnd.text];
    vc.view.frame = CGRectMake(0, 0, self.viewCalendar.frame.size.width, self.viewCalendar.frame.size.height);
    [self.viewCalendar addSubview:vc.view];
    [self addChildViewController:vc];
}

- (void)addSubViewListDay : (NSArray *)arrayBookReport {
    for (UIView *subView in self.viewDay.subviews) {
        [subView removeFromSuperview];
    }
    
    ListBookDayViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListBookDayViewController"];
    vc.arrayBookReport = arrayBookReport;
    vc.endDate = self.textFieldDateEnd.text;
    vc.startDate = self.textFieldDateStart.text;
    vc.view.frame = CGRectMake(0, 0, self.viewDay.frame.size.width, self.viewDay.frame.size.height);
    [self.viewDay addSubview:vc.view];
    [self addChildViewController:vc];
}

- (void)addSubViewTable : (NSArray *)arrayBookReport {
    for (UIView *subView in self.viewTable.subviews) {
        [subView removeFromSuperview];
    }
    
    ListBookRoomViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListBookRoomViewController"];
    vc.arrayBookRoom = arrayBookReport;
    vc.view.frame = CGRectMake(0, 0, self.viewTable.frame.size.width, self.viewTable.frame.size.height);
    [self.viewTable addSubview:vc.view];
    [self addChildViewController:vc];
}

#pragma mark CallAPI

- (void)getListHome {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"OPT":@""
                            };
    
    [CallAPI callApiService:@"room/get_mylist_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayMyHomes = dictData[@"INFO"];
        if (self->arrayMyHomes.count > 0) {
            self->dictHome = self->arrayMyHomes[0];
            self.labelHomeName.text = self->dictHome[@"NAME"];
            [self getListBookRoom];
        }
    }];
}

- (void)getListBookRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOKROOM":@"",
                            @"ROOM_NAME":dictHome[@"NAME"],
                            @"BOOKING_NAME":@"",
                            @"START_TIME":self.textFieldDateStart.text,
                            @"END_TIME":self.textFieldDateEnd.text,
                            @"BILLING_STATUS":@"",
                            @"BOOKING_STATUS":@"",
                            @"GENLINK":dictHome[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"book/list_bookroom" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayBookRoom = dictData[@"INFO"];
        if ([dictData[@"ERROR"] isEqualToString:@"0000"]) {
            [self addSubViewCalendar:arrayBookRoom];
            [self addSubViewTable:arrayBookRoom];
            [self addSubViewListDay:arrayBookRoom];
        }else{
            [self addSubViewTable:@[]];
            [self addSubViewCalendar:@[]];
            [self addSubViewListDay:@[]];
        }
        //Hien thi chi tiet lich dat phong
    }];
}

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kMyHome"]) {
        dictHome = notif.object;
        if (dictHome.allKeys.count == 0) {
            
        }else{
            self.labelHomeName.text = dictHome[@"NAME"];
            [self search:nil];
        }
    }else if ([notif.name isEqualToString:kCreateRoomSuccess]) {
        [self getListHome];
    }else if ([notif.name isEqualToString:kUpdateRoomInforProperty]) {
        [self getListHome];
    }else if ([notif.name isEqualToString:kUpdateBookingRoomStatus]) {
        [self getListBookRoom];
    }
}

@end
