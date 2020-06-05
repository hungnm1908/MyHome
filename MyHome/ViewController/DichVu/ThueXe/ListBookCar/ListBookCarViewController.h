//
//  ListBookCarViewController.h
//  MyHome
//
//  Created by HuCuBi on 4/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListBookCarViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelNotice;


@end

NS_ASSUME_NONNULL_END
