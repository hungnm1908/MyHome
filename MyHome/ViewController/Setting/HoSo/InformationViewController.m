//
//  InformationViewController.m
//  MyHome
//
//  Created by Macbook on 8/19/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "InformationViewController.h"
#import "CommonTableViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController {
    NSDictionary *dictTypeUser;
    NSDictionary *dictTP;
    NSDictionary *dictIdToaNha;
    
    NSData *webData;
    NSString *fileName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isEdit == NO) {
        self.btnUpdate.hidden = YES;
        self.textFieldName.enabled = NO;
        self.textFieldEmail.enabled = NO;
        self.textFieldDoB.enabled = NO;
        self.controlStatus.enabled = NO;
        self.textFieldAddress.enabled = NO;
        self.textFieldSoTaiKhoan.enabled = NO;
        self.textFieldTenTaiKhoan.enabled = NO;
        self.textFieldTenChiNhanh.enabled = NO;
        self.textFieldPhone.enabled = NO;
        self.btnChangePassword.hidden = YES;
//        self.heightBtnChangePassword.constant = 0;
        self.btnCall.hidden = NO;
        self.btnZall.hidden = NO;
    }else{
        [self performSelector:@selector(enterSoTaiKhoan) withObject:nil afterDelay:1.0];
    }
    
    [self getUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kProvince" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kUserType" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kVnBank" object:nil];
}

- (void)enterSoTaiKhoan {
    [self.textFieldSoTaiKhoan becomeFirstResponder];
}

- (void)fillInfo : (NSDictionary *) dictInfo {
    NSDictionary *dict = [Utils converDictRemoveNullValue:dictInfo];

    self.textFieldUser.text = dict[@"USERID"];
    self.textFieldName.text = dict[@"FULL_NAME"];
    self.textFieldPhone.text = [NSString stringWithFormat:@"%@",dict[@"MOBILE"]];
    self.textFieldEmail.text = [NSString stringWithFormat:@"%@",dict[@"EMAIL"]];
    self.textFieldDoB.text = [[[NSString stringWithFormat:@"%@",dict[@"DOB"]] componentsSeparatedByString:@" "] firstObject] ;
    self.textFieldTP.text = [NSString stringWithFormat:@"%@",dict[@"PROVINCE_NAME"]];
    self.textFieldAddress.text = [NSString stringWithFormat:@"%@",dict[@"ADDRESS"]];
    self.textFieldTypeUser.text = [NSString stringWithFormat:@"%@",dict[@"DES_USERTYPE"]];
    self.controlStatus.selectedSegmentIndex = [dict[@"STATE"] intValue];
    self.textFieldToaNha.text = [NSString stringWithFormat:@"%@",dict[@"LOCATION_NAME"]];
    
    NSString *link = [dict[@"AVATAR"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    link = [Utils convertStringUrl:link];
    link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
    NSURL *urlImage = [NSURL URLWithString:link];
    [self.imageAvatar sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.size.height/2;
    self.imageAvatar.clipsToBounds = YES;

    dictTP = @{@"MATP":[NSString stringWithFormat:@"%@",dict[@"ID_PROVINCE"]],
               @"NAME":[NSString stringWithFormat:@"%@",dict[@"PROVINCE_NAME"]]
               };
    
    dictTypeUser = @{@"TYPE_NAME":[NSString stringWithFormat:@"%@",dict[@"DES_USERTYPE"]],
                     @"USER_TYPE":[NSString stringWithFormat:@"%@",dict[@"USER_TYPE"]]
                     };
    
    dictIdToaNha = @{@"LOCATION_NAME":[NSString stringWithFormat:@"%@",dict[@"LOCATION_NAME"]],
                     @"LOCATION_ID":[NSString stringWithFormat:@"%@",dict[@"LOCATION_ID"]]
    };
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    if (self.isEdit && userType==0) {
        self.controlStatus.enabled = YES;
        self.btnSelectUserType.enabled = YES;
        self.imageDropDown.hidden = NO;
        self.imageDropDownToaNha.hidden = NO;
    }else{
        self.controlStatus.enabled = NO;
        self.btnSelectUserType.enabled = NO;
        self.imageDropDown.hidden = YES;
        self.imageDropDownToaNha.hidden = YES;
    }

    self.textFieldSoTaiKhoan.text = [NSString stringWithFormat:@"%@",dict[@"SO_TK"]];
    self.textFieldTenTaiKhoan.text = [NSString stringWithFormat:@"%@",dict[@"TEN_TK"]];
    self.textFieldTenNganHang.text = [NSString stringWithFormat:@"%@",dict[@"TEN_NH"]];
    self.textFieldTenChiNhanh.text = [NSString stringWithFormat:@"%@",dict[@"TEN_CN"]];
}

- (void)myDismissKeyboard {
    [self.textFieldUser resignFirstResponder];
    [self.textFieldTypeUser resignFirstResponder];
    [self.textFieldTP resignFirstResponder];
    [self.textFieldDoB resignFirstResponder];
    [self.textFieldName resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldPhone resignFirstResponder];
    [self.textFieldAddress resignFirstResponder];
    [self.textFieldSoTaiKhoan resignFirstResponder];
    [self.textFieldTenNganHang resignFirstResponder];
    [self.textFieldTenTaiKhoan resignFirstResponder];
    [self.textFieldTenChiNhanh resignFirstResponder];
}

- (IBAction)selectTP:(id)sender {
    if (self.isEdit) {
        if ([VariableStatic sharedInstance].arrayProvince.count > 0) {
            [self selectProvince];
        }else{
            [CallAPI callApiService:@"get_city" dictParam:@{@"USERNAME":@""} isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
                [VariableStatic sharedInstance].arrayProvince = dictData[@"INFO"];
                
                [self selectProvince];
            }];
        };
    }
}

- (IBAction)selectToaNha:(id)sender {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    if (self.isEdit && userType==0) {
        if ([Utils lenghtText:self.textFieldTP.text] == 0) {
            [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn Tỉnh/Thành phố" viewController:self completion:^{
                [self selectTP:nil];
            }];
        }else{
            [self getListToaNha];
        }
    }
}


- (IBAction)selectTypeUser:(id)sender {
    if ([VariableStatic sharedInstance].arrayUserType.count > 0) {
        [self selectUserType];
    }else{
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName];
        NSDictionary *param = @{@"USERNAME":user ? user : @""};
        
        [CallAPI callApiService:@"get_type" dictParam:param isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
            [VariableStatic sharedInstance].arrayUserType = dictData[@"INFO"];
            
            [self selectUserType];
        }];
    }
}

