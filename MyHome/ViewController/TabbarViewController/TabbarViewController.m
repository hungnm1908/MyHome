//
//  TabbarViewController.m
//  MyHome
//
//  Created by HuCuBi on 5/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "TabbarViewController.h"
#import "Utils.h"
#import "CallAPI.h"
#import "BannerViewController.h"
#import "AppDelegate.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTabbar:self :self.tabbar];
    
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsLogin];
    
    if (isLogin) {
        [Utils checkAppVersion];
        [[self appDelegate] registerForRemoteNotifications];
    }
    
    [Utils checkUpdate];
}

- (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)configTabbar : (UITabBarController *) tabbarController : (UITabBar *) tabar {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsLogin];
    
    if (isLogin) {
        NSMutableArray *arrayTabbar = [NSMutableArray array];
        for (NSDictionary *dict in [self settupFunction]) {
            [arrayTabbar addObject:dict[@"NavigationController"]];
        }
        [tabbarController setViewControllers:arrayTabbar];
        
        
        for (int i=0; i<arrayTabbar.count; i++) {
            NSDictionary *dict = [[self settupFunction] objectAtIndex:i];
            UITabBarItem *tabBarItem = [tabbarController.tabBar.items objectAtIndex:i];
            
            UIImage *icontab = [[UIImage imageNamed:dict[@"ImageUnSelect"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *icontabSelect = [[UIImage imageNamed:dict[@"ImageSelect"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [tabBarItem setImage:icontab];
            [tabBarItem setSelectedImage:icontabSelect];
            
            [tabBarItem setTitle:dict[@"Title"]];
            [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : RGB_COLOR(84, 125, 190) } forState:UIControlStateSelected];
        }
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
        int userType = [userInfo[@"USER_TYPE"] intValue];
        
        switch (userType) {
            case 0://admin
            {
                tabbarController.selectedIndex = 1;
            }
                break;
                
            case 1://chủ nhà
            {
                tabbarController.selectedIndex = 2;
            }
                break;
                
            case 2://CTV
            {
                tabbarController.selectedIndex = 0;
            }
                break;
                
            case 3://gold
            {
                
            }
                break;
                
            case 4://ql dọn dẹp
            {
                tabbarController.selectedIndex = 2;
            }
                break;
                
            case 5://check-in
            {
                tabbarController.selectedIndex = 2;
            }
                break;
                
            default:
            {
                tabbarController.selectedIndex = 0;
            }
                break;
        }
        
        self.delegate = self;
        
        //    BOOL isClickBanner = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsClickBanner];
        //    if (!isClickBanner) {
        BannerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BannerViewController"];
        vc.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
        //    }
    }else{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UINavigationController *vcSearch = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"NewHomeViewController"]];
        
        NSDictionary *dictSearch = @{@"NavigationController":vcSearch,
                                     @"Title":@"Tìm kiếm",
                                     @"ImageSelect":@"icon_search_blue",
                                     @"ImageUnSelect":@"icon_search"
        };
        
        UINavigationController *vcLogin = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
        
        NSDictionary *dictLogin = @{@"NavigationController":vcLogin,
                                    @"Title":@"Đăng nhập",
                                    @"ImageSelect":@"tabbar_select_3",
                                    @"ImageUnSelect":@"tabbar_3"
        };
        
        NSArray *arrayVC = @[dictSearch, dictLogin];
        
        NSMutableArray *arrayTabbar = [NSMutableArray array];
        for (NSDictionary *dict in arrayVC) {
            [arrayTabbar addObject:dict[@"NavigationController"]];
        }
        [tabbarController setViewControllers:arrayTabbar];
        
        
        for (int i=0; i<arrayTabbar.count; i++) {
            NSDictionary *dict = [arrayVC objectAtIndex:i];
            UITabBarItem *tabBarItem = [tabbarController.tabBar.items objectAtIndex:i];
            
            UIImage *icontab = [[UIImage imageNamed:dict[@"ImageUnSelect"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *icontabSelect = [[UIImage imageNamed:dict[@"ImageSelect"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [tabBarItem setImage:icontab];
            [tabBarItem setSelectedImage:icontabSelect];
            
            [tabBarItem setTitle:dict[@"Title"]];
            [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : RGB_COLOR(84, 125, 190) } forState:UIControlStateSelected];
        }
    }
}

- (NSArray *) settupFunction {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    UINavigationController *vcSearch = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"]];
    
    UINavigationController *vcSearch = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"NewHomeViewController"]];
    
    UINavigationController *vcBooking = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"ManageBookingViewController"]];
    
    //    UINavigationController *vcListHome = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"ListMyRoomViewController"]];
    
    UINavigationController *vcListHome = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"ManageMyHomeViewController"]];
    
    UINavigationController *vcReport = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"DashBoardViewController"]];
    
    UINavigationController *vcService = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"ManageServiceViewController"]];
    
    UINavigationController *vcSetting = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"SettingViewController"]];
    
    UINavigationController *vcListClean = [[UINavigationController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"ManageQLDonDepViewController"]];
    
    NSDictionary *dictSearch = @{@"NavigationController":vcSearch,
                                 @"Title":@"Tìm kiếm",
                                 @"ImageSelect":@"icon_search_blue",
                                 @"ImageUnSelect":@"icon_search"
    };
    
    NSDictionary *dictBooking = @{@"NavigationController":vcBooking,
                                  @"Title":@"Lịch nhà",
                                  @"ImageSelect":@"tabbar_select_1",
                                  @"ImageUnSelect":@"tabbar_1"
    };
    
    NSDictionary *dictListHome = @{@"NavigationController":vcListHome,
                                   @"Title":@"MyHome",
                                   @"ImageSelect":@"tabbar_select_0",
                                   @"ImageUnSelect":@"tabbar_0"
    };
    
    NSDictionary *dictReport = @{@"NavigationController":vcReport,
                                 @"Title":@"Thống kê",
                                 @"ImageSelect":@"tabbar_select_2",
                                 @"ImageUnSelect":@"tabbar_2"
    };
    
    NSDictionary *dictService = @{@"NavigationController":vcService,
                                  @"Title":@"Dịch vụ",
                                  @"ImageSelect":@"tabbar_select_2",
                                  @"ImageUnSelect":@"tabbar_2"
    };
    
    NSDictionary *dictSetting = @{@"NavigationController":vcSetting,
                                  @"Title":@"Cài đặt",
                                  @"ImageSelect":@"tabbar_select_3",
                                  @"ImageUnSelect":@"tabbar_3"
    };
    
    NSDictionary *dictClean = @{@"NavigationController":vcListClean,
                                @"Title":@"Quản lý dọn dẹp",
                                @"ImageSelect":@"tabbar_select_0",
                                @"ImageUnSelect":@"tabbar_0"
    };
    
    NSArray *arrayTabbar;
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    
    switch (userType) {
        case 0://admin
        {
            arrayTabbar = @[dictSearch, dictBooking, dictListHome, dictService, dictSetting];
        }
            break;
            
        case 1://chủ nhà
        {
            arrayTabbar = @[dictSearch, dictBooking, dictListHome, dictService, dictSetting];
        }
            break;
            
        case 2://CTV
        {
            arrayTabbar = @[dictSearch, dictBooking, dictService, dictSetting];
        }
            break;
            
        case 3://gold
        {
            arrayTabbar = @[dictSearch, dictBooking, dictListHome, dictService, dictSetting];
        }
            break;
            
        case 4://ql dọn dẹp
        {
            arrayTabbar = @[dictSearch, dictBooking, dictClean, dictService, dictSetting];
        }
            break;
            
        case 5:// dọn dẹp
        {
            arrayTabbar = @[dictSearch, dictBooking, dictClean, dictService, dictSetting];
        }
            break;
            
        default:
        {
            arrayTabbar = @[dictSearch, dictBooking, dictListHome, dictService, dictSetting];
        }
            break;
    }
    
    return arrayTabbar;
}

@end
