//
//  NotificationViewController.h
//  HappyLuckySale
//
//  Created by Macbook on 6/24/19.
//  Copyright © 2019 HuCuBi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
