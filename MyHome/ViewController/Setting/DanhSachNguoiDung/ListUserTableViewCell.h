//
//  ListUserTableViewCell.h
//  MyHome
//
//  Created by Macbook on 10/26/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelFullname;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserType;
@property (weak, nonatomic) IBOutlet UILabel *labelMobile;
@property (weak, nonatomic) IBOutlet UILabel *labelDoB;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@end

NS_ASSUME_NONNULL_END
