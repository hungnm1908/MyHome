//
//  ListMyRoomViewController.m
//  MyHome
//
//  Created by Macbook on 8/15/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ListMyRoomViewController.h"
#import "ListMyRoomTableViewCell.h"

@interface ListMyRoomViewController ()

@end

@implementation ListMyRoomViewController {
    NSArray *arrayMyRoom;
    NSMutableDictionary *dictImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dictImages = [NSMutableDictionary dictionary];
    
    [self getListMyRoom];
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
    
    UIImage *imageItem = dictImages[dict[@"GENLINK"]];
    if (imageItem) {
        cell.imageAvatar.image = imageItem;
    }else{
        cell.imageAvatar.image = [UIImage imageNamed:@"image_default"];
    }
    
    cell.labelName.text = dict[@"NAME"];
    cell.labelMoney.text = [NSString stringWithFormat:@"%@ vnđ/đêm",[Utils strCurrency:dict[@"PRICE"]]];
    cell.labelAdd.text = dict[@"ADDRESS"];
    
    if ([dict[@"STATE"] intValue] == 6) {
        cell.labelStatus.text = [NSString stringWithFormat:@"  ĐÃ DUYỆT  "];
        cell.labelStatus.backgroundColor = RGB_COLOR(84, 125, 190);
    }else if ([dict[@"STATE"] intValue] == 7) {
        cell.labelStatus.text = [NSString stringWithFormat:@"  KHÔNG DUYỆT  "];
        cell.labelStatus.backgroundColor = RGB_COLOR(250, 171, 28);
    }else{
        cell.labelStatus.text = [NSString stringWithFormat:@"  ĐANG CHỜ DUYỆT  "];
        cell.labelStatus.backgroundColor = RGB_COLOR(182, 204, 129);
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayMyRoom.count;
}

#pragma mark CallAPI

- (void)getListMyRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"OPT":@""
                            };
    
    [CallAPI callApiService:@"room/get_mylist_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayMyRoom = dictData[@"INFO"];
        
        for (NSDictionary *dict in self->arrayMyRoom) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *link = [dict[@"COVER"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                link = [Utils convertStringUrl:link];
                link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:link]]];
                image = [Utils scaleImageFromImage:image scaledToSize:([UIScreen mainScreen].bounds.size.width - 30 - 16)];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        [self->dictImages setObject:image forKey:dict[@"GENLINK"]];
                    }else{
                        [self->dictImages setObject:[UIImage imageNamed:@"image_default"] forKey:dict[@"GENLINK"]];
                    }
                    [self.tableView reloadData];
                });
            });
        }
        
        [self.tableView reloadData];
    }];
}

@end
