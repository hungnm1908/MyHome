//
//  ListBookDayViewController.h
//  MyHome
//
//  Created by Macbook on 10/3/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListBookDayViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property NSString *startDate;
@property NSString *endDate;
@property NSArray *arrayBookReport;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
