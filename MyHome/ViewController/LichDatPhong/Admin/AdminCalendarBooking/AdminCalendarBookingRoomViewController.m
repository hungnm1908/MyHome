//
//  AdminCalendarBookingRoomViewController.m
//  MyHome
//
//  Created by Macbook on 10/24/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "AdminCalendarBookingRoomViewController.h"
#import "CommonTableViewController.h"
#import "ListBookCalendarViewController.h"

@interface AdminCalendarBookingRoomViewController ()

@end

@implementation AdminCalendarBookingRoomViewController {
    NSDictionary *dictHome;
    NSArray *arrayMyHomes;
    BOOL isSettup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textFieldStartDate.text = [Utils getDateFromDate:[Utils getFirstDayOfThisMonth]];
    self.textFieldEndDate.text = [Utils getDateFromDate:[Utils getLastDayOfMonth:5]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kMyHome" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!isSettup) {
        isSettup = YES;

        [self getListHome];
    }
}

- (IBAction)selectStartDate:(id)sender {
    [self.textFieldStartDate becomeFirstResponder];
}

- (IBAction)selectEndDate:(id)sender {
    [self.textFieldEndDate becomeFirstResponder];
}

- (IBAction)selectHome:(id)sender {
    if (arrayMyHomes) {
        CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
        vc.arrayItem = arrayMyHomes;
        vc.typeView = kMyHome;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self getListHome];
    }
}

- (IBAction)search:(id)sender {
    [self.textFieldStartDate resignFirstResponder];
    [self.textFieldEndDate resignFirstResponder];
    if ([self isEnoughInfo]) {
        [self getListBookRoom];
    }
}

- (BOOL)isEnoughInfo {
    BOOL isOK = YES;
    
    if (![Utils checkFromDate:self.textFieldStartDate.text toDate:self.textFieldEndDate.text view:self]) {
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
    vc.startDate = [Utils getDateFromStringDate:self.textFieldStartDate.text];
    vc.endDate = [Utils getDateFromStringDate:self.textFieldEndDate.text];
    vc.view.frame = CGRectMake(0, 0, self.viewCalendar.frame.size.width, self.viewCalendar.frame.size.height);
    [self.viewCalendar addSubview:vc.view];
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
                            @"START_TIME":self.textFieldStartDate.text,
                            @"END_TIME":self.textFieldEndDate.text,
                            @"BILLING_STATUS":@"",
                            @"BOOKING_STATUS":@"",
                            @"GENLINK":dictHome[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"book/list_bookroom" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayBookRoom = dictData[@"INFO"];
        if ([dictData[@"ERROR"] isEqualToString:@"0000"]) {
            [self addSubViewCalendar:arrayBookRoom];
        }else{
            [self addSubViewCalendar:@[]];
        }
    }];
}

- (void)reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kMyHome"]) {
        dictHome = notif.object;
        if (dictHome.allKeys.count == 0) {
            
        }else{
            self.labelHomeName.text = dictHome[@"NAME"];
            [self search:nil];
        }
    }
}

@end
