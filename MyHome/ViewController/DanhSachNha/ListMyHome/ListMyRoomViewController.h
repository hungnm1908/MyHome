//
//  ListMyRoomViewController.h
//  MyHome
//
//  Created by Macbook on 8/15/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <CCDropDownMenus/CCDropDownMenus.h>


NS_ASSUME_NONNULL_BEGIN

@interface ListMyRoomViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CCDropDownMenuDelegate>

@property UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewStatusRoom;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCreate;

@end

NS_ASSUME_NONNULL_END
