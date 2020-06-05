//
//  ListImagesDetailViewController.m
//  MyHome
//
//  Created by Macbook on 8/16/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListImagesDetailViewController.h"
#import "ImageDetailViewController.h"

static NSString *cellIdentifier = @"ListImagesDetailCollectionViewCell";

@interface ListImagesDetailViewController ()

@end

@implementation ListImagesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSString stringWithFormat:@"Hình ảnh chi tiết (%lu)",(unsigned long)self.arrayImages.count];
}

#pragma mark CollectView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListImagesDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.arrayImages[indexPath.row];
    
    NSString *link = [dict[@"IMG"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    link = [Utils convertStringUrl:link];
    link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
    NSURL *urlImage = [NSURL URLWithString:link];
    
    [cell.imageHome sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (collectionView.frame.size.width-10*2)/3;
    float height = width;
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
    vc.arrayImages = self.arrayImages;
    vc.index = (int)indexPath.row;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
}


//- (void)getAllImage {
//    for (NSDictionary *dict in arrayResult) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString *link = [dict[@"COVER"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            link = [Utils convertStringUrl:link];
//            link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
//            
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:link]]];
//            image = [Utils scaleImageFromImage:image scaledToSize:([UIScreen mainScreen].bounds.size.width)];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (image) {
//                    [self->arrayImagesSlide addObject:image];
//                }else{
//                    [self->arrayImagesSlide addObject:[UIImage imageNamed:@"image_default"]];
//                }
//            });
//        });
//    }
//}

@end
