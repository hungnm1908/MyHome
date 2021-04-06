//
//  ImageCleanTableViewCell.h
//  MyHome
//
//  Created by HuCuBi on 6/27/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCleanTableViewCellDelegate <NSObject>

- (void)didSelectImage : (NSArray *_Nonnull)arrayImage : (int)indexSelect;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ImageCleanTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labelNotice;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id<ImageCleanTableViewCellDelegate> delegate;

- (void)setData : (NSArray *)arrayImageClean;

@end

NS_ASSUME_NONNULL_END
