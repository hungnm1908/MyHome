//
//  RoomInforViewController.m
//  MyHome
//
//  Created by Macbook on 8/28/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "RoomInforViewController.h"
#import "RoomInforCollectionViewCell.h"
#import "CommonTableViewController.h"

@interface RoomInforViewController ()

@end

@implementation RoomInforViewController {
    NSMutableArray *arrayImages;
    NSMutableArray *arrayImagesReferenceURL;
    BOOL isSelectCoverImage;
    NSDictionary *dictTP;
    NSArray *arrayIdToaNha;
    NSDictionary *dictIdToaNha;
    
    NSData *webData;
    NSString *fileName;
    
    NSString *cLinkImageCover;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayImages = [NSMutableArray array];
    arrayImagesReferenceURL = [NSMutableArray array];
//    arrayIdToaNha = @[@{@"id":@"1",
//                        @"name":@"Sunrise"
//                        },
//                      @{@"id":@"2",
//                        @"name":@"Greenbay Premium"
//                        },
//                      @{@"id":@"3",
//                        @"name":@"Greenbay Garden"
//                        },
//                      @{@"id":@"4",
//                        @"name":@"Greenbay Village"
//                        },
//                      @{@"id":@"5",
//                        @"name":@"Royal Lotus"
//                        }];
    
    [self fillInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kProvince" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kBuilding" object:nil];
}

- (void)fillInfo {
    self.textFieldNameRoom.text = self.dictRoom[@"NAME"];
    self.textFieldAddress.text = self.dictRoom[@"ADDRESS"];
    self.textViewShortDeps.text = self.dictRoom[@"DESCRIPTION"];
    self.textViewDetailDeps.text = [Utils convertHTML:self.dictRoom[@"INFOMATION"]];
    self.textFieldBedNumber.text = [NSString stringWithFormat:@"%@",self.dictRoom[@"MAX_BED"]];
    self.textFieldRoomNumber.text = [NSString stringWithFormat:@"%@",self.dictRoom[@"MAX_ROOM"]];
    
    if (![self.dictRoom[@"LOCATION_ID"] isKindOfClass:[NSNull class]]) {
        NSString *locationID = [NSString stringWithFormat:@"%@",self.dictRoom[@"LOCATION_ID"]];
        NSString *locationName = [NSString stringWithFormat:@"%@",self.dictRoom[@"LOCATION_NAME"]];
        dictIdToaNha = @{@"LOCATION_ID":locationID,
                         @"LOCATION_NAME":locationName
                         };
        self.textFieldIdToaNha.text = locationName;
    }
    
    if (![self.dictRoom[@"PROVINCE_NAME"] isKindOfClass:[NSNull class]]) {
        NSString *provinceID = [NSString stringWithFormat:@"%@",self.dictRoom[@"ID_PROVINCE"]];
        NSString *provinceName = [NSString stringWithFormat:@"%@",self.dictRoom[@"PROVINCE_NAME"]];
        dictTP = @{@"MATP":provinceID,
                   @"NAME":provinceName
                   };
        self.textFieldTP.text = provinceName;
    }
    
    NSString *link = [self.dictRoom[@"IMG"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    link = [Utils convertStringUrl:link];
    link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
    NSURL *urlImage = [NSURL URLWithString:link];
    [self.imageCover sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
    
    cLinkImageCover = [NSString stringWithFormat:@"%@",self.dictRoom[@"IMG"]];
    
    if (!self.isCreate) {
        [self getListImageHome];
    }
}

- (IBAction)choseCoverImage:(id)sender {
    isSelectCoverImage = YES;
    [self insertPhoto];
}

- (IBAction)selectTP:(id)sender {
    if ([VariableStatic sharedInstance].arrayProvince.count > 0) {
        [self selectProvince];
    }else{
        [self getListProvince];
    }
}

- (IBAction)selectIdToaNha:(id)sender {
    if ([Utils lenghtText:self.textFieldTP.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn Tỉnh/Thành phố" viewController:nil completion:^{
            [self selectTP:nil];
        }];
    }else{
        [self getListToaNha];
    }
}

- (IBAction)update:(id)sender {
    if ([self isEnoughInfo]) {
        if (webData && fileName) {
            [Utils uploadFile:webData fileName:fileName completeBlock:^(NSString *urlImage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateHomeInfo:urlImage];
                });
            }];
        }else{
            [self updateHomeInfo:nil];
        }
    }
}

