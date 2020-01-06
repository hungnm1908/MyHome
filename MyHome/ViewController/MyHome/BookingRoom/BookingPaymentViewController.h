//
//  BookingPaymentViewController.h
//  MyHome
//
//  Created by Macbook on 9/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookingPaymentViewController : BaseViewController

@property NSString *totalPrice;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;

@end

NS_ASSUME_NONNULL_END
