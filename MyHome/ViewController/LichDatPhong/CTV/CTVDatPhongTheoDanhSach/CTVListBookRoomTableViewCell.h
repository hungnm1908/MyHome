//
//  CTVListBookRoomTableViewCell.h
//  MyHome
//
//  Created by Macbook on 11/13/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTVListBookRoomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelNameRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelNameGuest;
@property (weak, nonatomic) IBOutlet UILabel *labelDateBook;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeBook;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusBilling;
@property (weak, nonatomic) IBOutlet UIImageView *iconLock;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@property (weak, nonatomic) IBOutlet UIView *viewThanhToan;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewThanhToan;
@property (weak, nonatomic) IBOutlet UIButton *btnThanhToan;


@end

NS_ASSUME_NONNULL_END
