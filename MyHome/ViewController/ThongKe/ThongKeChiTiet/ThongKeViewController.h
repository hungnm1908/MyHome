//
//  ThongKeViewController.h
//  MyHome
//
//  Created by Macbook on 8/15/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ThongKeTableViewCell.h"
#import "ThongKeSection.h"
#import "CKCalendarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThongKeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTotal;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewSearch;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldNameHome;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldNameBooker;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFromDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldToDate;

@end

NS_ASSUME_NONNULL_END
