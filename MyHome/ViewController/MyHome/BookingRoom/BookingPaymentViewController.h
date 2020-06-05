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

@property long long totalPrice;
@property NSString *content;
@property BOOL isPaymentClean;
@property NSDictionary *dictBookClean;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelNote;
@property (weak, nonatomic) IBOutlet UILabel *labelSTK;
@property (weak, nonatomic) IBOutlet UIView *viewChangeKindOfPay;

@end

NS_ASSUME_NONNULL_END
