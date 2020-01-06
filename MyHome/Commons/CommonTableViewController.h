//
//  CommonTableViewController.h
//  NoiBaiAirPort
//
//  Created by HuCuBi on 6/7/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum : NSUInteger {
    kProvince = 0,
    kDistrict = 1,
    kSchool = 2,
} TypeView;

@interface CommonTableViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property NSArray *arrayItem;
@property TypeView typeView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSearchHeight;


@end
