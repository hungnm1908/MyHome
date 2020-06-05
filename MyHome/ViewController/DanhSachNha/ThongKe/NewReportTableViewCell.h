//
//  NewReportTableViewCell.h
//  MyHome
//
//  Created by HuCuBi on 3/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewReportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;
@property (weak, nonatomic) IBOutlet UIImageView *imageCompare;
@property (weak, nonatomic) IBOutlet UILabel *labelCompare;
@property (weak, nonatomic) IBOutlet UIView *viewCompare;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewCompare;
@property (weak, nonatomic) IBOutlet UILabel *labelContentCompare;

@end

NS_ASSUME_NONNULL_END
