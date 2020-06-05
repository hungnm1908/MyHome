//
//  SettingViewController.h
//  MyHome
//
//  Created by HuCuBi on 8/4/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BaseTabbarViewController.h"

@interface SettingViewController : BaseTabbarViewController<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelVersion;

@end
