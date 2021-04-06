//
//  AddCleanImageViewController.h
//  MyHome
//
//  Created by HuCuBi on 6/29/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AddCleanImageTableViewCell.h"
#import "AddImageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCleanImageViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,AddCleanImageTableViewCellDelegate>

@property NSString *idDictBookClean;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
