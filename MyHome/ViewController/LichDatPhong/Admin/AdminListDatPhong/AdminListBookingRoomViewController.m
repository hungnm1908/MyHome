//
//  AdminListBookingRoomViewController.m
//  MyHome
//
//  Created by Macbook on 10/24/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "AdminListBookingRoomViewController.h"
#import "CommonTableViewController.h"
#import "AdminListBookingTableViewCell.h"
#import "InformationViewController.h"
#import "HomeDetailViewController.h"

@interface AdminListBookingRoomViewController ()

@end

@implementation AdminListBookingRoomViewController {
    NSDictionary *dictHome;
    NSArray *arrayMyHomes;
    BOOL isSettup;
    NSArray *arrayBookRoom;
    
    NSString *statusBill;
    NSString *statusBook;
    
    ManaDropDownMenu *dropDownMKH;
    ManaDropDownMenu *dropDownBooking;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    statusBill = @"";
    statusBook = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kMyHome" object:nil];
    
    self.textFieldStartDate.text = [Utils getDateFromDate:[Utils getFirstDayOfThisMonth]];
    self.textFieldEndDate.text = [Utils getDateFromDate:[Utils getLastDayOfMonth:5]];
}

- (void)viewWillAppear:(BOOL)animated {
    CGRect frameStatusBilling = self.viewStatusBilling.frame;
    frameStatusBilling.origin.x = frameStatusBilling.origin.x + 2;
    frameStatusBilling.origin.y = frameStatusBilling.origin.y + 3;
    frameStatusBilling.size.width = frameStatusBilling.size.width - 4;
    frameStatusBilling.size.height = frameStatusBilling.size.height - 6;
    dropDownMKH.frame = frameStatusBilling;
    
    CGRect frameStatusBooking = self.viewStatusBooking.frame;
    frameStatusBooking.origin.x = frameStatusBooking.origin.x + 2;
    frameStatusBooking.origin.y = frameStatusBooking.origin.y + 3;
    frameStatusBooking.size.width = frameStatusBooking.size.width - 4;
    frameStatusBooking.size.height = frameStatusBooking.size.height - 6;
    dropDownBooking.frame = frameStatusBooking;
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isSettup) {
        isSettup = YES;
        [self performSelector:@selector(settupViewSelect) withObject:nil afterDelay:0.5];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [dropDownMKH animateForClose];
    [dropDownBooking animateForClose];
}

- (IBAction)selectStartDate:(id)sender {
    [self.textFieldStartDate becomeFirstResponder];
}

- (IBAction)selectEndDate:(id)sender {
    [self.textFieldEndDate becomeFirstResponder];
}

- (IBAction)selectHome:(id)sender {
    if (arrayMyHomes) {
        CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
        vc.arrayItem = arrayMyHomes;
        vc.typeView = kMyHome;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [self getListHome];
    }
}

- (IBAction)search:(id)sender {
    [self.textFieldStartDate resignFirstResponder];
    [self.textFieldEndDate resignFirstResponder];
    if ([self isEnoughInfo]) {
        [self getListBookRoom];
    }
}

- (BOOL)isEnoughInfo {
    BOOL isOK = YES;
    
    if (![Utils checkFromDate:self.textFieldStartDate.text toDate:self.textFieldEndDate.text view:self]) {
        isOK = NO;
    }
    
    return isOK;
}

