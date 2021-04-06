//
//  AddCleanImageTableViewCell.m
//  MyHome
//
//  Created by HuCuBi on 6/29/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "AddCleanImageTableViewCell.h"
#import "AddCleanImageCollectionViewCell.h"
#import "Utils.h"
#import "CallAPI.h"

@implementation AddCleanImageTableViewCell {
    NSMutableArray *arrayImages;
    NSDictionary *dictClean;
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

- (void)setData:(NSDictionary *)dictImageClean {
    arrayImages = [NSMutableArray arrayWithArray:[dictImageClean[@"DATA"] isKindOfClass:[NSArray class]] ? dictImageClean[@"DATA"] : @[]];
    dictClean = dictImageClean;
    [self.collectionView reloadData];
}

#pragma mark CollectView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrayImages.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddCleanImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCleanImageCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == arrayImages.count) {
        cell.imageClean.image = [UIImage imageNamed:@"btn_add_photo"];
        cell.btnDelete.hidden = YES;
    }else{
        NSDictionary *dict = arrayImages[indexPath.row];
        
        NSString *link = [dict[@"IMG"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        link = [Utils convertStringUrl:link];
        link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
        NSURL *urlImage = [NSURL URLWithString:link];
        [cell.imageClean sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
        
        cell.btnDelete.hidden = NO;
        [cell.btnDelete addTarget:self action:@selector(deleteSelectImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = collectionView.frame.size.height;
    float height = width;
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == arrayImages.count) {
        [self.delegate addImage:[NSString stringWithFormat:@"%@",dictClean[@"IMG_TYPE"]]];
    }else{
        [self.delegate didSelectImage:arrayImages :(int)indexPath.row];
    }
}

- (void)deleteSelectImage : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *hitIndex = [self.collectionView indexPathForItemAtPoint:hitPoint];
    
    [Utils alert:@"Thông báo" content:@"Bạn chắc chắn muốn xoá ảnh này khỏi danh sách ảnh của nhà" titleOK:@"Đồng ý" titleCancel:@"Huỷ bỏ" viewController:nil completion:^{
        [self deleteImage:hitIndex];
    }];
}

- (void)deleteImage : (NSIndexPath *)hitIndex {
    NSDictionary *dict = arrayImages[hitIndex.row];
    
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOK_SERVICES" : [NSString stringWithFormat:@"%@",dict[@"ID_BOOK_SERVICES"]],
                            @"ID_IMG" : [NSString stringWithFormat:@"%@",dict[@"ID"]]
    };
    
    [CallAPI callApiService:@"book/del_imageci" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [self->arrayImages removeObjectAtIndex:hitIndex.row];
        [self.collectionView reloadData];
    }];
}

@end
