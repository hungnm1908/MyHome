//
//  FirstHomeTableViewCell.m
//  MyHome
//
//  Created by Macbook on 8/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "FirstHomeTableViewCell.h"
#import "Utils.h"
#import "BaseViewController.h"

@implementation FirstHomeTableViewCell {
    InfinitePagingView *pageView;
    NSTimer *autoScrollPhotoTimer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [self performSelector:@selector(setupSlidePhotoView) withObject:nil afterDelay:1.0];
}

- (void)setupSlidePhotoView {
    pageView = [[InfinitePagingView alloc] initWithFrame:self.viewSlidePhoto.bounds];
    pageView.delegate = self;
    pageView.scrollDirection = InfinitePagingViewHorizonScrollDirection;
    [self.viewSlidePhoto insertSubview:pageView belowSubview:self];
    
    for (NSString *urlStr in self.arrayImagesSlide) {
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:self.viewSlidePhoto.bounds];
        photoView.contentMode = UIViewContentModeScaleToFill;
        NSURL *urlThumbImage = [NSURL URLWithString:urlStr];
        [photoView sd_setImageWithURL:urlThumbImage placeholderImage:[UIImage imageNamed:@"image_default"] options:SDWebImageAvoidAutoSetImage];
//        [photoView sd_setImageWithURL:urlThumbImage placeholderImage:[UIImage imageNamed:@"image_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            UIImage *newImage = [Utils scaleImageFromImage:image scaledToSize:[UIScreen mainScreen].bounds.size.width];
//            photoView.image = newImage;
//        }];
        
        [pageView addPageView:photoView];
    }
    
    [self autoScrollPhoto];
}

- (void)autoScrollPhoto{
    autoScrollPhotoTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:pageView selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
}

@end
