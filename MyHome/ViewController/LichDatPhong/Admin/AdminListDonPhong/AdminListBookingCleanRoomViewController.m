//
//  AdminListBookingCleanRoomViewController.m
//  MyHome
//
//  Created by Macbook on 10/24/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "AdminListBookingCleanRoomViewController.h"
#import "CommonTableViewController.h"
#import "AdminListBookingCleanRoomTableViewCell.h"
#import "HomeDetailViewController.h"
#import "InformationViewController.h"
#import "ListUserViewController.h"

@interface AdminListBookingCleanRoomViewController ()

@end

@implementation AdminListBookingCleanRoomViewController {
    NSDictionary *dictHome;
    NSMutableArray *arrayMyHomes;
    BOOL isSettup;
    
    NSMutableArray *arrayBookService;
    NSMutableArray *arrayBookServiceFillter;
    
    BOOL isFillter;
    
    NSDictionary *dictBilling;
    NSDictionary *dictBooking;
    
    NSDictionary *userInfo;
    int userType;
    
    ManaDropDownMenu *dropDownStatusBilling;
    ManaDropDownMenu *dropDownStatusBooking;
    
    NSArray *arrayStatusBilling;
    NSArray *arrayStatusBooking;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    userType = [userInfo[@"USER_TYPE"] intValue];
    if (userType == 4) {
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kMyHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:kUpdateChiaDonChoCheckIn object:nil];
    
    self.textFieldStartDate.text = [Utils getDateFromDate:[Utils getFirstDayOfThisMonth]];
    self.textFieldEndDate.text = [Utils getDateFromDate:[Utils getLastDayOfMonth:5]];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isSettup) {
        isSettup = YES;
        [self performSelector:@selector(settupViewSelect) withObject:nil afterDelay:0.5];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [dropDownStatusBilling animateForClose];
    [dropDownStatusBooking animateForClose];
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
        [self getListBookService];
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
    arrayStatusBilling = @[@{@"name":@"Chưa thanh toán",
                             @"id":@"0",
                             @"type":@"0"
                            },
                           @{@"name":@"Thanh toán sau",
                             @"id":@"0",
                             @"type":@"1"
                            },
                           @{@"name":@"Đã thanh toán",
                             @"id":@"1"
                            }
                            ];
    
    NSArray *arrayStatusBillingName = @[@"- Tất cả -",@"Chưa thanh toán",@"Thanh toán sau",@"Đã thanh toán"];
    
    CGRect frameStatusBilling = self.viewStatusBilling.frame;
    frameStatusBilling.origin.x = frameStatusBilling.origin.x + 2;
    frameStatusBilling.origin.y = frameStatusBilling.origin.y + 3;
    frameStatusBilling.size.width = frameStatusBilling.size.width - 4;
    frameStatusBilling.size.height = frameStatusBilling.size.height - 6;
    
    dropDownStatusBilling = [[ManaDropDownMenu alloc] initWithFrame:frameStatusBilling title:arrayStatusBillingName[0]];
    dropDownStatusBilling.delegate = self;
    dropDownStatusBilling.numberOfRows = arrayStatusBillingName.count;
    dropDownStatusBilling.textOfRows = arrayStatusBillingName;
    dropDownStatusBilling.seperatorColor = RGB_COLOR(75, 109, 179);
    dropDownStatusBilling.inactiveColor = RGB_COLOR(75, 109, 179);
    dropDownStatusBilling.tag = 0;
    [self.view addSubview:dropDownStatusBilling];
    
    arrayStatusBooking = @[@{@"name":@"Đang chờ",
                             @"id":@"0"
                            },
                           @{@"name":@"Check-In",
                             @"id":@"1"
                            },
                           @{@"name":@"Check-Out",
                             @"id":@"2"
                            },
                           @{@"name":@"Hoàn thành",
                            @"id":@"4"
                           }
                            ];
    
    NSArray *arrayStatusBookingName = @[@"- Tất cả -",@"Đang chờ",@"Check-In",@"Check-Out",@"Hoàn thành"];
    
    CGRect frameStatusBooking = self.viewStatusBooking.frame;
    frameStatusBooking.origin.x = frameStatusBooking.origin.x + 2;
    frameStatusBooking.origin.y = frameStatusBooking.origin.y + 3;
    frameStatusBooking.size.width = frameStatusBooking.size.width - 4;
    frameStatusBooking.size.height = frameStatusBooking.size.height - 6;
    
    dropDownStatusBooking = [[ManaDropDownMenu alloc] initWithFrame:frameStatusBooking title:arrayStatusBookingName[0]];
    dropDownStatusBooking.delegate = self;
    dropDownStatusBooking.numberOfRows = arrayStatusBookingName.count;
    dropDownStatusBooking.textOfRows = arrayStatusBookingName;
    dropDownStatusBooking.seperatorColor = RGB_COLOR(75, 109, 179);
    dropDownStatusBooking.inactiveColor = RGB_COLOR(75, 109, 179);
    dropDownStatusBooking.tag = 1;
    [self.view addSubview:dropDownStatusBooking];
    
    [self search:nil];
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    if (dropDownMenu.tag == 0) {
        if (index != 0) {
            dictBilling = [arrayStatusBilling objectAtIndex:index-1];
        }else{
            dictBilling = nil;
        }
    }else{
        if (index != 0) {
            dictBooking = [arrayStatusBooking objectAtIndex:index-1];
        }else{
            dictBooking = nil;
        }
    }
}