- (IBAction)selectBankName:(id)sender {
    if (self.isEdit) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ListVnBank" ofType:@"plist"];
        NSArray *listVnBank = [[NSArray arrayWithContentsOfFile:plistPath] copy];
        
        CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
        vc.typeView = kVnBank;
        vc.arrayItem = listVnBank;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)changeStatusUser:(id)sender {
    
}

- (IBAction)updateInfo:(id)sender {
    if ([self isEnoughInfo]) {
        [Utils uploadFile:webData fileName:fileName completeBlock:^(NSString *urlImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self callAPIUpdate:urlImage];
            });
        }];
    }
}

- (IBAction)selectAvatar:(id)sender {
    [self myDismissKeyboard];
    
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

- (IBAction)changePassword:(id)sender {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    int userType = [userInfo[@"USER_TYPE"] intValue];
    if (self.isEdit && userType==0) {
        [Utils alert:@"Thông báo" content:@"Bạn chắc chắn muốn thay đổi mật khẩu cho người dùng này" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
            [self alertWithTextField:@"THAY ĐỔI MẬT KHẨU" message:@"Mời nhập mật khẩu mới" placeholder:@"Mật khẩu mới" titleBtnOk:@"Đồng ý" titleBtnCancel:@"Hủy bỏ" viewController:nil completeBlock:^(NSString *content) {
                [self callAPIUpdatePassword:content];
            } cancel:^{
                
            }];
        }];
    }else{
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"] animated:YES];
    }
}

- (void)alertWithTextField : (NSString *)title message : (NSString *) message placeholder:(NSString *)placeholder titleBtnOk : (NSString *)titleBtnOk titleBtnCancel : (NSString *)titleBtnCancel viewController : (UIViewController *)vc completeBlock:(void(^)(NSString *content))block cancel:(void(^)(void))cancel{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: title
                                                                              message: message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = placeholder;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *btnOK = [UIAlertAction
                            actionWithTitle:titleBtnOk
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                NSArray * textfields = alertController.textFields;
                                UITextField * namefield = textfields[0];
                                NSLog(@"%@",namefield.text);
                                block(namefield.text);
                            }];
    [alertController addAction:btnOK];
    
    if (titleBtnCancel) {
        UIAlertAction *btnCancel = [UIAlertAction
                                    actionWithTitle:titleBtnCancel
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [alertController dismissViewControllerAnimated:YES completion:nil];
                                        cancel();
                                    }];
        [alertController addAction:btnCancel];
        [btnCancel setValue:[UIColor redColor] forKey:@"titleTextColor"];
    }
    
    if (vc) {
        [vc presentViewController:alertController animated:YES completion:nil];
    }else{
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)isEnoughInfo {
    BOOL isOk = NO;
    
    if ([Utils lenghtText:self.textFieldTypeUser.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn loại người dùng" viewController:self completion:^{
            [self selectTypeUser:nil];
        }];
    }else if ([Utils lenghtText:self.textFieldEmail.text] > 0 && ![Utils NSStringIsValidEmail:self.textFieldEmail.text]) {
        [Utils alertError:@"Thông báo" content:@"Email không chính xác" viewController:self completion:^{
            [self.textFieldEmail becomeFirstResponder];
        }];
    }else if ([Utils lenghtText:self.textFieldTP.text] == 0) {
        [Utils alertError:@"Thông báo" content:@"Bạn chưa chọn Tỉnh/Thành phố" viewController:self completion:^{
            [self selectTP:nil];
        }];
    }else{
        isOk = YES;
    }
    
    return isOk;
}

