//
//  ListCustomerTableViewCell.h
//  MyHome
//
//  Created by Macbook on 9/17/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListCustomerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelCMT;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneMunber;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelAdress;
@property (weak, nonatomic) IBOutlet UILabel *labelDoB;
@property (weak, nonatomic) IBOutlet UILabel *labelTP;

@end

NS_ASSUME_NONNULL_END
