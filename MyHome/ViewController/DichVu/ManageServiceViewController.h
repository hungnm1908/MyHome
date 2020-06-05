//
//  ManageServiceViewController.h
//  MyHome
//
//  Created by HuCuBi on 3/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabbarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManageServiceViewController : BaseTabbarViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