- (void)settupViewSelect {
    NSArray *arrayStatusBilling = @[@"- Tất cả -",@"Chưa thanh toán",@"Đã đặt cọc",@"Đã thanh toán"];
    
    CGRect frameStatusBilling = self.viewStatusBilling.frame;
    frameStatusBilling.origin.x = frameStatusBilling.origin.x + 2;
    frameStatusBilling.origin.y = frameStatusBilling.origin.y + 3;
    frameStatusBilling.size.width = frameStatusBilling.size.width - 4;
    frameStatusBilling.size.height = frameStatusBilling.size.height - 6;
    
    dropDownMKH = [[ManaDropDownMenu alloc] initWithFrame:frameStatusBilling title:arrayStatusBilling[0]];
    dropDownMKH.delegate = self;
    dropDownMKH.numberOfRows = arrayStatusBilling.count;
    dropDownMKH.textOfRows = arrayStatusBilling;
    dropDownMKH.seperatorColor = RGB_COLOR(75, 109, 179);
    dropDownMKH.inactiveColor = RGB_COLOR(75, 109, 179);
    dropDownMKH.tag = 0;
    [self.view addSubview:dropDownMKH];
    
    NSArray *arrayStatusBooking = @[@"- Tất cả -",@"Book thành công",@"Khóa nhà",@"Hủy Book"];
    
    CGRect frameStatusBooking = self.viewStatusBooking.frame;
    frameStatusBooking.origin.x = frameStatusBooking.origin.x + 2;
    frameStatusBooking.origin.y = frameStatusBooking.origin.y + 3;
    frameStatusBooking.size.width = frameStatusBooking.size.width - 4;
    frameStatusBooking.size.height = frameStatusBooking.size.height - 6;
    
    dropDownBooking = [[ManaDropDownMenu alloc] initWithFrame:frameStatusBooking title:arrayStatusBooking[0]];
    dropDownBooking.delegate = self;
    dropDownBooking.numberOfRows = arrayStatusBooking.count;
    dropDownBooking.textOfRows = arrayStatusBooking;
    dropDownBooking.seperatorColor = RGB_COLOR(75, 109, 179);
    dropDownBooking.inactiveColor = RGB_COLOR(75, 109, 179);
    dropDownBooking.tag = 1;
    [self.view addSubview:dropDownBooking];
    
    [self search:nil];
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    if (dropDownMenu.tag == 0) {
        if (index != 0) {
            statusBill = [NSString stringWithFormat:@"%ld",(long)index-1];
        }else{
            statusBill = @"";
        }
    }else{
        if (index != 0) {
            statusBook = [NSString stringWithFormat:@"%ld",(long)index];
        }else{
            statusBook = @"";
        }
    }
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AdminListBookingTableViewCell";
    AdminListBookingTableViewCell *cell = (AdminListBookingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookRoom[indexPath.row]];
    
    cell.labelNameRoom.text = [NSString stringWithFormat:@"%@ ",dict[@"ROOM_NAME"]];
    cell.labelNameGuest.text = [NSString stringWithFormat:@"%@ ",dict[@"BOOK_NAME"]];
    cell.labelDateBook.text = [NSString stringWithFormat:@"%@ - %@",dict[@"START_TIME"],dict[@"END_TIME"]];
    cell.labelTimeBook.text = [self getDateFromDate:dict[@"BOOKING_TIME"]];
    
    cell.labelStatusRoom.text = [NSString stringWithFormat:@"%@ ",dict[@"BOOK_STATUS_NAME"]];
    cell.labelStatusRoom.textColor = [self getColorStatusRoom:[dict[@"BOOK_STATUS"] intValue]];
    
    cell.labelStatusBilling.text = [NSString stringWithFormat:@"%@ ",dict[@"BILLING_STATUS_NAME"]];
    cell.labelStatusBilling.textColor = [self getColorStatusBilling:[dict[@"BILLING_STATUS"] intValue]];
    
    cell.labelStatusService.text = [self getStatusService:dict];
    cell.labelStatusService.textColor = [self getColorStatusService:dict];
    
    if ([Utils lenghtText:dict[@"CONTENT"]] == 0) {//Chu nha tu khoa phong
        cell.iconLock.hidden = NO;
        cell.labelContent.text = @"Chủ nhà tự khóa";
        [cell.btnUpdateStatusBill setTitle:@"  Mở khóa nhà  " forState:UIControlStateNormal];
    }else{
        cell.iconLock.hidden = YES;
        cell.labelContent.text = [NSString stringWithFormat:@"%@",dict[@"CONTENT"]];
        [cell.btnUpdateStatusBill setTitle:@"  Cập nhật Thanh Toán  " forState:UIControlStateNormal];
    }
    
    [cell.btnUpdateStatusBill addTarget:self action:@selector(updateStatusBill:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnHomeBook addTarget:self action:@selector(showInfoHome:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnUserBook addTarget:self action:@selector(showInfoUser:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayBookRoom.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)showInfoHome : (id)sender {
    [dropDownMKH animateForClose];
    [dropDownBooking animateForClose];
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookRoom[hitIndex.row]];
    
    HomeDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetailViewController"];
    vc.dictHome = dict;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showInfoUser : (id)sender {
    [dropDownMKH animateForClose];
    [dropDownBooking animateForClose];
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookRoom[hitIndex.row]];
    
    InformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
    vc.userID = dict[@"USERID"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIColor *)getColorStatusBilling : (int)trangThaiThanhToan {
    UIColor *color = [UIColor blackColor];
    switch (trangThaiThanhToan) {
        case 0:
        {
            color = RGB_COLOR(240, 10, 10);
        }
            break;
            
        case 1:
        {
            color = RGB_COLOR(250, 171, 28);
        }
            break;
            
        case 2:
        {
            color = RGB_COLOR(25, 200, 50);
        }
            break;
            
        default:
            break;
    }
    return color;
}

- (UIColor *)getColorStatusRoom : (int)trangThaiBook {
    UIColor *color = [UIColor blackColor];
    switch (trangThaiBook) {
        case 0:
        {
            color = RGB_COLOR(240, 10, 10);
        }
            break;
            
        case 1:
        {
            color = RGB_COLOR(25, 200, 50);
        }
            break;
            
        case 2:
        {
            color = RGB_COLOR(250, 171, 28);
        }
            break;
            
        default:
            break;
    }
    return color;
}

- (NSString *)getDateFromDate : (NSString *)date {
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    [serverDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.000Z'"];
    NSDate *dateServer = [serverDateFormatter dateFromString:date];
    
    if (dateServer) {
        NSDateFormatter *clientDateFormatter = [[NSDateFormatter alloc] init];
        [clientDateFormatter setDateFormat:@"dd/MM/yyyy - HH:mm"];
        NSString *clientDate = [clientDateFormatter stringFromDate:dateServer];
        
        return clientDate;
    }else{
        return date;
    }
}

- (void)updateStatusBill : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookRoom[hitIndex.row]];
    
    if ([Utils lenghtText:dict[@"CONTENT"]] == 0) {
        //Mở khóa nhà
        [self unlockRoom:dict];
    }else{
        //Thay đổi trạng thái thanh toán
        [self selectStatusBill:dict];
    }
}

- (void)selectStatusBill : (NSDictionary *)dict {
    UIAlertController *actionSheet = [UIAlertController
                                      alertControllerWithTitle:@"CẬP NHẬT TRẠNG THÁI THANH TOÁN"
                                      message:@""
                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *btnChuaThanhToan = [UIAlertAction
                                     actionWithTitle:@"Chưa thanh toán"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBill:@"0" :dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnChuaThanhToan];
    
    UIAlertAction *btnDaDatCoc = [UIAlertAction
                                     actionWithTitle:@"Đã đặt cọc"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBill:@"1" :dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnDaDatCoc];
    
    UIAlertAction *btnDaThanhToan = [UIAlertAction
                                     actionWithTitle:@"Đã thanh toán"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBill:@"2" :dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnDaThanhToan];
    
    UIAlertAction *btnDaChuyenTienChoChuNha = [UIAlertAction
                                     actionWithTitle:@"Đã chuyển tiền cho chủ nhà"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBill:@"4" :dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnDaChuyenTienChoChuNha];
    
    UIAlertAction *btnCancelBook = [UIAlertAction
                                     actionWithTitle:@"Hủy đặt phòng"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self cancelBookRoom:dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnCancelBook];
    
    UIAlertAction *btnCancel = [UIAlertAction
                                actionWithTitle:@"Đóng"
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

- (void)unlockRoom : (NSDictionary *)dict {
    [Utils alert:@"Mở khóa nhà" content:@"Bạn chắc chắn muốn mở khóa nhà ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                @"ID_BOOKROOM":[NSString stringWithFormat:@"%@",dict[@"ID"]],
                                @"BOOKING_STATUS":@"3"
                                };
        
        [CallAPI callApiService:@"book/change_booking" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
            [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
                [self getListBookRoom];
            }];
        }];
    }];
}

- (void)cancelBookRoom : (NSString *)idBook {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOKROOM":idBook,
                            @"BOOKING_STATUS":@"3"
                            };
    
    [CallAPI callApiService:@"book/change_booking" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
            [self getListBookRoom];
        }];
    }];
}

