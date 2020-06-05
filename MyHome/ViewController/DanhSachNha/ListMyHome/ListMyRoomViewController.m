//
//  ListMyRoomViewController.m
//  MyHome
//
//  Created by Macbook on 8/15/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListMyRoomViewController.h"
#import "ListMyRoomTableViewCell.h"
#import "MyRoomDetailViewController.h"
#import "BookingSelectDateViewController.h"
#import "InformationViewController.h"
#import "SettupDiscountViewController.h"

@interface ListMyRoomViewController ()

@end

@implementation ListMyRoomViewController {
    NSMutableArray *arrayMyRoom;
    NSArray *arrayAllRoom;
    NSDictionary *userInfo;
    BOOL isSettup;
    NSInteger statusRoom;
    ManaDropDownMenu *dropDownMKH;
    
    UITextField *textFieldSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    if ([userInfo[@"USER_TYPE"] intValue] == 0) {//admin
        self.btnCreate.enabled = NO;
        [self addSearch];
    }
    statusRoom = 0;
    [self getListMyRoom];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = RGB_COLOR(240, 240, 240);
    self.refreshControl.tintColor = RGB_COLOR(100, 100, 100);
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListMyRoom) name:kUpdateRoomInfor object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isSettup) {
            isSettup = YES;
            [self settupViewSelect];
    //        [self performSelector:@selector(settupViewSelect) withObject:nil afterDelay:1.0];
    }
    CGRect frameStatusBilling = self.viewStatusRoom.frame;
    frameStatusBilling.origin.x = frameStatusBilling.origin.x + 2;
    frameStatusBilling.origin.y = frameStatusBilling.origin.y + 3;
    frameStatusBilling.size.width = frameStatusBilling.size.width - 4;
    frameStatusBilling.size.height = frameStatusBilling.size.height - 6;
    
    dropDownMKH.frame = frameStatusBilling;
}

- (void)viewWillDisappear:(BOOL)animated {
    [dropDownMKH animateForClose];
}

- (void)addSearch {

}

- (void)settupViewSelect {
    NSArray *arrayStatusBilling = @[@"- Tất cả -",@"Chờ duyệt",@"Đã duyệt"];
    
    CGRect frameStatusBilling = self.viewStatusRoom.frame;
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
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    statusRoom = index;
    [self showListWithStatus:statusRoom];
}

