//
//  AdminManageBookingViewController.h
//  MyHome
//
//  Created by Macbook on 10/24/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdminManageBookingViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewLichDatPhong;
@property (weak, nonatomic) IBOutlet UIView *viewLichDonPhong;
@property (weak, nonatomic) IBOutlet UIView *viewCalendar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

NS_ASSUME_NONNULL_END
