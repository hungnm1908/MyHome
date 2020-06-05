//
//  FirstHomeTableViewCell.h
//  MyHome
//
//  Created by Macbook on 8/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MARKRangeSlider.h"
#import <InfinitePagingView.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirstHomeTableViewCell : UITableViewCell<InfinitePagingViewDelegate>

@property NSArray *arrayImagesSlide;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHome;
@property (weak, nonatomic) IBOutlet UIView *viewSlidePhoto;

@property (weak, nonatomic) IBOutlet UITextField *textFieldNameSearch;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNumberCustomer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFromDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldToDate;
@property (weak, nonatomic) IBOutlet UILabel *labelMinCost;
@property (weak, nonatomic) IBOutlet UILabel *labelMaxCost;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *rangeSlider;


@end

NS_ASSUME_NONNULL_END