- (NSString *)getStatusService : (NSDictionary *)dict {
    NSString *status = @"";
    
    if ([dict[@"IS_BOOK_SERVICES"] intValue] == 0) {
        status = @"Chưa đặt dọn phòng";
    }else{
        if ([dict[@"BILLING_STATUS_SERVICE"] intValue] == 0) {
            if ([dict[@"KIND_OF_PAID"] intValue] == 0) {
                status = @"Chưa thanh toán";
            }else{
                status = @"Thanh toán trả sau";
            }
        }else{
            status = @"Đã thanh toán";
        }
    }
    
    return status;
}

- (UIColor *)getColorStatusService : (NSDictionary *)dict {
    if ([dict[@"IS_BOOK_SERVICES"] intValue] == 0) {
        return RGB_COLOR(240, 10, 10);
    }else{
        if ([dict[@"BILLING_STATUS_SERVICE"] intValue] == 0) {
            return RGB_COLOR(250, 171, 28);
        }else{
            return RGB_COLOR(25, 200, 50);
        }
    }
}

#pragma mark CallAPI

- (void)getListHome {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"OPT":@""
                            };
    
    [CallAPI callApiService:@"room/get_mylist_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayMyHomes = dictData[@"INFO"];
        
        CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
        vc.arrayItem = self->arrayMyHomes;
        vc.typeView = kMyHome;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

- (void)getListBookRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOKROOM":@"",
                            @"ROOM_NAME":@"",
                            @"BOOKING_NAME":@"",
                            @"START_TIME":self.textFieldStartDate.text,
                            @"END_TIME":self.textFieldEndDate.text,
                            @"BILLING_STATUS":statusBill,
                            @"BOOKING_STATUS":statusBook,
                            @"GENLINK":dictHome ? dictHome[@"GENLINK"] : @""
                            };
    
    [CallAPI callApiService:@"book/list_bookroom" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayBookRoom = dictData[@"INFO"];
        [self.tableView reloadData];
    }];
}

- (void)changeStatusBill : (NSString *)status : (NSString *)idBook {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOKROOM":idBook,
                            @"BILLING_STATUS":status
    };
    
    [CallAPI callApiService:@"book/change_billing" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [self getListBookRoom];
    }];
}

- (void)changeStatusBook : (NSString *)status : (NSString *)idBook {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOKROOM":idBook,
                            @"BOOKING_STATUS":status
    };
    
    [CallAPI callApiService:@"book/change_booking" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [self getListBookRoom];
    }];
}

- (void)reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kMyHome"]) {
        dictHome = notif.object;
        if (dictHome.allKeys.count == 0) {
            self.labelHomeName.text = @"- Tất cả -";
            dictHome = nil;
            [self search:nil];
        }else{
            self.labelHomeName.text = dictHome[@"NAME"];
            [self search:nil];
        }
    }
}


@end
