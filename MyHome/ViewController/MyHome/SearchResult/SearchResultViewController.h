//
//  SearchResultViewController.h
//  MyHome
//
//  Created by Macbook on 8/7/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MARKRangeSlider.h"
#import "CKCalendarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,CKCalendarDelegate>

@property NSDictionary *paramSearch;
@property NSArray *arrayHouses;
@property NSArray *arrayBanner;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldTP;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNameSearch;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNumberCustomer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFromDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldToDate;
@property (weak, nonatomic) IBOutlet UILabel *labelMinCost;
@property (weak, nonatomic) IBOutlet UILabel *labelMaxCost;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *rangeSlider;

@end

NS_ASSUME_NONNULL_END
