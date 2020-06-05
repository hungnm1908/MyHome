//
//  ManageRentCarViewController.m
//  MyHome
//
//  Created by HuCuBi on 4/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "ManageRentCarViewController.h"
#import "RentCarViewController.h"
#import "ListBookCarViewController.h"
#import "HistoryPaymentRentCarViewController.h"
#import "ListBookCarPostpayViewController.h"

@interface ManageRentCarViewController ()

@end

@implementation ManageRentCarViewController {
    BOOL isSettup;
    UISegmentedControl *segmentedControl;
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
}

- (IBAction)showHistoryPayment:(id)sender {
    HistoryPaymentRentCarViewController *vcHistoryPaymentRentCar = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryPaymentRentCarViewController"];
    vcHistoryPaymentRentCar.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcHistoryPaymentRentCar animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = (int)scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    segmentedControl.selectedSegmentIndex = currentPage;
}

- (void)settupView {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    
    if (userType == 0) {
        NSArray *itemArray = [NSArray arrayWithObjects: @"Đặt xe", @"Trả sau", @"Duyệt đơn", nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
//        segmentedControl.frame = CGRectMake(35, 200, 250, 50);
        [segmentedControl addTarget:self action:@selector(changeView:) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segmentedControl;
    }else{
        NSArray *itemArray = [NSArray arrayWithObjects: @"Đặt xe", @"Trả trước", @"Trả sau", nil];
                segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        //        segmentedControl.frame = CGRectMake(35, 200, 250, 50);
                [segmentedControl addTarget:self action:@selector(changeView:) forControlEvents: UIControlEventValueChanged];
                segmentedControl.selectedSegmentIndex = 0;
                self.navigationItem.titleView = segmentedControl;
    }
    
    RentCarViewController *vcRentCar = [self.storyboard instantiateViewControllerWithIdentifier:@"RentCarViewController"];
    vcRentCar.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:vcRentCar.view];
    [self addChildViewController:vcRentCar];
    
    ListBookCarViewController *vcListRentCar = [self.storyboard instantiateViewControllerWithIdentifier:@"ListBookCarViewController"];
    vcListRentCar.view.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:vcListRentCar.view];
    [self addChildViewController:vcListRentCar];
    
    ListBookCarPostpayViewController *vcListPostpay = [self.storyboard instantiateViewControllerWithIdentifier:@"ListBookCarPostpayViewController"];
    vcListPostpay.view.frame = CGRectMake(self.scrollView.frame.size.width*2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:vcListPostpay.view];
    [self addChildViewController:vcListPostpay];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width*3, self.scrollView.bounds.size.height)];
}

@end
