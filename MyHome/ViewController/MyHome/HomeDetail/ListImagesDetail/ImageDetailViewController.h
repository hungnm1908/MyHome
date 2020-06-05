//
//  ImageDetailViewController.h
//  MyHome
//
//  Created by Macbook on 8/16/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <InfinitePagingView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageDetailViewController : BaseViewController<InfinitePagingViewDelegate>

@property NSArray *arrayImages;
@property int index;

@property (weak, nonatomic) IBOutlet UILabel *labelIndex;
@property (weak, nonatomic) IBOutlet UIView *viewSlidePhoto;

@end

NS_ASSUME_NONNULL_END
