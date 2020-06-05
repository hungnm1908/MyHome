//
//  ListBookOrtherViewController.m
//  MyHome
//
//  Created by Macbook on 11/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListBookOrtherViewController.h"
#import "CTVListBookRoomTableViewCell.h"
#import "BookingPaymentViewController.h"
#import "CommonTableViewController.h"

@interface ListBookOrtherViewController ()

@end

@implementation ListBookOrtherViewController {
    NSDictionary *userInfo;
    NSMutableArray *arrayBookRoom;
    NSMutableArray *arrayHomes;
    NSDictionary *dictHome;
    NSArray *arrayMyHomes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textFieldDateStart.text = [Utils getDateFromDate:[Utils getFirstDayOfThisMonth]];
    self.textFieldDateEnd.text = [Utils getDateFromDate:[Utils getLastDayOfMonth:5]];
    
    userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    
    [self getListHome];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:@"kMyHome" object:nil];
}

- (IBAction)selectStartDate:(id)sender {
    [self.textFieldDateStart becomeFirstResponder];
}

- (IBAction)selectEndDate:(id)sender {
    [self.textFieldDateEnd becomeFirstResponder];
}

- (IBAction)selectHome:(id)sender {
    CommonTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonTableViewController"];
    vc.arrayItem = arrayHomes;
    vc.typeView = kMyHome;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)search:(id)sender {
    [self.textFieldDateStart resignFirstResponder];
    [self.textFieldDateEnd resignFirstResponder];
    if ([self isEnoughInfo]) {
        [self getListBookRoom];
    }
}

- (BOOL)isEnoughInfo {
    BOOL isOK = YES;
    
    if (![Utils checkFromDate:self.textFieldDateStart.text toDate:self.textFieldDateEnd.text view:self]) {
        isOK = NO;
    }
    
    return isOK;
}

- (void)createDropDownHome : (NSArray *)arrayBookReport {
    arrayHomes = [NSMutableArray array];
    
    for (NSDictionary *dict in arrayBookReport) {
        NSDictionary *home = @{@"NAME":dict[@"ROOM_NAME"],@"GENLINK":dict[@"GENLINK"]};
        if (![arrayHomes containsObject:home]) {
            [arrayHomes addObject:home];
        }
    }
    
    if (arrayBookReport.count > 0) {
        self.labelNotice.hidden = YES;
    }else{
        self.labelNotice.hidden = NO;
    }
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

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CTVListBookRoomTableViewCell";
    CTVListBookRoomTableViewCell *cell = (CTVListBookRoomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    if ([dict[@"BILLING_STATUS"] intValue] == 0) {
        cell.viewThanhToan.hidden = NO;
        cell.heightViewThanhToan.constant = 64;
    }else{
        cell.viewThanhToan.hidden = YES;
        cell.heightViewThanhToan.constant = 0;
    }
    
    [cell.btnThanhToan addTarget:self action:@selector(payBookingRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayBookRoom.count;
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

- (void)payBookingRoom : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookRoom[hitIndex.row]];
    [Utils alert:@"Thanh toán tiền thuê nhà" content:@"Vui lòng thanh toán bằng cách chuyển khoản theo các thông tin sau." titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        BookingPaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingPaymentViewController"];
        vc.isPaymentClean = NO;
        vc.totalPrice = [dict[@"BOOKING_PRICE"] longLongValue];
        vc.content = dict[@"CONTENT"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (BOOL)isMyHome : (NSDictionary *)dict {
    NSMutableArray *arrayMyGenlink = [NSMutableArray array];
    for (NSDictionary *dict in arrayMyHomes) {
        [arrayMyGenlink addObject:dict[@"GENLINK"]];
    }
    
    if ([arrayMyGenlink containsObject:dict[@"GENLINK"]]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark CallAPI

- (void)getListHome {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"OPT":@""
                            };
    
    [CallAPI callApiService:@"room/get_mylist_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayMyHomes = dictData[@"INFO"];
        [self getListBookRoom];
    }];
}

- (void)getListBookRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOKROOM":@"",
                            @"ROOM_NAME":@"",
                            @"BOOKING_NAME":@"",
                            @"START_TIME":self.textFieldDateStart.text,
                            @"END_TIME":self.textFieldDateEnd.text,
                            @"BILLING_STATUS":@"",
                            @"BOOKING_STATUS":@"",
                            @"GENLINK":dictHome ? dictHome[@"GENLINK"] : @""
                            };
    
    [CallAPI callApiService:@"book/list_bookroom" dictParam:param isGetError:YES viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayBook = dictData[@"INFO"];
        
        self->arrayBookRoom = [NSMutableArray array];
        for (NSDictionary *dict in arrayBook) {
            if (![self isMyHome:dict]) {
                [self->arrayBookRoom addObject:dict];
            }
        }
        [self createDropDownHome:self->arrayBookRoom];
        [self.tableView reloadData];
    }];
}

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"kMyHome"]) {
        dictHome = notif.object;
        if (dictHome.allKeys.count == 0) {
            self.labelHomeName.text = @"- Tất cả -";
            dictHome = nil;
        }else{
            self.labelHomeName.text = dictHome[@"NAME"];
        }
        
        [self search:nil];
    }else if ([notif.name isEqualToString:kUpdateBookingRoomStatus]) {
        [self getListBookRoom];
    }
}

@end
