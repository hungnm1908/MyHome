//
//  SettupDiscountViewController.h
//  MyHome
//
//  Created by Macbook on 2/19/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettupDiscountViewController : BaseViewController

@property NSDictionary *dictHome;

@property (weak, nonatomic) IBOutlet UITextField *textFieldStartDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEndDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPercent;
@property (weak, nonatomic) IBOutlet UISlider *sliderPercent;

@end

NS_ASSUME_NONNULL_END
