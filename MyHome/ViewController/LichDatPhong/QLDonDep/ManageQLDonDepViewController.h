//
//  ManageQLDonDepViewController.h
//  MyHome
//
//  Created by Macbook on 2/11/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabbarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManageQLDonDepViewController : BaseTabbarViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewLichDonDep;
@property (weak, nonatomic) IBOutlet UIView *viewBookDopDep;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
