//
//  CTVManageBookingViewController.h
//  MyHome
//
//  Created by Macbook on 11/13/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTVManageBookingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelHomeName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDateStart;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDateEnd;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewCalendar;
@property (weak, nonatomic) IBOutlet UIView *viewDay;
@property (weak, nonatomic) IBOutlet UIView *viewTable;

@end

NS_ASSUME_NONNULL_END
