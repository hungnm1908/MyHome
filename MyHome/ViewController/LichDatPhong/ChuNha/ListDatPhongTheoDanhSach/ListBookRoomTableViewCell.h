//
//  ListBookRoomTableViewCell.h
//  MyHome
//
//  Created by Macbook on 8/15/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListBookRoomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelNameRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelNameGuest;
@property (weak, nonatomic) IBOutlet UILabel *labelDateBook;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeBook;
@property (weak, nonatomic) IBOutlet UILabel *labelTrangThaiNha;
@property (weak, nonatomic) IBOutlet UILabel *labelTrangThaiDichVu;
@property (weak, nonatomic) IBOutlet UILabel *labelTrangThaiThanhToanDichVu;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnCleanRoom;
@property (weak, nonatomic) IBOutlet UIImageView *iconLock;
@property (weak, nonatomic) IBOutlet UIButton *btnShowImageClean;

@end

NS_ASSUME_NONNULL_END
