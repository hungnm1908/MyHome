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
    kUserType = 2,
    kMyHome = 3,
    kVnBank = 4,
    kBuilding = 5,
    kBanner = 6,
    kJourney = 7,
    kRentCar = 8
} TypeView;

@interface CommonTableViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property NSArray *arrayItem;
@property TypeView typeView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;



@end
