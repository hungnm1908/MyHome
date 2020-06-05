//
//  AdminCalendarBookingRoomViewController.h
//  MyHome
//
//  Created by Macbook on 10/24/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdminCalendarBookingRoomViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelHomeName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldStartDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEndDate;
@property (weak, nonatomic) IBOutlet UIView *viewCalendar;

@end

NS_ASSUME_NONNULL_END
