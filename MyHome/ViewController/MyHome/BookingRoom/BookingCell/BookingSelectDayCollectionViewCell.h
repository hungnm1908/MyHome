//
//  BookingSelectDayCollectionViewCell.h
//  MyHome
//
//  Created by Macbook on 9/27/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookingSelectDayCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIView *viewIsToDay;

@property (weak, nonatomic) IBOutlet UIView *viewDisableFirstDate;
@property (weak, nonatomic) IBOutlet UIView *viewDisableEndDate;

@property (weak, nonatomic) IBOutlet UIView *viewCurrentPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentPrice;

@end

NS_ASSUME_NONNULL_END
