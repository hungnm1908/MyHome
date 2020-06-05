//
//  ListUserViewController.m
//  MyHome
//
//  Created by Macbook on 10/26/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListUserViewController.h"
#import "ListUserTableViewCell.h"
#import "InformationViewController.h"
#import "CreateUserViewController.h"

@interface ListUserViewController ()

@end

@implementation ListUserViewController {
    NSMutableArray *arrayUser;
    BOOL isSettup;
    
    NSString *userType;
    NSString *userStatus;
    
    int page;
    BOOL isLoadMore;
    
    ManaDropDownMenu *dropDownMKH;
    ManaDropDownMenu *dropDownBooking;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isAssignCheckIn) {
        self.navigationItem.title = @"Chia đơn dọn dẹp";
        self.btnAddUser.enabled = NO;
        self.btnAddUser.tintColor = UIColor.clearColor;
    }

    [self.tableView addSubview:self.refreshControl];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isSettup) {
        arrayUser = [NSMutableArray array];
        isSettup = YES;
        userType = @"";
        userStatus = @"";
        page = 1;
        [self settupViewSelect];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [dropDownMKH animateForClose];
    [dropDownBooking animateForClose];
}

- (void)settupViewSelect {
    if (self.isAssignCheckIn) {
        self.labelCheckIn.hidden = NO;
         userType = @"5";
    }else{
        self.labelCheckIn.hidden = YES;
        NSArray *arrayStatusBilling = @[@"- Tất cả -",@"Admin",@"Chủ nhà",@"Cộng tác viên",@"Supper Gold",@"Quản lý dọn dẹp",@"Check-in Check-out"];
        
        CGRect frameStatusBilling = self.viewUserType.frame;
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
    
    NSArray *arrayStatusBooking = @[@"- Tất cả -",@"Đang bị khóa",@"Đã kích hoạt"];
    
    CGRect frameStatusBooking = self.viewUserStatus.frame;
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
    
    [self getListUser];
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    if (dropDownMenu.tag == 0) {
        if (index != 0) {
            userType = [NSString stringWithFormat:@"%ld",(long)index-1];
        }else{
            userType = @"";
        }
    }else{
        if (index != 0) {
            userStatus = [NSString stringWithFormat:@"%ld",(long)index-1];
        }else{
            userStatus = @"";
        }
    }
    [self handleRefresh:nil];
}

- (IBAction)search:(id)sender {
    arrayUser = [NSMutableArray array];
    page = 1;
    [self.tableView reloadData];
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldFullName resignFirstResponder];
    [self getListUser];
}

- (void)handleRefresh : (id)sender {
    arrayUser = [NSMutableArray array];
    page = 1;
    [self.tableView reloadData];
    
    [self getListUser];
    [self.refreshControl endRefreshing];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListUserTableViewCell";
    ListUserTableViewCell *cell = (ListUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dictCustomer = [Utils converDictRemoveNullValue:arrayUser[indexPath.row]];
    
    cell.labelFullname.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"FULL_NAME"]];
    cell.labelUserName.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"USERID"]];
    cell.labelUserType.text = [self getNameUserType : [dictCustomer[@"USER_TYPE"] intValue]];
    cell.labelMobile.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"MOBILE"]];
    cell.labelDoB.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"DOB2"]];
    cell.labelEmail.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"EMAIL"]];
    cell.labelAddress.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"ADDRESS"]];

    if ([dictCustomer[@"STATE"] intValue] == 0) {
        cell.labelStatus.text = @"  Đang bị khóa  ";
        cell.labelStatus.backgroundColor = [UIColor redColor];
    }else{
        cell.labelStatus.text = @"  Đã kích hoạt  ";
        cell.labelStatus.backgroundColor = RGB_COLOR(0, 122, 255);
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayUser.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [dropDownMKH animateForClose];
    [dropDownBooking animateForClose];
    NSDictionary *dictCustomer = [Utils converDictRemoveNullValue:arrayUser[indexPath.row]];
    
    if (self.isAssignCheckIn) {
        [Utils alert:@"Thông báo" content:[NSString stringWithFormat:@"Bạn chắc chắn muốn chia đơn dọn dẹp cho nhân viên %@",dictCustomer[@"FULL_NAME"]] titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:self completion:^{
            [self chiaDonDonDep:dictCustomer];
        }];
    }else{
        [self performSelector:@selector(showInfoUser:) withObject:dictCustomer afterDelay:0.5];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    long lastRow = arrayUser.count-1;
    if (indexPath.row == lastRow && isLoadMore) {
        page++;
        [self getListUser];
    }
}

- (NSString *)getNameUserType : (int)userType {
    NSString *user = @"";
    switch (userType) {
        case 0:
        {
            user = @"Admin";
        }
            break;
            
        case 1:
        {
            user = @"Chủ nhà";
        }
            break;
            
        case 2:
        {
            user = @"Cộng tác viên";
        }
            break;
            
        case 3:
        {
            user = @"Supper Gold";
        }
            break;
            
        case 4:
        {
            user = @"Quản lý dọn dẹp";
        }
            break;
            
        case 5:
        {
            user = @"Check-in Check-out";
        }
            break;
            
        default:
            break;
    }
    
    return user;
}

- (IBAction)createNewUser:(id)sender {
    CreateUserViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateUserViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showInfoUser : (NSDictionary *)dictCustomer {
    InformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
    vc.userID = dictCustomer[@"USERID"];
    vc.isEdit = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark CallAPI

- (void)getListUser {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"USERID":@"",
                            @"MOBILE":self.textFieldPhoneNumber.text,
                            @"EMAIL":@"",
                            @"FULL_NAME":self.textFieldFullName.text,
                            @"USER_TYPE":userType,
                            @"STATE":userStatus,
                            @"ADDRESS":@"",
                            @"PAGE":[NSString stringWithFormat:@"%d",page],
                            @"NUMOFPAGE":@"50"
                            };
    
    [CallAPI callApiService:@"user/get_listuser" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayResult = dictData[@"INFO"];
        [self->arrayUser addObjectsFromArray:arrayResult];
        self->isLoadMore = arrayResult.count>=50;
        self.labelTotalUser.text = [NSString stringWithFormat:@"Tổng số người dùng: %lu",(unsigned long)self->arrayUser.count];
        [self.tableView reloadData];
    }];
}

- (void)chiaDonDonDep : (NSDictionary *)dictUser {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"CONTENT":self.dictBookService[@"CONTENT"],
                            @"USER_CHECKIN":dictUser[@"USERID"]
                            };
    
    [CallAPI callApiService:@"book/split_book_services" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateChiaDonChoCheckIn object:nil];
        [Utils alertError:@"Thông báo" content:@"Chia đơn dọn dẹp thành công" viewController:self completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
