//
//  CommonTableViewController.m
//  NoiBaiAirPort
//
//  Created by HuCuBi on 6/7/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import "CommonTableViewController.h"
#import "CommonWebViewController.h"

@interface CommonTableViewController ()

@end

@implementation CommonTableViewController {
    BOOL isSearch;
    NSMutableArray *arraySearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    switch (self.typeView) {
            
        case kProvince:
        {
            self.labelTitle.text = @"Chọn Tỉnh/TP";
        }
            break;
            
        case kDistrict:
        {
            self.labelTitle.text = @"Chọn Quận/Huyện";
        }
            break;
            
        case kUserType:
        {
            self.labelTitle.text = @"Chọn loại người dùng";
        }
            break;
            
        case kMyHome:
        {
            self.labelTitle.text = @"Chọn nhà nghỉ - Homestay";
        }
            break;
            
        case kVnBank:
        {
            self.labelTitle.text = @"Chọn Ngân hàng";
        }
            break;
            
        case kBuilding:
        {
            self.labelTitle.text = @"Chọn toà nhà";
        }
            break;
            
        case kBanner:
        {
            self.labelTitle.text = @"Chọn Tỉnh/TP";
        }
            break;
            
        case kJourney:
        {
            self.labelTitle.text = @"Chọn hành trình";
        }
            break;
            
        case kRentCar:
        {
            self.labelTitle.text = @"Chọn xe thuê";
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.numberOfLines = 0;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"- None -";
    }else{
        NSDictionary *dict;
        if (isSearch) {
            dict = [arraySearch objectAtIndex:indexPath.row-1];
        }else{
            dict = [self.arrayItem objectAtIndex:indexPath.row-1];
        }
        
        switch (self.typeView) {
            case kProvince:
            {
                cell.textLabel.text = dict[@"NAME"];
            }
                break;
                
            case kDistrict:
            {
                cell.textLabel.text = dict[@"DISTRICT_NAME"];
            }
                break;
                
            case kUserType:
            {
                cell.textLabel.text = dict[@"TYPE_NAME"];
            }
                break;
                
            case kMyHome:
            {
                cell.textLabel.text = dict[@"NAME"];
            }
                break;
                
            case kVnBank:
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%@\n(%@)",dict[@"name"],dict[@"sub_name"]];
            }
                break;
                
            case kBuilding:
            {
                cell.textLabel.text = dict[@"LOCATION_NAME"];
            }
                break;
                
            case kBanner:
            {
                cell.textLabel.text = dict[@"CITY_NAME"];
            }
                break;
                
            case kJourney:
            {
                cell.textLabel.text = dict[@"name"];
            }
                break;
                
            case kRentCar:
            {
                cell.textLabel.text = dict[@"name"];
            }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict;
    if (indexPath.row == 0) {
        dict = [NSDictionary dictionary];
    }else{
        if (isSearch) {
            dict = [arraySearch objectAtIndex:indexPath.row-1];
        }else{
            dict = [self.arrayItem objectAtIndex:indexPath.row-1];
        }
    }
    
    switch (self.typeView) {
        case kProvince:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kProvince" object:dict];
        }
            break;
            
        case kDistrict:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDistrict" object:dict];
        }
            break;
            
        case kUserType:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserType" object:dict];
        }
            break;
            
        case kMyHome:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kMyHome" object:dict];
        }
            break;
            
        case kVnBank:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kVnBank" object:dict];
        }
            break;
            
        case kBuilding:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kBuilding" object:dict];
        }
            break;
            
        case kBanner:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kBanner" object:dict];
        }
            break;
            
        case kJourney:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kJourney" object:dict];
        }
            break;
            
        case kRentCar:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRentCar" object:dict];
        }
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch) {
        return arraySearch.count+1;
    }else{
        return _arrayItem.count+1;
    }
}

- (IBAction)search:(id)sender {
    arraySearch = [NSMutableArray array];
    if (self.textFieldSearch.text.length > 0) {
        isSearch = YES;
        NSString *nameArea = @"";
        NSString *strSearch = [self.textFieldSearch.text uppercaseString];
        strSearch = [Utils changeVietNamese:strSearch];
        
        for (NSDictionary *dict in self.arrayItem) {
            switch (self.typeView) {
                case kProvince:
                {
                    nameArea = dict[@"NAME"];
                    break;
                }
                    
                case kDistrict:
                {
                    nameArea = dict[@"DISTRICT_NAME"];
                    break;
                }
                    
                case kUserType:
                {
                    nameArea = dict[@"TYPE_NAME"];
                    break;
                }
                    
                case kMyHome:
                {
                    nameArea = dict[@"NAME"];
                    break;
                }
                    
                case kVnBank:
                {
                    nameArea = [NSString stringWithFormat:@"%@\n(%@)",dict[@"name"],dict[@"sub_name"]];
                    break;
                }
                    
                case kBuilding:
                {
                    nameArea = dict[@"LOCATION_NAME"];
                    break;
                }
                    
                case kBanner:
                {
                    nameArea = dict[@"CITY_NAME"];
                    break;
                }
                    break;
                    
                case kJourney: {
                    nameArea = dict[@"name"];
                    break;
                }
                case kRentCar: {
                    nameArea = dict[@"name"];
                    break;
                }
            }
            
            nameArea = [nameArea uppercaseString];
            nameArea = [Utils changeVietNamese:nameArea];
            if ([nameArea containsString:strSearch]) {
                [arraySearch addObject:dict];
            }
        }
    }else{
        isSearch = NO;
    }
    [self.tableView reloadData];
}

- (IBAction)backToHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
