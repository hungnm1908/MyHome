//
//  BookingSelectDateViewController.h
//  MyHome
//
//  Created by Macbook on 9/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCalendarView.h"
#import "GLDateUtils.h"
#import "GLCalendarDayCell.h"
#import "BaseViewController.h"
#import "BookingSelectDayCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookingSelectDateViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property NSDictionary *dictRoom;

@property (weak, nonatomic) IBOutlet UILabel *labelStartDate;
@property (weak, nonatomic) IBOutlet UILabel *labelStartDay;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberDate;
@property (weak, nonatomic) IBOutlet UILabel *labelEndDate;
@property (weak, nonatomic) IBOutlet UILabel *labelEndDay;

@property (weak, nonatomic) IBOutlet UIView *viewCalendar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end

NS_ASSUME_NONNULL_END
