//
//  ListBookCalendarViewController.h
//  MyHome
//
//  Created by Macbook on 10/9/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListBookCalendarViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property NSDictionary *dictRoom;
@property NSArray *arrayBookReport;
@property NSDate *startDate;
@property NSDate *endDate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
