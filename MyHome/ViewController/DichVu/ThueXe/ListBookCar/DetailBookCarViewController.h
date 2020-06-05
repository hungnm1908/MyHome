//
//  DetailBookCarViewController.h
//  MyHome
//
//  Created by HuCuBi on 4/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailBookCarViewController : BaseViewController

@property NSDictionary *dictBookCar;

@property (weak, nonatomic) IBOutlet UILabel *labelCodeBooking;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelHanhTrinh;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelNameCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail;

@end

NS_ASSUME_NONNULL_END
