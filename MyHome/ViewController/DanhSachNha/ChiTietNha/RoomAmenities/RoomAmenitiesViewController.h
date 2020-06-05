//
//  RoomAmenitiesViewController.h
//  MyHome
//
//  Created by Macbook on 9/20/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomAmenitiesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property NSDictionary *dictRoom;
@property BOOL isCreate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
