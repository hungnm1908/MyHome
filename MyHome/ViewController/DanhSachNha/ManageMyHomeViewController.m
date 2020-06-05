//
//  ManageMyHomeViewController.m
//  MyHome
//
//  Created by HuCuBi on 3/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "ManageMyHomeViewController.h"
#import "ListMyRoomViewController.h"
#import "NewReportViewController.h"
#import "MyRoomDetailViewController.h"
#import "DashBoardViewController.h"

@interface ManageMyHomeViewController ()

@end

@implementation ManageMyHomeViewController {
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

- (IBAction)changeView:(UISegmentedControl *)sender {
    CGPoint point = CGPointMake(self.scrollView.bounds.size.width*sender.selectedSegmentIndex, 0);
    [self.scrollView setContentOffset:point animated:YES];
    [self hideBtnCreateRoom:(int)sender.selectedSegmentIndex];
}

- (IBAction)createRoom:(id)sender {
    MyRoomDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRoomDetailViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isCreate = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = (int)scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    self.controllView.selectedSegmentIndex = currentPage;
    [self hideBtnCreateRoom:currentPage];
}

- (void)hideBtnCreateRoom : (int)index {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    if (userType == 1) {
        if (index == 0) {
            self.btnAddRoom.tintColor = UIColor.clearColor;
            self.btnAddRoom.enabled = NO;
        }else{
            self.btnAddRoom.tintColor = UIColor.whiteColor;
            self.btnAddRoom.enabled = YES;
        }
    }else{
        self.btnAddRoom.tintColor = UIColor.clearColor;
        self.btnAddRoom.enabled = NO;
    }
}

- (void)settupView {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    
    switch (userType) {
        case 0://admin
        {
            DashBoardViewController *vcInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"DashBoardViewController"];
            vcInfo.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            [self.scrollView addSubview:vcInfo.view];
            [self addChildViewController:vcInfo];
        }
            break;
            
        case 1://chủ nhà
        {
            NewReportViewController *vcInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"NewReportViewController"];
            vcInfo.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            [self.scrollView addSubview:vcInfo.view];
            [self addChildViewController:vcInfo];
        }
            break;
            
        case 2://CTV
        {
            
        }
            break;
            
        case 3://gold
        {
            
        }
            break;
            
        case 4://quản lý dọn dẹp
        {
            
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
    
    ListMyRoomViewController *vcMoney = [self.storyboard instantiateViewControllerWithIdentifier:@"ListMyRoomViewController"];
    vcMoney.view.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:vcMoney.view];
    [self addChildViewController:vcMoney];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width*2, self.scrollView.bounds.size.height)];
}

@end
