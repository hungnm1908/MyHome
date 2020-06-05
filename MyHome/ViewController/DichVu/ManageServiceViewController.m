//
//  ManageServiceViewController.m
//  MyHome
//
//  Created by HuCuBi on 3/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "ManageServiceViewController.h"
#import "ManageRentCarViewController.h"

@interface ManageServiceViewController ()

@end

@implementation ManageServiceViewController {
    NSDictionary *listService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listService = @{@"Thuê xe":@[@"Thuê xe máy", @"Thuê ô tô"],
                    @"Dịch vụ khác":@[@"Thuỷ phi cơ",@"Trực thăng"],
                    @"Du thuyền":@[@"Du thuyền riêng",@"Thuyền thăm vịnh"]
                    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.numberOfLines = 0;
    
    NSString *title = listService.allKeys[indexPath.section];
    NSArray *arrayService = listService[title];
    cell.textLabel.text = arrayService[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *title = listService.allKeys[section];
    NSArray *arrayService = listService[title];
    return arrayService.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return listService.allKeys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return listService.allKeys[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        ManageRentCarViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageRentCarViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [Utils alertError:@"Thông báo" content:@"Chức năng đang xây dựng" viewController:nil completion:^{
            
        }];
    }
}

@end
