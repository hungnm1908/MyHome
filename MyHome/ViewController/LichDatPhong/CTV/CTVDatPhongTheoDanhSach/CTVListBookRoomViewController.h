//
//  CTVListBookRoomViewController.h
//  MyHome
//
//  Created by Macbook on 11/13/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTVListBookRoomViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property NSArray *arrayBookRoom;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
