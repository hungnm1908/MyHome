//
//  BaseTabbarViewController.m
//  MyHome
//
//  Created by Macbook on 11/13/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "BaseTabbarViewController.h"
#import "NotificationViewController.h"
#import "UIBarButtonItem+Badge.h"

@interface BaseTabbarViewController ()

@end

@implementation BaseTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = RGB_COLOR(75, 109, 179);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.buttonThongBao  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.buttonThongBao setBackgroundImage:[UIImage imageNamed:@"icon_thong_bao"] forState:UIControlStateNormal];
    self.buttonThongBao.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.buttonThongBao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonThongBao.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.buttonThongBao addTarget:self action:@selector(showNotification) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonThongBao = [[UIBarButtonItem alloc] initWithCustomView:self.buttonThongBao];
    self.navigationItem.leftBarButtonItem = leftBarButtonThongBao;
    
    [self getListNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListNotification) name:kUpdateNotification object:nil];
}

- (void)showNotification {
    NotificationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getListNotification {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"PIPAGE":@"1",
                            @"NUMOFPAGE":@"10"
                            };
    
    [CallAPI callApiService:@"user/get_list_notifi" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *array = dictData[@"INFO"];
        int number = 0;
        if (array.count > 0) {
            number = [array[0][@"TONG"] intValue];
        }
        self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%d",number];
        [UIApplication sharedApplication].applicationIconBadgeNumber = number;
    }];
}

@end
