//
//  AddCleanImageTableViewCell.h
//  MyHome
//
//  Created by HuCuBi on 6/29/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCleanImageTableViewCellDelegate <NSObject>

- (void)didSelectImage : (NSArray *_Nonnull)arrayImage : (int)indexSelect;
- (void)addImage : (NSString *_Nonnull)typeCheckIn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AddCleanImageTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id<AddCleanImageTableViewCellDelegate> delegate;

- (void)setData : (NSDictionary *)dictImageClean;

@end

NS_ASSUME_NONNULL_END
