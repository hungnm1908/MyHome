//
//  ImageDetailViewController.m
//  MyHome
//
//  Created by Macbook on 8/16/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ImageDetailViewController.h"


@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController {
    InfinitePagingView *pageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.labelIndex.text = [NSString stringWithFormat:@"%d/%d",self.index+1,(int)self.arrayImages.count];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupSlidePhotoView];
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setupSlidePhotoView {
    pageView = [[InfinitePagingView alloc] initWithFrame:self.viewSlidePhoto.bounds];
    pageView.delegate = self;
    pageView.scrollDirection = InfinitePagingViewHorizonScrollDirection;
    [self.viewSlidePhoto addSubview:pageView];
    
    for (NSDictionary *dict in self.arrayImages) {
        NSString *link = [dict[@"IMG"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        link = [Utils convertStringUrl:link];
        link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
        
        NSURL *urlImage = [NSURL URLWithString:link];
        
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:self.viewSlidePhoto.bounds];
        photoView.contentMode = UIViewContentModeScaleAspectFit;
        [photoView sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
        [pageView addPageView:photoView];
    }
    
    [pageView scrollToDirection:self.index];
}

- (void)pagingView:(InfinitePagingView *)pagingView didEndDecelerating:(UIScrollView *)scrollView atPageIndex:(NSInteger)pageIndex {
    self.labelIndex.text = [NSString stringWithFormat:@"%ld/%d",(long)pageIndex+1,(int)self.arrayImages.count];
}



@end
