//
//  DetailCustomerViewController.h
//  MyHome
//
//  Created by Macbook on 10/8/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailCustomerViewController : BaseViewController

@property NSDictionary *dictCustomer;
@property BOOL isCreate;

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldName;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldCMT;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldPhoneNumber;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet TextFiledChoseDate *textFieldDoB;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldTP;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldAddress;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldSTK;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldTenTK;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldTenNganHang;

@property (weak, nonatomic) IBOutlet MyButton *btnUpdate;


@end

NS_ASSUME_NONNULL_END