- (void)selectProvince {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = [VariableStatic sharedInstance].arrayProvince;
    vc.typeView = kProvince;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (BOOL)isEnoughInfo {
    BOOL isOK = YES;
    
    if ([Utils lenghtText:self.textFieldNameRoom.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Tên nhà" viewController:nil completion:^{
            [self.textFieldNameRoom becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldTP.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn Tỉnh/Thành phố" viewController:nil completion:^{
            [self selectTP:nil];
        }];
    }else if ([Utils lenghtText:self.textFieldAddress.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Địa chỉ nhà" viewController:nil completion:^{
            [self.textFieldAddress becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldRoomNumber.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Số nhà" viewController:nil completion:^{
            [self.textFieldRoomNumber becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldBedNumber.text] == 0) {
        isOK = NO;
        [Utils alertError:@"Thông báo" content:@"Bạn chưa nhập Số giường ngủ" viewController:nil completion:^{
            [self.textFieldBedNumber becomeFirstResponder];
        }];
    }
    
    return isOK;
}

#pragma mark CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrayImages.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RoomInforCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomInforCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == arrayImages.count) {
        cell.imageViewRoom.image = [UIImage imageNamed:@"btn_add_photo"];
        cell.btnDelete.hidden = YES;
    }else{
        NSDictionary *dict = arrayImages[indexPath.row];
        if (dict[@"GENLINK"]) {
            NSString *link = [dict[@"IMG"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            link = [Utils convertStringUrl:link];
            link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
            NSURL *urlImage = [NSURL URLWithString:link];
            [cell.imageViewRoom sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
            
        }else{
            cell.imageViewRoom.image = dict[@"imge"];
        }
        
        cell.btnDelete.hidden = NO;
        [cell.btnDelete addTarget:self action:@selector(deleteSelectImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = collectionView.frame.size.height;
    float height = collectionView.frame.size.height;
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == arrayImages.count) {
        isSelectCoverImage = NO;
        [self insertPhoto];
    }else{
        RoomInforCollectionViewCell *cell = (RoomInforCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        self.imageCover.image = cell.imageViewRoom.image;
        
        NSDictionary *dict = arrayImages[indexPath.row];
        if ([arrayImagesReferenceURL containsObject:dict[@"url"]]) {
            webData =  UIImageJPEGRepresentation(dict[@"imge"],0.2);
            long CurrentTime = [[NSDate date] timeIntervalSince1970];
            fileName = [NSString stringWithFormat:@"%ld.JPG", CurrentTime];
        }else{
            cLinkImageCover = dict[@"IMG"];
            webData = nil;
            fileName = nil;
        }
    }
}

- (void)deleteSelectImage : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *hitIndex = [self.collectionView indexPathForItemAtPoint:hitPoint];
    
    NSDictionary *dict = arrayImages[hitIndex.row];
    if ([arrayImagesReferenceURL containsObject:dict[@"url"]]) {
        [arrayImagesReferenceURL removeObject:dict[@"url"]];
        [arrayImages removeObjectAtIndex:hitIndex.row];
        [self.collectionView reloadData];
    }else{
        [Utils alert:@"Thông báo" content:@"Bạn chắc chắn muốn xoá ảnh này khỏi danh sách ảnh của nhà" titleOK:@"Đồng ý" titleCancel:@"Huỷ bỏ" viewController:nil completion:^{
            [self deleteImage:hitIndex];
        }];
    }
}

#pragma mark insert photo

- (void)insertPhoto {
    UIAlertController *actionSheet = [UIAlertController
                                      alertControllerWithTitle:@"Thêm ảnh"
                                      message:@"Mời bạn chọn ảnh từ trong bộ sưu tập hoặc chụp ảnh mới"
                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *btnTakePhoto = [UIAlertAction
                                   actionWithTitle:@"Máy ảnh"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                       [self takePhoto];
                                   }];
    [actionSheet addAction:btnTakePhoto];
    
    UIAlertAction *btnSelectPhoto = [UIAlertAction
                                     actionWithTitle:@"Bộ sưu tập"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                         [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                         [self selectPhoto];
                                     }];
    [actionSheet addAction:btnSelectPhoto];
    
    UIAlertAction *btnCancel = [UIAlertAction
                                actionWithTitle:@"Huỷ bỏ"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                }];
    [btnCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [actionSheet addAction:btnCancel];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [actionSheet.popoverPresentationController setPermittedArrowDirections:0];

        //For set action sheet to middle of view.
        CGRect rect = self.view.frame;
        actionSheet.popoverPresentationController.sourceView = self.view;
        actionSheet.popoverPresentationController.sourceRect = rect;
    }
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    __block BOOL isAccess = NO;
    
    if(authStatus == AVAuthorizationStatusAuthorized) {
        isAccess = YES;
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
            if(granted){
                isAccess = YES;
            }else{
                isAccess = NO;
            }
        }];
    }else if (authStatus == AVAuthorizationStatusRestricted){
        isAccess = YES;
    }else{
        isAccess = NO;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if (!isAccess) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, [UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height)];
            label.text = @"Để cấp cho MyHome quyền truy cập vào camera của bạn, hãy chuyển đến Cài đặt > Quyền riêng tư > Camera trên thiết bị của bạn";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.numberOfLines = 0;
            [picker.view addSubview:label];
        }
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)selectPhoto{
    if (isSelectCoverImage) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] init];
        imagePicker.maximumImagesCount = 10;
        imagePicker.imagePickerDelegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (isSelectCoverImage) {
        self.imageCover.image = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
            if ([mediaType isEqualToString:@"public.image"]) {
                UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                
                self->webData =  UIImageJPEGRepresentation(image,0.2);
                long CurrentTime = [[NSDate date] timeIntervalSince1970];
                self->fileName = [NSString stringWithFormat:@"%ld.JPG", CurrentTime];
            }
        }];
    }else{
        [self->arrayImages addObject:@{@"imge":info[UIImagePickerControllerOriginalImage],
                                       @"url":[NSString stringWithFormat:@"%ld.JPG", (long)[[NSDate date] timeIntervalSince1970]]
                                        }];
        [self->arrayImagesReferenceURL addObject:[NSString stringWithFormat:@"%ld.JPG", (long)[[NSDate date] timeIntervalSince1970]]];
        [self.collectionView reloadData];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    for (NSDictionary *dict in info) {
        UIImage *image = dict[UIImagePickerControllerOriginalImage];
        NSString *urlImage = dict[UIImagePickerControllerReferenceURL];
        if (![arrayImagesReferenceURL containsObject:urlImage]) {
            [arrayImages addObject:@{@"imge":image,
                                     @"url":urlImage
                                     }];
            [arrayImagesReferenceURL addObject:urlImage];
        }
    }
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark CallAPI

- (void)getListToaNha {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"PROVINCE_ID":[NSString stringWithFormat:@"%@",dictTP[@"MATP"]],
    };
    
    [CallAPI callApiService:@"room/get_location" dictParam:param isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
        self->arrayIdToaNha = dictData[@"INFO"];
        
        CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
        vc.arrayItem = self->arrayIdToaNha;
        vc.typeView = kBuilding;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

- (void)getListProvince {
    [CallAPI callApiService:@"get_city" dictParam:@{@"USERNAME":@""} isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
        [VariableStatic sharedInstance].arrayProvince = dictData[@"INFO"];
        
        [self selectProvince];
    }];
}

- (void)getListImageHome {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : self.dictRoom[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"room/get_album_image" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        if ([dictData[@"ERROR"] isEqualToString:@"0000"]) {
            [self->arrayImages addObjectsFromArray:dictData[@"INFO"]];
            [self.collectionView reloadData];
        }
    }];
}

