//
//  NewHomeViewController.h
//  MyHome
//
//  Created by Macbook on 3/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstHomeTableViewCell.h"
#import "SecondHomeTableViewCell.h"
#import "ThirdHomeTableViewCell.h"
#import "FourHomeTableViewCell.h"
#import "Utils.h"
#import "CallAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewHomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SecondHomeTableViewCellDelegate>
@property UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
