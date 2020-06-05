//
//  ManageMyHomeViewController.h
//  MyHome
//
//  Created by HuCuBi on 3/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabbarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManageMyHomeViewController : BaseTabbarViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *controllView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAddRoom;

@end

NS_ASSUME_NONNULL_END
