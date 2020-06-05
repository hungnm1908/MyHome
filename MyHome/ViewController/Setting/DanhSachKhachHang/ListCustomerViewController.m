//
//  ListCustomerViewController.m
//  MyHome
//
//  Created by Macbook on 9/17/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListCustomerViewController.h"
#import "ListCustomerTableViewCell.h"
#import "DetailCustomerViewController.h"

@interface ListCustomerViewController ()

@end

@implementation ListCustomerViewController {
    NSArray *arrayCustomer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getListCustomer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getListCustomer) name:kUpdateCustomerInfo object:nil];
}

- (IBAction)createNewCustomer:(id)sender {
    DetailCustomerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCustomerViewController"];
    vc.isCreate = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListCustomerTableViewCell";
    ListCustomerTableViewCell *cell = (ListCustomerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dictCustomer = [Utils converDictRemoveNullValue:arrayCustomer[indexPath.row]];
    
    cell.labelName.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"NAME"]];
    cell.labelPhoneMunber.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"MOBILE"]];
    cell.labelEmail.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"EMAIL"]];
    cell.labelAdress.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"ADDRESS"]];
    cell.labelCMT.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"CMT"]];
    cell.labelTP.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"PROVINCE_NAME"]];
    cell.labelDoB.text = [NSString stringWithFormat:@"%@ ",dictCustomer[@"DOB"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayCustomer.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCustomerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCustomerViewController"];
    vc.dictCustomer = [Utils converDictRemoveNullValue:arrayCustomer[indexPath.row]];
    vc.isCreate = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Utils alert:@"Xóa Khách Hàng" content:@"Bạn chắc chắn muốn xóa khách hàng này ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:self completion:^{
            [self deleteCustomer:self->arrayCustomer[indexPath.row]];
        }];
    }
}

#pragma mark CallAPI

- (void)getListCustomer {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"NAME":@"",
                            @"CMT":@"",
                            @"MOBILE":@"",
                            @"EMAIL":@"",
                            @"ID_PROVINCE":@""
                            };
    
    [CallAPI callApiService:@"contact/get_contact" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayCustomer = dictData[@"INFO"];
        [self.tableView reloadData];
    }];
}

- (void)deleteCustomer : (NSDictionary *)dictCustomer {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID":dictCustomer[@"ID"]
                            };
    
    [CallAPI callApiService:@"contact/del_contact" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [Utils alertError:@"Thông báo" content:dictData[@"RESULT"] viewController:nil completion:^{
            [self getListCustomer];
        }];
    }];
}



@end
