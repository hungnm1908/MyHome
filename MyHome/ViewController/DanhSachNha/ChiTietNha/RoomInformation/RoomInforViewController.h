//
//  RoomInforViewController.h
//  MyHome
//
//  Created by Macbook on 8/28/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ELCImagePickerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomInforViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate>

@property NSDictionary *dictRoom;
@property BOOL isCreate;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldNameRoom;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldTP;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldIdToaNha;
@property (weak, nonatomic) IBOutlet UIImageView *imageCover;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *textViewShortDeps;
@property (weak, nonatomic) IBOutlet UITextView *textViewDetailDeps;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldRoomNumber;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldBedNumber;
@property (weak, nonatomic) IBOutlet MyButton *btnUpdate;

- (BOOL)isEnoughInfo;

@end

NS_ASSUME_NONNULL_END
