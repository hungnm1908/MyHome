//
//  SecondHomeTableViewCell.m
//  MyHome
//
//  Created by Macbook on 8/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "SecondHomeTableViewCell.h"
#import "SecondHomeCollectionViewCell.h"
#import "Utils.h"

@implementation SecondHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [self.collectionView reloadData];
}

#pragma mark CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayItem.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SecondHomeCollectionViewCell";
    
    SecondHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (self.arrayItem) {
        NSDictionary *dict = [Utils converDictRemoveNullValue:self.arrayItem[indexPath.row]];
        
        cell.labelNameItem.text = [dict[@"CITY_NAME"] uppercaseString];
        cell.labelNumberHome.text = [NSString stringWithFormat:@"%@ chỗ ở",dict[@"TONG"]];
        
        NSString *link = [[Utils convertStringUrl:dict[@"URL_IMAGE"]] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        link = [Utils convertStringUrl:link];
        link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
        NSURL *urlImage = [NSURL URLWithString:link];
        [cell.imageItem sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    float width = collectionView.frame.size.width*0.7;
    float height = collectionView.frame.size.height;
    float width = height*3/2;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsLogin];
    
    if (isLogin) {
        [self.delegate pushViewControllerShowDetailItem:[Utils converDictRemoveNullValue:self.arrayItem[indexPath.row]]];
    }else{
        [Utils alert:@"Thông báo" content:@"Vui lòng đăng nhập để sửa dụng chức năng này" titleOK:@"Đăng nhập" titleCancel:@"Để sau" viewController:nil completion:^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [[self appDelegate].window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
            [[self appDelegate].window makeKeyAndVisible];
        }];
    }
}

- (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
