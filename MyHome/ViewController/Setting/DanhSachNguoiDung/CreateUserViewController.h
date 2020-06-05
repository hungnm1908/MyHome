//
//  CreateUserViewController.h
//  MyHome
//
//  Created by Macbook on 11/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateUserViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldLoaiNguoiDung;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldMobile;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldFullName;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldAddress;


@end

NS_ASSUME_NONNULL_END
