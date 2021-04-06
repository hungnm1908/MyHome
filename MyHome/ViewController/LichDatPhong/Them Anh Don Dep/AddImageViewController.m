//
//  AddImageViewController.m
//  MyHome
//
//  Created by HuCuBi on 6/30/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "AddImageViewController.h"
#import "AddCleanImageCollectionViewCell.h"

@interface AddImageViewController ()

@end

@implementation AddImageViewController {
    NSMutableArray *arrayImages;
    NSMutableArray *arrayImagesReferenceURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayImages = [NSMutableArray array];
    arrayImagesReferenceURL = [NSMutableArray array];
    self.navigationItem.title = @"Đăng ảnh";
}

- (IBAction)uploadImage:(id)sender {
    if (arrayImages.count == 0) {
        [Utils alertError:@"Thông báo" content:@"Vui lòng chọn ảnh trước khi đăng" viewController:nil completion:^{
            [self insertPhoto];
        }];
    }else{
        if (arrayImages.count <= 10) {
            [Utils uploadFiles:arrayImages completeBlock:^(NSString *urlImage) {
                [self addImagesClean:urlImage];
            }];
        }else{
            [Utils alertError:@"Thông báo" content:@"Đăng tối đa 10 ảnh mỗi lần. Vui lòng xóa bớt ảnh" viewController:nil completion:^{
                
            }];
        }
    }
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
        
        cell.imageClean.image = dict[@"imge"];
        cell.btnDelete.hidden = NO;
        [cell.btnDelete addTarget:self action:@selector(deleteSelectImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (collectionView.frame.size.width - 30)/4;
    float height = width;
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == arrayImages.count) {
        [self insertPhoto];
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
    [arrayImages removeObjectAtIndex:hitIndex.row];
    [arrayImagesReferenceURL removeObject:dict[@"url"]];
    [self.collectionView reloadData];
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
    ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] init];
    imagePicker.maximumImagesCount = 10;
    imagePicker.imagePickerDelegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self->arrayImages addObject:@{@"imge":info[UIImagePickerControllerOriginalImage],
                                   @"url":[NSString stringWithFormat:@"%ld.JPG", (long)[[NSDate date] timeIntervalSince1970]]
    }];
    [self->arrayImagesReferenceURL addObject:[NSString stringWithFormat:@"%ld.JPG", (long)[[NSDate date] timeIntervalSince1970]]];
    [self.collectionView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (void)addImagesClean : (NSString *)linkImage {
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName];
    
    NSDictionary *param = @{@"USERNAME" : user ? user : @"",
                            @"ID_BOOK_SERVICES" : self.idDictBookClean,
                            @"IMG_PATH":linkImage,
                            @"IMG_TYPE":self.typeCheckIn
    };
    
    [CallAPI callApiService:@"book/update_img_cin" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateAnhDonDep object:nil];
        [Utils alertError:@"Thông báo" content:@"Đăng ảnh thành công" viewController:nil completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
