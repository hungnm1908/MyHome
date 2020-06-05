//
//  AdminListBookingRoomViewController.h
//  MyHome
//
//  Created by Macbook on 10/24/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <CCDropDownMenus/CCDropDownMenus.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdminListBookingRoomViewController : UIViewController<CCDropDownMenuDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labelHomeName;
@property (weak, nonatomic) IBOutlet UIView *viewStatusBilling;
@property (weak, nonatomic) IBOutlet UIView *viewStatusBooking;
@property (weak, nonatomic) IBOutlet UITextField *textFieldStartDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEndDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
