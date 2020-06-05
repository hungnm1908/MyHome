//
//  RoomAmenitiesViewController.m
//  MyHome
//
//  Created by Macbook on 9/20/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "RoomAmenitiesViewController.h"
#import "RoomAmenitiesTableViewCell.h"
#import "IonIcons.h"

@interface RoomAmenitiesViewController ()

@end

@implementation RoomAmenitiesViewController {
    NSMutableArray *arraySection;
    NSMutableDictionary *listAmenities;
    NSMutableArray *arrayIdAmenities;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arraySection = [NSMutableArray array];
    arrayIdAmenities = [NSMutableArray array];
    listAmenities = [NSMutableDictionary dictionary];
    
    [self getImageAmenities];
}

- (IBAction)update:(id)sender {
    [self updateAmenities];
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arraySection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *title = arraySection[section];
    NSArray *arrayAmenities = listAmenities[title];
    return arrayAmenities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RoomAmenitiesTableViewCell";
    RoomAmenitiesTableViewCell *cell = (RoomAmenitiesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    NSString *title = arraySection[indexPath.section];
    NSArray *arrayAmenities = listAmenities[title];
    NSDictionary *dict = arrayAmenities[indexPath.row];
    
    cell.labelAmentities.text = dict[@"NAME_AMENITIES"];
    cell.iconAmenities.image = [IonIcons imageWithIcon:ion_grid
                                             iconColor:RGB_COLOR(84, 125, 190)
                                              iconSize:60.0f
                                             imageSize:CGSizeMake(90.0f, 90.0f)];
    
    NSString *idAmenities = [NSString stringWithFormat:@"%@",dict[@"ID"]];
    if ([arrayIdAmenities containsObject:idAmenities]) {
        cell.iconCheckBox.image = [UIImage imageNamed:@"icon_check"];
    }else{
        cell.iconCheckBox.image = [UIImage imageNamed:@"icon_uncheck"];
    }
    
    [cell.btnChangeStatus addTarget:self action:@selector(selectAmenities:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return arraySection[section];
}

- (void)selectAmenities : (id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    
    NSString *title = arraySection[hitIndex.section];
    NSArray *arrayAmenities = listAmenities[title];
    NSDictionary *dict = arrayAmenities[hitIndex.row];
    
    NSString *idAmenities = [NSString stringWithFormat:@"%@",dict[@"ID"]];
    if ([arrayIdAmenities containsObject:idAmenities]) {
        [arrayIdAmenities removeObject:idAmenities];
    }else{
        [arrayIdAmenities addObject:idAmenities];
    }
}

#pragma mark CallAPI

- (void)getAmenities {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]};
    
    [CallAPI callApiService:@"get_amenities" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayResult = dictData[@"INFO"];
        
        NSArray *arraySort = [arrayResult sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dict1, NSDictionary *dict2) {
            NSString *percent1 = dict1[@"TYPE_AMENITIES"] ;
            NSString *percent2 = dict2[@"TYPE_AMENITIES"] ;
            return [percent1 compare:percent2];
        }];
        
        int idSection = 0;
        NSString *nameSection = @"";
        for (NSDictionary *dict in arraySort) {
            int typeAmenities = [dict[@"TYPE_AMENITIES"] intValue];
            if (idSection != typeAmenities) {
                idSection = typeAmenities;
                nameSection = dict[@"NAME_AMENITIES"];
                [self->arraySection addObject:nameSection];
                [self->listAmenities setObject:[NSMutableArray array] forKey:nameSection];
            }
            
            [[self->listAmenities objectForKey:nameSection] addObject:dict];
        }
        
        [self.tableView reloadData];
    }];
}

- (void)getImageAmenities {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : self.dictRoom[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"room/get_amenities_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayResult = dictData[@"INFO"];
        for (NSDictionary *dict in arrayResult) {
            NSString *idAmenities = [NSString stringWithFormat:@"%@",dict[@"ID"]];
            [self->arrayIdAmenities addObject:idAmenities];
        }
        
        [self getAmenities];
    }];
}

- (void)updateAmenities {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : self.dictRoom[@"GENLINK"],
                            @"AMENITIES" : [arrayIdAmenities componentsJoinedByString:@","]
                            };
    
    [CallAPI callApiService:@"room/update_amenities" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateRoomInfor object:param];
        [Utils alertError:@"Thông báo" content:@"Cập nhật tiện ích thành công" viewController:nil completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
