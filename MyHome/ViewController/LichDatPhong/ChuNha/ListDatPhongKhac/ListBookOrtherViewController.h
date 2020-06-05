//
//  ListBookOrtherViewController.h
//  MyHome
//
//  Created by Macbook on 11/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListBookOrtherViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelHomeName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDateStart;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDateEnd;
@property (weak, nonatomic) IBOutlet UILabel *labelNotice;

@end

NS_ASSUME_NONNULL_END
