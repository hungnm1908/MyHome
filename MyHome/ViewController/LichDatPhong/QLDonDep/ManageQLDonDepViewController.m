//
//  ManageQLDonDepViewController.m
//  MyHome
//
//  Created by Macbook on 2/11/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "ManageQLDonDepViewController.h"
#import "AdminListBookingCleanRoomViewController.h"
#import "AdminCalendarBookingRoomViewController.h"

@interface ManageQLDonDepViewController ()

@end

@implementation ManageQLDonDepViewController {
    BOOL isSettup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isSettup) {
        isSettup = YES;
        
        [self settupView];
    }
}

- (void)settupView {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    if (userType == 5) {
        AdminListBookingCleanRoomViewController *vcBookClean = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminListBookingCleanRoomViewController"];
        vcBookClean.view.frame = CGRectMake(0, 0, self.viewLichDonDep.frame.size.width, self.viewLichDonDep.frame.size.height);
        [self.viewLichDonDep addSubview:vcBookClean.view];
        [self addChildViewController:vcBookClean];
        
        [self.segmentedControl removeSegmentAtIndex:1 animated:YES];
        self.scrollView.scrollEnabled = NO;
    }else{
        AdminListBookingCleanRoomViewController *vcBookClean = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminListBookingCleanRoomViewController"];
        vcBookClean.view.frame = CGRectMake(0, 0, self.viewLichDonDep.frame.size.width, self.viewLichDonDep.frame.size.height);
        [self.viewLichDonDep addSubview:vcBookClean.view];
        [self addChildViewController:vcBookClean];
        
        AdminCalendarBookingRoomViewController *vcBookCalendar = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminCalendarBookingRoomViewController"];
        vcBookCalendar.view.frame = CGRectMake(0, 0, self.viewBookDopDep.frame.size.width, self.viewBookDopDep.frame.size.height);
        [self.viewBookDopDep addSubview:vcBookCalendar.view];
        [self addChildViewController:vcBookCalendar];
    }
}

- (IBAction)changeViewReport:(UISegmentedControl *)sender {
    CGPoint point = CGPointMake(self.scrollView.bounds.size.width*sender.selectedSegmentIndex, 0);
    [self.scrollView setContentOffset:point animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = (int)scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    self.segmentedControl.selectedSegmentIndex = currentPage;
}

@end
