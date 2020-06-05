//
//  BookCleanServiceViewController.h
//  MyHome
//
//  Created by HuCuBi on 5/16/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookCleanServiceViewController : BaseViewController

@property NSDictionary *dictParam;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldQuantity;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDateTime;
@property (weak, nonatomic) IBOutlet UITextView *textViewNote;

@end

NS_ASSUME_NONNULL_END
