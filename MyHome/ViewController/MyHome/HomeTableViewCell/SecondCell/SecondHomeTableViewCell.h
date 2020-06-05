//
//  SecondHomeTableViewCell.h
//  MyHome
//
//  Created by Macbook on 8/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SecondHomeTableViewCellDelegate <NSObject>

- (void)pushViewControllerShowDetailItem : (NSDictionary *)dictSkill;

@end

@interface SecondHomeTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property NSArray *arrayItem;
@property (weak, nonatomic) id<SecondHomeTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
