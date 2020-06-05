//
//  MyRoomDetailViewController.h
//  MyHome
//
//  Created by Macbook on 8/28/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRoomDetailViewController : BaseViewController<UIScrollViewDelegate>

@property BOOL isCreate;
@property NSDictionary *dictRoom;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *controllView;

@end

NS_ASSUME_NONNULL_END
