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
            self.navigationItem.title = @"Chọn Tỉnh/TP";
        }
            break;
            
        case kDistrict:
        {
            self.navigationItem.title = @"Chọn Quận/Huyện";
        }
            break;
            
        case kSchool:
        {
            self.navigationItem.title = @"Chọn Trường";
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
                cell.textLabel.text = dict[@"PROVINCE_NAME"];
            }
                break;
                
            case kDistrict:
            {
                cell.textLabel.text = dict[@"DISTRICT_NAME"];
            }
                break;
                
            case kSchool:
            {
                cell.textLabel.text = dict[@"SCHOOL_NAME"];
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
            
        case kSchool:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kSchool" object:dict];
        }
            break;
            
            
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
        
        for (NSDictionary *dict in self.arrayItem) {
            switch (self.typeView) {
                case kProvince:
                {
                    nameArea = dict[@"PROVINCE_NAME"];
                    break;
                }
                    
                case kDistrict:
                {
                    nameArea = dict[@"DISTRICT_NAME"];
                    break;
                }
                    
                case kSchool:
                {
                    nameArea = dict[@"SCHOOL_NAME"];
                    break;
                }
                    
            }
            
            nameArea = [nameArea uppercaseString];
            if ([nameArea containsString:strSearch]) {
                [arraySearch addObject:dict];
            }
        }
    }else{
        isSearch = NO;
    }
    [self.tableView reloadData];
}

@end