- (void)getUserInfo {
    NSDictionary *dictParam = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                @"USERID":self.userID ? self.userID : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]
    };
    
    [CallAPI callApiService:@"user/get_info" dictParam:dictParam isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSDictionary *dictInfo = dictData[@"INFO"][0];
        [self fillInfo:dictInfo];
    }];
}

- (void)selectUserType {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = [VariableStatic sharedInstance].arrayUserType;
    vc.typeView = kUserType;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)selectProvince {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = [VariableStatic sharedInstance].arrayProvince;
    vc.typeView = kProvince;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark Photo
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.imageAvatar.image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            NSURL *imageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
            NSString *imageEXT = imageUrl.absoluteString;
            imageEXT = [[imageEXT componentsSeparatedByString:@"="] lastObject];
            
            self->webData =  UIImageJPEGRepresentation(image,0.2);
            long CurrentTime = [[NSDate date] timeIntervalSince1970];
            self->fileName = [NSString stringWithFormat:@"%ld.%@", CurrentTime,imageEXT];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)call:(id)sender {
    NSString *tel = [NSString stringWithFormat:@"tel://%@",self.textFieldPhone.text];
    NSURL *URL = [NSURL URLWithString:tel];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)zalo:(id)sender {
    NSString *tel = [NSString stringWithFormat:@"http://zalo.me/%@",self.textFieldPhone.text];
    NSURL *url = [NSURL URLWithString: tel];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark CallAPI

- (void)callAPIUpdate : (NSString *)urlAvatar {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"USERID":self.textFieldUser.text,
                            @"PASSWORD":@"",
                            @"MOBILE":self.textFieldPhone.text,
                            @"EMAIL":self.textFieldEmail.text,
                            @"FULL_NAME":self.textFieldName.text,
                            @"DOB":self.textFieldDoB.text,
                            @"USER_TYPE":dictTypeUser[@"USER_TYPE"],
                            @"AVATAR":urlAvatar?urlAvatar:@"",
                            @"STATE":[NSString stringWithFormat:@"%d",(int)self.controlStatus.selectedSegmentIndex],
                            @"ADDRESS":self.textFieldAddress.text,
                            @"ID_PROVINCE":[NSString stringWithFormat:@"%@",dictTP[@"MATP"]],
                            @"STK":self.textFieldSoTaiKhoan.text,
                            @"TENTK":self.textFieldTenTaiKhoan.text,
                            @"TENNH":self.textFieldTenNganHang.text,
                            @"TENCN":self.textFieldTenChiNhanh.text,
                            @"LOCATION_ID":[NSString stringWithFormat:@"%@",dictIdToaNha[@"LOCATION_ID"]],
                            };
    
    [CallAPI callApiService:@"user/update_info" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserInfo object:nil];
        [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)callAPIUpdatePassword : (NSString *)password {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"USERID":self.textFieldUser.text,
                            @"PASSWORD":password,
                            @"MOBILE":self.textFieldPhone.text,
                            @"EMAIL":self.textFieldEmail.text,
                            @"FULL_NAME":self.textFieldName.text,
                            @"DOB":self.textFieldDoB.text,
                            @"USER_TYPE":dictTypeUser[@"USER_TYPE"],
                            @"AVATAR":@"",
                            @"STATE":[NSString stringWithFormat:@"%d",(int)self.controlStatus.selectedSegmentIndex],
                            @"ADDRESS":self.textFieldAddress.text,
                            @"ID_PROVINCE":[NSString stringWithFormat:@"%@",dictTP[@"MATP"]],
                            @"STK":self.textFieldSoTaiKhoan.text,
                            @"TENTK":self.textFieldTenTaiKhoan.text,
                            @"TENNH":self.textFieldTenNganHang.text,
                            @"TENCN":self.textFieldTenChiNhanh.text,
                            };
    
    [CallAPI callApiService:@"user/update_info" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:@"Đổi mật khẩu cho người dùng thành công" viewController:nil completion:^{
            
        }];
    }];
}

- (void)getListToaNha {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"PROVINCE_ID":[NSString stringWithFormat:@"%@",dictTP[@"MATP"]],
    };
    
    [CallAPI callApiService:@"room/get_location" dictParam:param isGetError:NO viewController:self completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayIdToaNha = dictData[@"INFO"];
        
        CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
        vc.arrayItem = arrayIdToaNha;
        vc.typeView = kBuilding;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

#pragma mark Notification

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kProvince"]) {
        dictTP = notif.object;
        self.textFieldTP.text = dictTP[@"NAME"];
    }else if ([notif.name isEqualToString:@"kUserType"]) {
        dictTypeUser = notif.object;
        self.textFieldTypeUser.text = dictTypeUser[@"TYPE_NAME"];
    }else if ([notif.name isEqualToString:@"kVnBank"]) {
        NSDictionary *dictBank = notif.object;
        self.textFieldTenNganHang.text = dictBank[@"name"];
    }else if ([notif.name isEqualToString:@"kBuilding"]) {
        dictIdToaNha = notif.object;
        self.textFieldToaNha.text = dictIdToaNha[@"LOCATION_NAME"];
    }
}

@end
