//
//  HistoryPaymentRentCarViewController.h
//  MyHome
//
//  Created by HuCuBi on 4/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryPaymentRentCarViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelNote;

@end

NS_ASSUME_NONNULL_END
