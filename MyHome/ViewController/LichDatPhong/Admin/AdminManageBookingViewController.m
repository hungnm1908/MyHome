//
//  AdminManageBookingViewController.m
//  MyHome
//
//  Created by Macbook on 10/24/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "AdminManageBookingViewController.h"
#import "AdminListBookingRoomViewController.h"
#import "AdminListBookingCleanRoomViewController.h"
#import "AdminCalendarBookingRoomViewController.h"

@interface AdminManageBookingViewController ()

@end

@implementation AdminManageBookingViewController {
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
    AdminListBookingRoomViewController *vcBookRoom = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminListBookingRoomViewController"];
    vcBookRoom.view.frame = CGRectMake(0, 0, self.viewLichDatPhong.frame.size.width, self.viewLichDatPhong.frame.size.height);
    [self.viewLichDatPhong addSubview:vcBookRoom.view];
    [self addChildViewController:vcBookRoom];
    
    AdminListBookingCleanRoomViewController *vcBookClean = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminListBookingCleanRoomViewController"];
    vcBookClean.view.frame = CGRectMake(0, 0, self.viewLichDonPhong.frame.size.width, self.viewLichDonPhong.frame.size.height);
    [self.viewLichDonPhong addSubview:vcBookClean.view];
    [self addChildViewController:vcBookClean];
    
    AdminCalendarBookingRoomViewController *vcBookCalendar = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminCalendarBookingRoomViewController"];
    vcBookCalendar.view.frame = CGRectMake(0, 0, self.viewCalendar.frame.size.width, self.viewCalendar.frame.size.height);
    [self.viewCalendar addSubview:vcBookCalendar.view];
    [self addChildViewController:vcBookCalendar];
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
