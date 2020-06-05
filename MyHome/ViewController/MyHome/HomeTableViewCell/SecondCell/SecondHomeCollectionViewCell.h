//
//  SecondHomeCollectionViewCell.h
//  MyHome
//
//  Created by Macbook on 8/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecondHomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UILabel *labelNameItem;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberHome;

@end

NS_ASSUME_NONNULL_END
