//
//  ListBookRoomViewController.m
//  MyHome
//
//  Created by Macbook on 8/15/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListBookRoomViewController.h"
#import "ListBookRoomTableViewCell.h"
#import "BookingPaymentViewController.h"
#import "InformationViewController.h"
#import "BookCleanServiceViewController.h"
#import "ImageCleanHomeViewController.h"

@interface ListBookRoomViewController ()

@end

@implementation ListBookRoomViewController {
    NSDictionary *userInfo;
    NSMutableArray *arrayBookRoomIsBilling;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayBookRoomIsBilling = [NSMutableArray array];
    for (NSDictionary *dict in self.arrayBookRoom) {
        if ([dict[@"BILLING_STATUS"] intValue] != 0) {
            [arrayBookRoomIsBilling addObject:dict];
        }
    }
    [self.tableView reloadData];

    userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
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
    static NSString *cellIdentifier = @"ListBookRoomTableViewCell";
    ListBookRoomTableViewCell *cell = (ListBookRoomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookRoomIsBilling[indexPath.row]];
    
    cell.labelNameRoom.text = [NSString stringWithFormat:@"%@ ",dict[@"ROOM_NAME"]];
    cell.labelNameGuest.text = [NSString stringWithFormat:@"%@ ",dict[@"BOOK_NAME"]];
    cell.labelDateBook.text = [NSString stringWithFormat:@"%@ - %@",dict[@"START_TIME"],dict[@"END_TIME"]];
    cell.labelTimeBook.text = [self getDateFromDate:dict[@"BOOKING_TIME"]];
    
    cell.iconLock.hidden = [Utils lenghtText:dict[@"CONTENT"]] != 0;
    cell.btnStatus.hidden = [Utils lenghtText:dict[@"CONTENT"]] != 0;
    [cell.btnStatus addTarget:self action:@selector(unlockRoom:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnShowImageClean addTarget:self action:@selector(showImageHome:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([dict[@"IS_BOOK_SERVICES"] intValue] == 0) {
        cell.btnShowImageClean.hidden = YES;
        cell.btnCleanRoom.enabled = YES;
        [cell.btnCleanRoom addTarget:self action:@selector(processService:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCleanRoom setTitle:@"  ĐẶT DỌN NHÀ  " forState:UIControlStateNormal];
        cell.btnCleanRoom.backgroundColor = RGB_COLOR(240, 10, 10);
        
        cell.labelTrangThaiDichVu.text = @"Chưa đặt dịch vụ";
        cell.labelTrangThaiDichVu.textColor = RGB_COLOR(240, 10, 10);
        
        cell.labelTrangThaiThanhToanDichVu.text = @"";
    }else {
        cell.btnShowImageClean.hidden = NO;
        
        if ([dict[@"BILLING_STATUS_SERVICE"] intValue] == 0) {
            cell.btnCleanRoom.enabled = YES;
            [cell.btnCleanRoom addTarget:self action:@selector(processService:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnCleanRoom setTitle:@"  THANH TOÁN DỊCH VỤ " forState:UIControlStateNormal];
            cell.btnCleanRoom.backgroundColor = RGB_COLOR(240, 10, 10);
            
            cell.labelTrangThaiDichVu.textColor = RGB_COLOR(240, 10, 10);
            cell.labelTrangThaiThanhToanDichVu.textColor = RGB_COLOR(240, 10, 10);
            
            if ([dict[@"KIND_OF_PAID"] intValue] == 0) {
                cell.btnCleanRoom.hidden = NO;
                cell.labelTrangThaiDichVu.text = @"Đã đặt dịch vụ";
                cell.labelTrangThaiThanhToanDichVu.text = @"Chưa thanh toán";
            }else{
                cell.btnCleanRoom.hidden = NO;
                cell.labelTrangThaiDichVu.text = @"Đã đặt dịch vụ";
                cell.labelTrangThaiThanhToanDichVu.text = @"Thanh toán trả sau";
            }
        }else{
            cell.btnCleanRoom.hidden = YES;
            cell.labelTrangThaiDichVu.text = @"Đã đặt dịch vụ";
            cell.labelTrangThaiThanhToanDichVu.text = @"Đã thanh toán";
            cell.labelTrangThaiDichVu.textColor = RGB_COLOR(25, 200, 50);
            cell.labelTrangThaiThanhToanDichVu.textColor = RGB_COLOR(25, 200, 50);
        }
    }
    
    cell.labelTrangThaiNha.text = [NSString stringWithFormat:@"%@",dict[@"BOOK_STATUS_NAME"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayBookRoomIsBilling.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookRoomIsBilling[indexPath.row]];
    
    if ([Utils lenghtText:dict[@"CONTENT"]] > 0) {
        InformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
        vc.userID = dict[@"USERID"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)processService: (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookRoomIsBilling[hitIndex.row]];
    
    if ([dict[@"IS_BOOK_SERVICES"] intValue] == 0) {
        [self cleanRoom:dict];
    }else {
        if ([dict[@"STATUS_SERVICE"] intValue] == 0) {
            [self payCleanRoom:dict];
        }else{
            
        }
    }
}

- (void)showImageHome : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayBookRoomIsBilling[hitIndex.row]];
    
    ImageCleanHomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageCleanHomeViewController"];
    vc.idDictBookClean = [NSString stringWithFormat:@"%@",dict[@"ID_BOOK_SV"]];
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

#pragma mark CallAPI

- (void)unlockRoom : (id)sender {
    [Utils alert:@"Mở khóa nhà" content:@"Bạn chắc chắn muốn mở khóa nhà ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        NSDictionary *dict = [Utils converDictRemoveNullValue:self->arrayBookRoomIsBilling[hitIndex.row]];
        
        NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                @"ID_BOOKROOM":[NSString stringWithFormat:@"%@",dict[@"ID"]],
                                @"BOOKING_STATUS":@"3"
        };
        
        [CallAPI callApiService:@"book/change_booking" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
            [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBookingRoomStatus object:nil];
            }];
        }];
    }];
}

- (void)cleanRoom : (NSDictionary *)dict {
    NSDate *enDate = [Utils getDateFromStringDate:dict[@"END_TIME"]];
    if ([enDate timeIntervalSinceDate:[NSDate date]] <= 0) {
        [Utils alertError:@"Thông báo" content:@"Không thể đặt dịch vụ vì đã qua ngày check out" viewController:nil completion:^{
            
        }];
    }else{
//        [Utils alertWithNoteTitle:@"Dọn nhà" message:@"Bạn chắc chắn muốn đặt dịch vụ dọn nhà ?\n(vui lòng để lại lời nhắn với nhân viên dọn dẹp)" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completeBlock:^(NSString *content) {
//            NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
//                                    @"GENLINK":dict[@"GENLINK"],
//                                    @"CHECKIN":dict[@"START_TIME"],
//                                    @"CHECKOUT":dict[@"END_TIME"],
//                                    @"ID_BOOKROOM":dict[@"ID"],
//                                    @"NOTE":content
//                                    };
//
//            [CallAPI callApiService:@"book/booking_services2" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
//                [Utils alertWithCancelProcess:@"Thông báo" content:@"Đặt dịch vụ dọn nhà thành công. Vui lòng chọn hình thức thanh toán" titleOK:@"Trả trước" titleCancel:@"Trả sau" viewController:nil completion:^{
//                    BookingPaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingPaymentViewController"];
//                    vc.isPaymentClean = YES;
//                    vc.totalPrice = [dictData[@"PRICE"] longLongValue];
//                    vc.content = dictData[@"CONTENT"];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:vc animated:YES];
//                } cancel:^{
//
//                }];
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBookingRoomStatus object:nil];
//            }];
//        }];
        
        NSDictionary *paramCleanRoom = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                                            @"GENLINK":dict[@"GENLINK"],
                                            @"CHECKIN":dict[@"START_TIME"],
                                            @"CHECKOUT":dict[@"END_TIME"],
                                            @"ID_BOOKROOM":dict[@"ID"]
                                            };
        
        BookCleanServiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookCleanServiceViewController"];
        vc.dictParam = paramCleanRoom;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)payCleanRoom : (NSDictionary *)dict {
    [Utils alert:@"Thanh toán dịch vụ" content:@"Đặt dịch vụ dọn nhà thành công. Vui lòng thanh toán bằng cách chuyển khoản theo các thông tin sau." titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        BookingPaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingPaymentViewController"];
        vc.isPaymentClean = YES;
        vc.totalPrice = [dict[@"MONEY_SERVICES"] longLongValue];
        vc.content = dict[@"CONTENT_SERVICES"];
        vc.dictBookClean = dict;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
