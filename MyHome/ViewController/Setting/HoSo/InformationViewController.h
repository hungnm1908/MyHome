//
//  InformationViewController.h
//  MyHome
//
//  Created by Macbook on 8/19/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface InformationViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property NSString *userID;
@property BOOL isEdit;

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUser;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTypeUser;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDoB;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTP;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UISegmentedControl *controlStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imageDropDown;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectUserType;

@property (weak, nonatomic) IBOutlet UITextField *textFieldSoTaiKhoan;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTenTaiKhoan;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTenNganHang;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTenChiNhanh;

@property (weak, nonatomic) IBOutlet MyButton *btnUpdate;
@property (weak, nonatomic) IBOutlet MyButton *btnChangePassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBtnChangePassword;

@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnZall;


@end

NS_ASSUME_NONNULL_END
