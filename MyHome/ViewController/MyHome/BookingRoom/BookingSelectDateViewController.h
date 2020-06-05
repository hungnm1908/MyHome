//
//  BookingSelectDateViewController.h
//  MyHome
//
//  Created by Macbook on 9/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BookingSelectDayCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookingSelectDateViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property NSDictionary *dictRoom;

@property BOOL isLookRoom;

@property (weak, nonatomic) IBOutlet UILabel *labelStart;
@property (weak, nonatomic) IBOutlet UILabel *labelEnd;

@property (weak, nonatomic) IBOutlet UILabel *labelStartDate;
@property (weak, nonatomic) IBOutlet UILabel *labelStartDay;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberDate;
@property (weak, nonatomic) IBOutlet UILabel *labelEndDate;
@property (weak, nonatomic) IBOutlet UILabel *labelEndDay;

@property (weak, nonatomic) IBOutlet UIView *viewCalendar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet MyButton *btnContinue;


@end

NS_ASSUME_NONNULL_END
