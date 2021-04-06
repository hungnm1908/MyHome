//
//  ImageCleanHomeViewController.h
//  MyHome
//
//  Created by HuCuBi on 6/27/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ELCImagePickerController.h"
#import "ImageCleanTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageCleanHomeViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,ImageCleanTableViewCellDelegate>

@property NSString *idDictBookClean;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