- (void)updateHomeInfo : (NSString *)urlImageCover {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"NAME":self.textFieldNameRoom.text,
                            @"ADDRESS":self.textFieldAddress.text,
                            @"PRICE":@"",
                            @"PRICE_SPECIAL":@"",
                            @"PRICE_EXTRA":@"",
                            @"MAX_GUEST":@"",
                            @"MAX_ROOM":self.textFieldRoomNumber.text,
                            @"MAX_BED":self.textFieldBedNumber.text,
                            @"CLEAN_ROOM":@"",
                            @"DESCRIPTION":self.textViewShortDeps.text,
                            @"INFOMATION":self.textViewDetailDeps.text,
                            @"POLICY_CANCLE":@"",
                            @"GENLINK":[NSString stringWithFormat:@"%@",self.dictRoom[@"GENLINK"]],
                            @"PROVINCE_ID":[NSString stringWithFormat:@"%@",dictTP[@"MATP"]],
                            @"LOCATION_ID":dictIdToaNha?dictIdToaNha[@"LOCATION_ID"]:@"",
                            @"COVER":urlImageCover ? urlImageCover : cLinkImageCover,
                            @"MAX_GUEST_EXIST":@""
                            };
    
    [CallAPI callApiService:@"room/edit_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateRoomInfor object:param];
        
        if (self->arrayImagesReferenceURL.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(uploadArrayImages) withObject:nil afterDelay:0.5];
            });
        }else{
            [Utils alertWithCancelProcess:@"Thông báo" content:@"Cập nhật thông tin nhà thành công. Bạn muốn tiếp tục cập nhật thông tin giá nhà ?" titleOK:@"Đồng ý" titleCancel:@"Để sau" viewController:nil completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateRoomInforProperty object:nil];
            } cancel:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)uploadArrayImages {
    [Utils uploadFiles:arrayImages completeBlock:^(NSString *urlImage) {
        [self fillArrayImages:urlImage];
    }];
}

