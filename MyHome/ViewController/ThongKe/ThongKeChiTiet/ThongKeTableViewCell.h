//
//  ThongKeTableViewCell.h
//  MyHome
//
//  Created by Macbook on 8/15/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThongKeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDoanhThu;
@property (weak, nonatomic) IBOutlet UILabel *labelChiPhi;
@property (weak, nonatomic) IBOutlet UILabel *labelLoiNhuan;

@end

NS_ASSUME_NONNULL_END
