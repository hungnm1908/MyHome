//
//  AddImageViewController.h
//  MyHome
//
//  Created by HuCuBi on 6/30/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ELCImagePickerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddImageViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource>

@property NSString *idDictBookClean;
@property NSString *typeCheckIn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
