//
//  ListUserViewController.m
//  MyHome
//
//  Created by Macbook on 10/26/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListUserViewController.h"
#import "ListUserTableViewCell.h"

@interface ListUserViewController ()

@end

@implementation ListUserViewController {
    NSMutableArray *arrayUser;
    BOOL isSettup;
    
    NSString *userType;
    NSString *userStatus;
    
    int page;
    BOOL isLoadMore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!isSettup) {
        arrayUser = [NSMutableArray array];
        isSettup = YES;
        userType = @"";
        userStatus = @"";
        page = 1;
        [self settupViewSelect];
    }
}

- (void)settupViewSelect {
    NSArray *arrayStatusBilling = @[@"- Tất cả -",@"Admin",@"Chủ nhà",@"Dịch vụ",@"Supper Gold"];
    
    CGRect frameStatusBilling = self.viewUserType.frame;
    frameStatusBilling.origin.x = frameStatusBilling.origin.x + 2;
    frameStatusBilling.origin.y = frameStatusBilling.origin.y + 3;
    frameStatusBilling.size.width = frameStatusBilling.size.width - 4;
    frameStatusBilling.size.height = frameStatusBilling.size.height - 6;
    
    ManaDropDownMenu *dropDownMKH = [[ManaDropDownMenu alloc] initWithFrame:frameStatusBilling title:arrayStatusBilling[0]];
    dropDownMKH.delegate = self;
    dropDownMKH.numberOfRows = arrayStatusBilling.count;
    dropDownMKH.textOfRows = arrayStatusBilling;
    dropDownMKH.seperatorColor = RGB_COLOR(75, 109, 179);
    dropDownMKH.inactiveColor = RGB_COLOR(75, 109, 179);
    dropDownMKH.tag = 0;
    [self.view addSubview:dropDownMKH];
    
    NSArray *arrayStatusBooking = @[@"- Tất cả -",@"Đang bị khóa",@"Đã kích hoạt"];
    
    CGRect frameStatusBooking = self.viewUserStatus.frame;
    frameStatusBooking.origin.x = frameStatusBooking.origin.x + 2;
    frameStatusBooking.origin.y = frameStatusBooking.origin.y + 3;
    frameStatusBooking.size.width = frameStatusBooking.size.width - 4;
    frameStatusBooking.size.height = frameStatusBooking.size.height - 6;
    
    ManaDropDownMenu *dropDownBooking = [[ManaDropDownMenu alloc] initWithFrame:frameStatusBooking title:arrayStatusBooking[0]];
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
    [self getListUser];
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
            user = @"Dịch vụ";
        }
            break;
            
        case 3:
        {
            user = @"Supper Gold";
        }
            break;
            
        default:
            break;
    }
    
    return user;
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
                            @"NUMOFPAGE":@"10"
                            };
    
    [CallAPI callApiService:@"user/get_listuser" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayResult = dictData[@"INFO"];
        [self->arrayUser addObjectsFromArray:arrayResult];
        self->isLoadMore = arrayResult.count>=10;
        [self.tableView reloadData];
    }];
}

@end