- (void)showListWithStatus : (NSInteger)status {
    arrayMyRoom = [NSMutableArray array];
    switch (status) {
        case 0:
        {
            [arrayMyRoom addObjectsFromArray:arrayAllRoom];
        }
            break;
            
        case 1:
        {
            for (NSDictionary *dict in arrayAllRoom) {
                if ([dict[@"STATE"] intValue] == 6) {
                    [arrayMyRoom addObject:dict];
                }
            }
        }
            break;
            
        case 2:
        {
            for (NSDictionary *dict in arrayAllRoom) {
                if ([dict[@"STATE"] intValue] == 7) {
                    [arrayMyRoom addObject:dict];
                }
            }
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)handleRefresh : (id)sender {
    arrayMyRoom = [NSMutableArray array];
    [self.tableView reloadData];
    [self getListMyRoom];
    [self.refreshControl endRefreshing];
}

- (IBAction)createNewRoom:(id)sender {
    [dropDownMKH animateForClose];
    [self performSelector:@selector(createRoom) withObject:nil afterDelay:0.5];
}

- (void)createRoom {
    MyRoomDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRoomDetailViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isCreate = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListMyRoomTableViewCell";
    ListMyRoomTableViewCell *cell = (ListMyRoomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayMyRoom[indexPath.row]];
    
    NSString *link = [dict[@"COVER"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    link = [Utils convertStringUrl:link];
    link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
    [cell.imageAvatar sd_setImageWithURL:[NSURL URLWithString:link] placeholderImage:[UIImage imageNamed:@"image_default"]];
    
    cell.labelName.text = dict[@"NAME"];
    cell.labelMoney.text = [NSString stringWithFormat:@"%@ vnđ/đêm",[Utils strCurrency:dict[@"PRICE"]]];
    cell.labelAdd.text = dict[@"ADDRESS"];
    
    [cell.btnUpdate addTarget:self action:@selector(updateRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([dict[@"STATE"] intValue] == 7) {
        cell.labelStatus.text = [NSString stringWithFormat:@"  ĐÃ DUYỆT  "];
        cell.labelStatus.backgroundColor = RGB_COLOR(84, 125, 190);
    }else if ([dict[@"STATE"] intValue] == 6) {
        cell.labelStatus.text = [NSString stringWithFormat:@"  ĐANG CHỜ DUYỆT  "];
        cell.labelStatus.backgroundColor = RGB_COLOR(250, 171, 28);
    }else{
        cell.labelStatus.text = [NSString stringWithFormat:@"  CHỜ DUYỆT  "];
        cell.labelStatus.backgroundColor = RGB_COLOR(182, 204, 129);
    }
    
    if ([userInfo[@"USER_TYPE"] intValue] == 0) {//admin
        if ([dict[@"STATE"] intValue] == 7) {
            [cell.btnBooking setTitle:@"  HỦY DUYỆT NHÀ  " forState:UIControlStateNormal];
            cell.btnBooking.backgroundColor = RGB_COLOR(234, 56, 9);
            
            cell.btnUpdate.hidden = YES;
        }else if ([dict[@"STATE"] intValue] == 6) {
            [cell.btnBooking setTitle:@"  DUYỆT NHÀ  " forState:UIControlStateNormal];
            cell.btnBooking.backgroundColor = RGB_COLOR(141, 114, 175);
            
            cell.btnUpdate.hidden = NO;
        }else{
            [cell.btnBooking setTitle:@"  DUYỆT NHÀ  " forState:UIControlStateNormal];
            cell.btnBooking.backgroundColor = RGB_COLOR(141, 114, 175);
            
            cell.btnUpdate.hidden = NO;
        }
        
        [cell.btnBooking addTarget:self action:@selector(approvalRoom:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnBooking.hidden = NO;
        
        cell.labelChuNha.text = [NSString stringWithFormat:@"%@",dict[@"NAME_HOST"]];
    }else{
        [cell.btnBooking setTitle:@"  GIẢM GIÁ  " forState:UIControlStateNormal];
        cell.btnBooking.backgroundColor = RGB_COLOR(141, 114, 175);
        
        [cell.btnBooking addTarget:self action:@selector(bookingRoom:) forControlEvents:UIControlEventTouchUpInside];
//        cell.btnBooking.hidden = YES;
        cell.labelChuNha.text = @"";
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayMyRoom.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([userInfo[@"USER_TYPE"] intValue] == 0) {//admin
        [dropDownMKH animateForClose];
        NSDictionary *dict = [Utils converDictRemoveNullValue:arrayMyRoom[indexPath.row]];
        [self performSelector:@selector(showInfo:) withObject:dict afterDelay:0.5];
    }
}

- (void)showInfo : (NSDictionary *)dict {
    InformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
    vc.userID = dict[@"USER_ID"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateRoom : (id)sender {
    [dropDownMKH animateForClose];
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayMyRoom[hitIndex.row]];
    
    [self performSelector:@selector(showRoom:) withObject:dict afterDelay:0.5];
}

- (void)showRoom : (NSDictionary *)dict {
    MyRoomDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRoomDetailViewController"];
    vc.isCreate = NO;
    vc.dictRoom = dict;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bookingRoom : (id)sender {
    [dropDownMKH animateForClose];
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayMyRoom[hitIndex.row]];
    
    SettupDiscountViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettupDiscountViewController"];
    vc.dictHome = dict;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)approvalRoom : (id)sender {
    [dropDownMKH animateForClose];
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayMyRoom[hitIndex.row]];
    
    if ([dict[@"STATE"] intValue] == 7) {
        [Utils alert:@"Thông báo" content:@"Bạn chắc chắn muốn hủy duyệt nhà này ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
            [self updateStateRoom:@"6" :dict[@"GENLINK"]];
        }];
    }else if ([dict[@"STATE"] intValue] == 6) {
        [Utils alert:@"Thông báo" content:@"Bạn chắc chắn muốn duyệt nhà này ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
            [self updateStateRoom:@"7" :dict[@"GENLINK"]];
        }];
    }else{
        
    }
}

#pragma mark CallAPI

- (void)getListMyRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"OPT":@""
                            };
    
    [CallAPI callApiService:@"room/get_mylist_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayAllRoom = dictData[@"INFO"];
        [self showListWithStatus:self->statusRoom];
        [self.tableView reloadData];
    }];
}

//duyet nha danh cho admin
- (void)updateStateRoom : (NSString *)state : (NSString *)genlink {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK":genlink,
                            @"STATE":state
                            };
    
    [CallAPI callApiService:@"room/update_state_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [self getListMyRoom];
    }];
}

@end
