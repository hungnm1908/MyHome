//
//  NotificationViewController.m
//  HappyLuckySale
//
//  Created by Macbook on 6/24/19.
//  Copyright © 2019 HuCuBi. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "DetailNewsViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController {
    NSMutableArray *arrayNotifi;
    int page;
    BOOL isCanLoadMore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView addSubview:self.refreshControl];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    page = 1;
    arrayNotifi = [NSMutableArray array];
    [self getListNotifi];
}

- (void)handleRefresh : (id)sender {
    page = 1;
    arrayNotifi = [NSMutableArray array];
    [self.tableView reloadData];
    [self getListNotifi];
    [self.refreshControl endRefreshing];
}

- (IBAction)readAllNotification:(id)sender {
    [Utils alert:@"Thông báo" content:@"Bạn chắc chắc muốn đánh dấu đã đọc hết các thông báo" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        [self updateAllNotification:self->arrayNotifi];
    }];
}

#pragma mark - tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"NotificationTableViewCell";
    NotificationTableViewCell *cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary*dict = [Utils converDictRemoveNullValue:arrayNotifi[indexPath.row]];
    
    cell.labelTime.text = [NSString stringWithFormat:@"%@",dict[@"SENT_TIME"]];
    cell.labelContent.text = [NSString stringWithFormat:@"%@",dict[@"CONTENT"]];
    cell.labelTitle.text = [NSString stringWithFormat:@"%@",dict[@"TITLE"]];
    
    if ([dict[@"IS_READ"] intValue] == 0) {
        cell.viewStatus.hidden = NO;
    }else{
        cell.viewStatus.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayNotifi.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [Utils converDictRemoveNullValue:arrayNotifi[indexPath.row]];
    if ([dict[@"IS_READ"] intValue] == 0) {
        [self updateNotification:arrayNotifi[indexPath.row]:indexPath];
    }
    
    UITabBarController *tabBar = (UITabBarController *)[self appDelegate].window.rootViewController;
    
    if ([dict[@"TYPES"] intValue] == 2 || [dict[@"TYPES"] intValue] == 3 || [dict[@"TYPES"] intValue] == 4 || [dict[@"TYPES"] intValue] == 5 || [dict[@"TYPES"] intValue] == 6 || [dict[@"TYPES"] intValue] == 7) {
        [tabBar setSelectedIndex:1];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([dict[@"TYPES"] intValue] == 8) {
        [tabBar setSelectedIndex:2];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([dict[@"TYPES"] intValue] == 9) {
        [tabBar setSelectedIndex:3];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        DetailNewsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNewsViewController"];
        vc.dictItem = dict;
        vc.type = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == arrayNotifi.count-1 && isCanLoadMore) {
        page++;
        [self getListNotifi];
    }
}

#pragma mark get data
- (void)getListNotifi {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"PIPAGE":[NSString stringWithFormat:@"%d",page],
                            @"NUMOFPAGE":@"100"
                            };
    
    [CallAPI callApiService:@"user/get_list_notifi" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *array = dictData[@"INFO"];
        [self->arrayNotifi addObjectsFromArray:array];
        self->isCanLoadMore = array.count >= 100;
        [self.tableView reloadData];
    }];
}

- (void)updateNotification : (NSDictionary *)dictNotifi : (NSIndexPath *)indexPath {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"LISTID":[NSString stringWithFormat:@"%@",dictNotifi[@"ID"]]};
    
    [CallAPI callApiService:@"user/update_list_notifi" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSDictionary *dict = @{@"CONTENT":[NSString stringWithFormat:@"%@",dictNotifi[@"CONTENT"]],
                               @"ID":[NSString stringWithFormat:@"%@",dictNotifi[@"ID"]],
                               @"IS_READ":@"1",
                               @"LINE_NUMBER":[NSString stringWithFormat:@"%@",dictNotifi[@"LINE_NUMBER"]],
                               @"SENT_TIME":[NSString stringWithFormat:@"%@",dictNotifi[@"SENT_TIME"]],
                               @"STATE":[NSString stringWithFormat:@"%@",dictNotifi[@"STATE"]],
                               @"SUB_TAB":[NSString stringWithFormat:@"%@",dictNotifi[@"SUB_TAB"]],
                               @"TAB":[NSString stringWithFormat:@"%@",dictNotifi[@"TAB"]],
                               @"TITLE":[NSString stringWithFormat:@"%@",dictNotifi[@"TITLE"]],
                               @"TONG":[NSString stringWithFormat:@"%@",dictNotifi[@"TONG"]],
                               @"TYPES":[NSString stringWithFormat:@"%@",dictNotifi[@"TYPES"]],
                               @"UPDATE_TIME":[NSString stringWithFormat:@"%@",dictNotifi[@"UPDATE_TIME"]],
                               @"USERID":[NSString stringWithFormat:@"%@",dictNotifi[@"USERID"]]
        };
        
        [self->arrayNotifi replaceObjectAtIndex:indexPath.row withObject:dict];
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateNotification object:nil];
    }];
}

- (void)updateAllNotification : (NSArray *)arrayNotification {
    NSMutableArray *arrayID = [NSMutableArray array];
    NSMutableArray *arrayNewNotifi = [NSMutableArray array];
    for (NSDictionary *dict in arrayNotification) {
        [arrayID addObject:[NSString stringWithFormat:@"%@",dict[@"ID"]]];
        NSDictionary *dictNew = @{@"CONTENT":[NSString stringWithFormat:@"%@",dict[@"CONTENT"]],
                                  @"ID":[NSString stringWithFormat:@"%@",dict[@"ID"]],
                                  @"IS_READ":@"1",
                                  @"LINE_NUMBER":[NSString stringWithFormat:@"%@",dict[@"LINE_NUMBER"]],
                                  @"SENT_TIME":[NSString stringWithFormat:@"%@",dict[@"SENT_TIME"]],
                                  @"STATE":[NSString stringWithFormat:@"%@",dict[@"STATE"]],
                                  @"SUB_TAB":[NSString stringWithFormat:@"%@",dict[@"SUB_TAB"]],
                                  @"TAB":[NSString stringWithFormat:@"%@",dict[@"TAB"]],
                                  @"TITLE":[NSString stringWithFormat:@"%@",dict[@"TITLE"]],
                                  @"TONG":[NSString stringWithFormat:@"%@",dict[@"TONG"]],
                                  @"TYPES":[NSString stringWithFormat:@"%@",dict[@"TYPES"]],
                                  @"UPDATE_TIME":[NSString stringWithFormat:@"%@",dict[@"UPDATE_TIME"]],
                                  @"USERID":[NSString stringWithFormat:@"%@",dict[@"USERID"]]
                                  };
        [arrayNewNotifi addObject:dictNew];
    }
    
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"LISTID":[arrayID componentsJoinedByString:@"#"]};
    
    [CallAPI callApiService:@"user/update_list_notifi" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        
        self->arrayNotifi = [NSMutableArray array];
        [self->arrayNotifi addObjectsFromArray:arrayNewNotifi];
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateNotification object:nil];
    }];
}

@end
