//
//  ListImagesDetailViewController.h
//  MyHome
//
//  Created by Macbook on 8/16/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ListImagesDetailCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListImagesDetailViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property NSArray *arrayImages;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