- (void)fillArrayImages : (NSString *)path {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : self.dictRoom[@"GENLINK"],
                            @"PATH":path
    };
    
    [CallAPI callApiService:@"room/update_image" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertWithCancelProcess:@"Thông báo" content:@"Cập nhật thông tin nhà thành công. Bạn muốn tiếp tục cập nhật thông tin giá nhà ?" titleOK:@"Đồng ý" titleCancel:@"Để sau" viewController:nil completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateRoomInforProperty object:nil];
        } cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)deleteImage : (NSIndexPath *)hitIndex {
    NSDictionary *dict = arrayImages[hitIndex.row];
    
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : [NSString stringWithFormat:@"%@",dict[@"GENLINK"]],
                            @"ID_IMAGE" : [NSString stringWithFormat:@"%@",dict[@"ID"]]
    };
    
    [CallAPI callApiService:@"room/del_image" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [self->arrayImages removeObjectAtIndex:hitIndex.row];
        [self.collectionView reloadData];
    }];
}

#pragma mark Notificaion
- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kProvince"]) {
        dictTP = notif.object;
        self.textFieldTP.text = dictTP[@"NAME"];
    }else if ([notif.name isEqualToString:@"kBuilding"]) {
        dictIdToaNha = notif.object;
        self.textFieldIdToaNha.text = dictIdToaNha[@"LOCATION_NAME"];
    }
}

@end
