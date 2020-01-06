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

@property (weak, nonatomic) IBOutlet UILabel *labelNameRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;

@end

NS_ASSUME_NONNULL_END
