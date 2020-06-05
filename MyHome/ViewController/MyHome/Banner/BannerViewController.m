//
//  BannerViewController.m
//  MyHome
//
//  Created by HuCuBi on 4/29/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "BannerViewController.h"
#import "RentCarViewController.h"

@interface BannerViewController ()

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)closeView:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)showRentcar:(id)sender {
    RentCarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RentCarViewController"];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.isPresentView = YES;
    [self presentViewController:vc animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsClickBanner];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
