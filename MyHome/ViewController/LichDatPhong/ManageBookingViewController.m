//
//  ManageBookingViewController.m
//  MyHome
//
//  Created by Macbook on 10/24/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ManageBookingViewController.h"
#import "AdminManageBookingViewController.h"
#import "ManagerMyHomeBookingViewController.h"
#import "CTVManageBookingViewController.h"
#import "ListBookOrtherViewController.h"

@interface ManageBookingViewController ()

@end

@implementation ManageBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    
    switch (userType) {
        case 0://admin
        {
            self.btnBookingRoomChuNha.enabled = NO;
            self.btnBookingRoomChuNha.tintColor = [UIColor clearColor];
            AdminManageBookingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminManageBookingViewController"];
            vc.view.frame = self.view.frame;
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
            break;
            
        case 1://chủ nhà
        {
            self.btnBookingRoomChuNha.enabled = YES;
            self.btnBookingRoomChuNha.tintColor = [UIColor whiteColor];
            
            ManagerMyHomeBookingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ManagerMyHomeBookingViewController"];
            vc.view.frame = self.view.frame;
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
            break;
            
        case 2://CTV
        {
            self.btnBookingRoomChuNha.enabled = NO;
            self.btnBookingRoomChuNha.tintColor = [UIColor clearColor];
            
            CTVManageBookingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CTVManageBookingViewController"];
            vc.view.frame = self.view.frame;
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
            break;
            
        case 3://gold
        {
            self.btnBookingRoomChuNha.enabled = NO;
            self.btnBookingRoomChuNha.tintColor = [UIColor clearColor];
        }
            break;
            
        case 4://dọn dẹp
        {
            self.btnBookingRoomChuNha.enabled = NO;
            self.btnBookingRoomChuNha.tintColor = [UIColor clearColor];
            
            CTVManageBookingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CTVManageBookingViewController"];
            vc.view.frame = self.view.frame;
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
            break;
            
        case 5://dọn dẹp
        {
            self.btnBookingRoomChuNha.enabled = NO;
            self.btnBookingRoomChuNha.tintColor = [UIColor clearColor];
            
            CTVManageBookingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CTVManageBookingViewController"];
            vc.view.frame = self.view.frame;
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }
            break;
            
        default:
        {
            self.btnBookingRoomChuNha.enabled = NO;
            self.btnBookingRoomChuNha.tintColor = [UIColor clearColor];
        }
            break;
    }
}

- (IBAction)showBookingChuNha:(id)sender {
    ListBookOrtherViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListBookOrtherViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
