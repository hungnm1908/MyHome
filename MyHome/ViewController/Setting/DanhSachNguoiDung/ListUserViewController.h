//
//  ListUserViewController.h
//  MyHome
//
//  Created by Macbook on 10/26/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <CCDropDownMenus/CCDropDownMenus.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListUserViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, CCDropDownMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MyCustomView *viewUserType;
@property (weak, nonatomic) IBOutlet MyCustomView *viewUserStatus;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldFullName;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldPhoneNumber;


@end

NS_ASSUME_NONNULL_END