- (void)createArrayFillter {
    
}

- (void)showInfoHome : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookService[hitIndex.row]];
    
    HomeDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetailViewController"];
    vc.dictHome = dict;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showInfoUser : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookService[hitIndex.row]];
    
    InformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
    vc.userID = dict[@"USERID"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AdminListBookingCleanRoomTableViewCell";
    AdminListBookingCleanRoomTableViewCell *cell = (AdminListBookingCleanRoomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookService[indexPath.row]];
    
    cell.labelNameRoom.text = [NSString stringWithFormat:@"%@ ",dict[@"ROOM_NAME"]];
    cell.labelNameBook.text = [NSString stringWithFormat:@"%@ ",dict[@"FULL_NAME"]];
    cell.labelCheckIn.text = [[[self getDateFromDate:dict[@"START_TIME"]] componentsSeparatedByString:@" - "] firstObject];
    cell.labelCheckOut.text = [[[self getDateFromDate:dict[@"END_TIME"]]  componentsSeparatedByString:@" - "] firstObject];
    
    cell.labelGuyUpdate.text = [NSString stringWithFormat:@"%@ ",dict[@"NAME_EDIT"]];
    cell.labelTimeUpdate.text = [self getDateFromDate:dict[@"UPDATE_TIME"]];
    
    cell.labelStatusService.text = [NSString stringWithFormat:@"%@ ",dict[@"STATE_NAME"]];
    cell.labelStatusService.textColor = [self getColorStatusService:[dict[@"STATE"] intValue]];
    
    cell.labelStatusBilling.text = [self getBillingStatusName:dict];
    cell.labelStatusBilling.textColor = [self getColorStatusBilling:dict];
    
    cell.labelContent.text = [NSString stringWithFormat:@"%@ ",dict[@"CONTENT"]];
    cell.labelNote.text = [NSString stringWithFormat:@"%@",dict[@"NOTES"]];
    
    [cell.btnUpdateStatusBill addTarget:self action:@selector(updateStatusBill:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnUpdateStatusService addTarget:self action:@selector(updateStatusService:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAssign addTarget:self action:@selector(assignCheckIn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (userType == 0) {
        if ([dict[@"BILLING_STATUS"] intValue] == 0) {
            cell.btnUpdateStatusBill.hidden = NO;
        }else{
            cell.btnUpdateStatusBill.hidden = YES;
        }
    }else{
        cell.btnUpdateStatusBill.hidden = YES;
    }
    
    cell.btnAssign.hidden = [self isHidenBtnDivide:dict];
    
    if ([dict[@"STATE"] intValue] != 4) {
        cell.btnUpdateStatusService.hidden = NO;
    }else{
        cell.btnUpdateStatusService.hidden = YES;
    }
    
    [cell.btnHomeBook addTarget:self action:@selector(showInfoHome:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnUserBook addTarget:self action:@selector(showInfoUser:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayBookService.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)isHidenBtnDivide : (NSDictionary *)dict {
    BOOL isHidden = YES;
    
    if (userType == 0 || userType == 4) {
        if ([dict[@"STATE"] intValue] == 0) {
            NSString *idCheckIn = [NSString stringWithFormat:@"%@",dict[@"ID_CHECKIN"]];
            if (idCheckIn.length > 0) {
                isHidden = YES;
            }else{
                isHidden = NO;
            }
        }else{
            isHidden = YES;
        }
    }else{
        isHidden = YES;
    }
    
    return isHidden;
}

- (UIColor *)getColorStatusService: (int)trangThaiPhong {
    UIColor *color = [UIColor blackColor];
    switch (trangThaiPhong) {
        case 0://Chờ xác nhận
        {
            color = RGB_COLOR(240, 10, 10);
        }
            break;
            
        case 1://Check-in
        {
            color = RGB_COLOR(75, 109, 179);
        }
            break;
            
        case 2://Check-out
        {
            color = RGB_COLOR(75, 109, 179);
        }
            break;
            
        case 3://Đang dọn dẹp
        {
            color = RGB_COLOR(75, 109, 179);
        }
            break;
            
        case 4:
        {
            color = RGB_COLOR(25, 200, 50);
        }
            break;
            
        default:
            break;
    }
    return color;
}

- (UIColor *)getColorStatusBilling : (NSDictionary *)dict {
    int trangThaiThanhToan = [dict[@"BILLING_STATUS"] intValue];
    UIColor *color = [UIColor blackColor];
    
    if (trangThaiThanhToan == 0) {
        if ([dict[@"KIND_OF_PAID"] intValue] == 0) {
            color = RGB_COLOR(240, 10, 10);
        }else{
            color = RGB_COLOR(250, 171, 28);
        }
    }else{
        color = RGB_COLOR(25, 200, 50);
    }
    return color;
}

- (NSString *)getBillingStatusName : (NSDictionary *)dict {
    int status = [dict[@"BILLING_STATUS"] intValue];
    NSString *billing = @"";
    if (status == 0) {
        if ([dict[@"KIND_OF_PAID"] intValue] == 0) {
            billing = @"Chưa thanh toán";
        }else{
            billing = @"Thanh toán trả sau";
        }
    }else{
        billing = @"Đã thanh toán";
    }
    
    return billing;
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
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookService[hitIndex.row]];
    
    [self selectStatusBill:dict];
}

- (void)updateStatusService : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookService[hitIndex.row]];
    
    [self selectStatusService:dict];
}

- (void)selectStatusService : (NSDictionary *)dict {
    UIAlertController *actionSheet = [UIAlertController
                                      alertControllerWithTitle:@"CẬP NHẬT TRẠNG THÁI DỊCH VỤ"
                                      message:@""
                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *btnBook0 = [UIAlertAction
                                     actionWithTitle:@"Chờ Check-In"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBillAndService:@"" statusService:@"0" idBook:dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnBook0];
    
    UIAlertAction *btnBook1 = [UIAlertAction
                                     actionWithTitle:@"Check-In"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBillAndService:@"" statusService:@"1" idBook:dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnBook1];
    
    UIAlertAction *btnBook2 = [UIAlertAction
                                     actionWithTitle:@"Check-Out"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBillAndService:@"" statusService:@"2" idBook:dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnBook2];
    
//    UIAlertAction *btnBook3 = [UIAlertAction
//                                     actionWithTitle:@"Đang dọn dẹp"
//                                     style:UIAlertActionStyleDefault
//                                     handler:^(UIAlertAction *action) {
//                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
//                                        [self changeStatusBillAndService:@"" statusService:@"3" idBook:dict[@"ID"]];
//                                    }];
//    [actionSheet addAction:btnBook3];
    
    UIAlertAction *btnBook4 = [UIAlertAction
                                     actionWithTitle:@"Hoàn thành"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBillAndService:@"" statusService:@"4" idBook:dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnBook4];
    
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

- (void)selectStatusBill : (NSDictionary *)dict {
    UIAlertController *actionSheet = [UIAlertController
                                      alertControllerWithTitle:@"CẬP NHẬT TRẠNG THÁI THANH TOÁN"
                                      message:@""
                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *btnBookSuccess = [UIAlertAction
                                     actionWithTitle:@"Chưa thanh toán"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBillAndService:@"0" statusService:@"" idBook:dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnBookSuccess];
    
    UIAlertAction *btnBookCancel = [UIAlertAction
                                     actionWithTitle:@"Đã thanh toán"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action) {
                                        [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeStatusBillAndService:@"1" statusService:@"" idBook:dict[@"ID"]];
                                    }];
    [actionSheet addAction:btnBookCancel];
    
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

- (void)createDropDownHome : (NSArray *)arrayBookReport {
    arrayMyHomes = [NSMutableArray array];
    
    for (NSDictionary *dict in arrayBookReport) {
        NSDictionary *home = @{@"NAME":dict[@"ROOM_NAME"],@"GENLINK":dict[@"GENLINK"]};
        if (![arrayMyHomes containsObject:home]) {
            [arrayMyHomes addObject:home];
        }
    }
}

- (void)assignCheckIn : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookService[hitIndex.row]];
    
    ListUserViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListUserViewController"];
    vc.dictBookService = dict;
    vc.isAssignCheckIn = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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


- (void)getListBookService {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK":dictHome?dictHome[@"GENLINK"] : @"",
                            @"CHECKIN":self.textFieldStartDate.text,
                            @"CHECKOUT":self.textFieldEndDate.text,
                            @"BOOKING_STATUS":dictBooking?dictBooking[@"id"]:@"",
                            @"BILLING_STATUS":dictBilling?dictBilling[@"id"]:@""
                            };
    
    [CallAPI callApiService:@"book/get_booking_services2" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *array = dictData[@"INFO"];
        
        NSMutableArray *arrayResult = [NSMutableArray array];
        if (self->dictBilling) {
            for (NSDictionary *dict in array) {
                int status = [dict[@"KIND_OF_PAID"] intValue];
                int type = [self->dictBilling[@"type"] intValue];
                
                if (status == type) {
                    [arrayResult addObject:dict];
                }
            }
        }else{
            arrayResult = [NSMutableArray arrayWithArray:array];
        }
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
        int userType = [userInfo[@"USER_TYPE"] intValue];
        switch (userType) {
            case 0://admin
            {
                self->arrayBookService = [NSMutableArray arrayWithArray:arrayResult];
            }
                break;
                
            case 1://chủ nhà
            {
                
            }
                break;
                
            case 2://CTV
            {
                
            }
                break;
                
            case 3://gold
            {
                
            }
                break;
                
            case 4://dọn dẹp
            {
//                self->arrayBookService = [NSMutableArray array];
//                for (NSDictionary *dict in arrayResult) {
//                    if ([dict[@"BILLING_STATUS"] intValue] != 0) {
//                        [self->arrayBookService addObject:dict];
//                    }
//                }
                
                self->arrayBookService = [NSMutableArray arrayWithArray:arrayResult];
                [self createDropDownHome:self->arrayBookService];
            }
                break;
                
            case 5://dọn dẹp
                        {
            //                self->arrayBookService = [NSMutableArray array];
            //                for (NSDictionary *dict in arrayResult) {
            //                    if ([dict[@"BILLING_STATUS"] intValue] != 0) {
            //                        [self->arrayBookService addObject:dict];
            //                    }
            //                }
                            
                            self->arrayBookService = [NSMutableArray arrayWithArray:arrayResult];
                            [self createDropDownHome:self->arrayBookService];
                        }
                            break;
                
            default:
            {
                
            }
                break;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)changeStatusBillAndService : (NSString *)statusBill statusService : (NSString *)statusService idBook : (NSString *)idBook {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOK":idBook,
                            @"STATE":statusService,
                            @"BILLING_STATUS":statusBill
                            };
    
    [CallAPI callApiService:@"book/change_booking_services" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [self getListBookService];
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
    }else if ([notif.name isEqualToString:kUpdateChiaDonChoCheckIn]) {
        [self search:nil];
    }
}

@end
