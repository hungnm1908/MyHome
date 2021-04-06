//
//  ImageCleanTableViewCell.m
//  MyHome
//
//  Created by HuCuBi on 6/27/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "ImageCleanTableViewCell.h"
#import "ImageCleanCollectionViewCell.h"
#import "Utils.h"

@implementation ImageCleanTableViewCell {
    NSArray *arrayImages;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSArray *)arrayImageClean {
    arrayImages = arrayImageClean;
    self.labelNotice.hidden = arrayImages.count > 0 ? YES : NO;
    [self.collectionView reloadData];
}

#pragma mark CollectView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrayImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCleanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCleanCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dict = arrayImages[indexPath.row];
    
    NSString *link = [NSString stringWithFormat:@"%@",dict[@"IMG"]];
    link = [link stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    link = [Utils convertStringUrl:link];
    link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
    NSURL *urlImage = [NSURL URLWithString:link];
    
    [cell.imageClean sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = collectionView.frame.size.height;
    float height = width;
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectImage:arrayImages :(int)indexPath.row];
}


@end
