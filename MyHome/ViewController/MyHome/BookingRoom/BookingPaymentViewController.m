//
//  BookingPaymentViewController.m
//  MyHome
//
//  Created by Macbook on 9/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "BookingPaymentViewController.h"

@interface BookingPaymentViewController ()

@end

@implementation BookingPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.labelTotalPrice.text = self.totalPrice;
}

- (IBAction)completeBooking:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goback {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
