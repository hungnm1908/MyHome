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
    cell.labelTitle.text = [NSString stringWithFormat:@"%@",self.dictShop[@"SHOP_NAME"]];
    
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
    [self updateNotification:arrayNotifi[indexPath.row]:indexPath];
    DetailNewsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNewsViewController"];
    vc.dictItem = [Utils converDictRemoveNullValue:arrayNotifi[indexPath.row]];
    vc.type = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == arrayNotifi.count-1 && isCanLoadMore) {
        page++;
        [self getListNotifi];
    }
}

#pragma mark get data
- (void)getListNotifi {
    NSDictionary *param = @{@"PAGE":[NSString stringWithFormat:@"%d",page],
                            @"NUMOFPAGE":@"10"
                            };
    
    [CallAPI callApiService:@"get_list_notify" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *array = dictData[@"INFO"];
        [self->arrayNotifi addObjectsFromArray:array];
        self->isCanLoadMore = array.count >= 10;
        [self.tableView reloadData];
    }];
}

- (void)updateNotification : (NSDictionary *)dictNotifi : (NSIndexPath *)indexPath {
    NSDictionary *param = @{@"ID_NOTIFY":[NSString stringWithFormat:@"%@",dictNotifi[@"ID"]]};
    
    [CallAPI callApiService:@"update_notify" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSDictionary *dict = @{@"ID":[NSString stringWithFormat:@"%@",dictNotifi[@"ID"]],
                               @"CONTENT":[NSString stringWithFormat:@"%@",dictNotifi[@"CONTENT"]],
                               @"SENT_TIME":[NSString stringWithFormat:@"%@",dictNotifi[@"SENT_TIME"]],
                               @"IS_READ":@"1",
                               };
        
        [self->arrayNotifi replaceObjectAtIndex:indexPath.row withObject:dict];
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateNotification" object:nil];
    }];
}

- (void)updateAllNotification : (NSArray *)arrayNotification {
    NSMutableArray *arrayID = [NSMutableArray array];
    NSMutableArray *arrayNewNotifi = [NSMutableArray array];
    for (NSDictionary *dict in arrayNotification) {
        [arrayID addObject:[NSString stringWithFormat:@"%@",dict[@"ID"]]];
        NSDictionary *dictNew = @{@"ID":[NSString stringWithFormat:@"%@",dict[@"ID"]],
                                  @"CONTENT":[NSString stringWithFormat:@"%@",dict[@"CONTENT"]],
                                  @"SENT_TIME":[NSString stringWithFormat:@"%@",dict[@"SENT_TIME"]],
                                  @"IS_READ":@"1",
                                  };
        [arrayNewNotifi addObject:dictNew];
    }
    
    NSDictionary *param = @{@"ID_NOTIFY":[arrayID componentsJoinedByString:@"#"]};
    
    [CallAPI callApiService:@"update_notify" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        
        self->arrayNotifi = [NSMutableArray array];
        [self->arrayNotifi addObjectsFromArray:arrayNewNotifi];
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateNotification" object:nil];
    }];
}

@end
