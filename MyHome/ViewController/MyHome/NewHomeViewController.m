//
//  NewHomeViewController.m
//  MyHome
//
//  Created by Macbook on 3/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "NewHomeViewController.h"
#import "HomeDetailViewController.h"
#import "SearchResultViewController.h"

@interface NewHomeViewController ()

@end

@implementation NewHomeViewController {
    NSMutableArray *arrayHouses1;
    NSMutableArray *arrayHouses2;
    NSArray *arrayBanner;
    int page;
    BOOL isCanLoadMore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    isCanLoadMore = YES;
    arrayHouses1 = [NSMutableArray array];
    arrayHouses2 = [NSMutableArray array];
    
    [self getListHome];
    
    [self getListBanner];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = RGB_COLOR(240, 240, 240);
    self.refreshControl.tintColor = RGB_COLOR(100, 100, 100);
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)handleRefresh : (id)sender {
    page = 1;
    isCanLoadMore = YES;
    arrayBanner = [NSArray array];
    arrayHouses1 = [NSMutableArray array];
    arrayHouses2 = [NSMutableArray array];
    [self.tableView reloadData];
    [self getListBanner];
    [self getListHome];
    [self.refreshControl endRefreshing];
}

- (IBAction)search:(id)sender {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsLogin];
    
    if (isLogin) {
        SearchResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
        vc.paramSearch = @{};
        vc.arrayHouses = @[];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"SecondHomeTableViewCell";
        SecondHomeTableViewCell *cell = (SecondHomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.arrayItem = arrayBanner;
        cell.delegate = self;
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"FourHomeTableViewCell";
        FourHomeTableViewCell *cell = (FourHomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSDictionary *dict = [Utils converDictRemoveNullValue:arrayHouses1[indexPath.row]];
        
        cell.labelNameItem1.text = dict[@"NAME"];
        cell.labelInforItem1.text = [NSString stringWithFormat:@"%@\n\n%@ khách - %@ phòng - %@ giường",dict[@"ADDRESS"],dict[@"MAX_GUEST"],dict[@"MAX_ROOM"],dict[@"MAX_BED"]];
        cell.labelCostItem1.text = [NSString stringWithFormat:@"Giá: %@đ",[Utils getPrice:dict]];
        cell.labelBalance1.text = [NSString stringWithFormat:@"HH: %@đ",[Utils getBalance:dict]];
        
        if ([Utils isShowPromotion:dict]) {
            cell.viewCurrentCostItem1.hidden = NO;
            cell.labelPercent1.hidden = NO;
            cell.labelPercent1.text = [NSString stringWithFormat:@"  - %@%c  ",dict[@"PERCENT"],'%'];
            cell.labelCurrentCostItem1.text = [NSString stringWithFormat:@"%@đ",[Utils strCurrency:dict[@"PRICE"]]];
        }else{
            cell.viewCurrentCostItem1.hidden = YES;
            cell.labelPercent1.hidden = YES;
        }
        
        NSString *link = [dict[@"COVER"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        link = [Utils convertStringUrl:link];
        link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
        NSURL *urlImage = [NSURL URLWithString:link];
        [cell.imageItem1 sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
        
        [cell.btnDetail1 addTarget:self action:@selector(detailHome1:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row < arrayHouses2.count) {
            cell.view2.hidden = NO;
            
            NSDictionary *dict = [Utils converDictRemoveNullValue:arrayHouses2[indexPath.row]];
            
            cell.labelNameItem2.text = dict[@"NAME"];
            cell.labelInforItem2.text = [NSString stringWithFormat:@"%@\n\n%@ khách - %@ phòng - %@ giường",dict[@"ADDRESS"],dict[@"MAX_GUEST"],dict[@"MAX_ROOM"],dict[@"MAX_BED"]];
            cell.labelCostItem2.text = [NSString stringWithFormat:@"Giá: %@đ",[Utils getPrice:dict]];
            cell.labelBalance2.text = [NSString stringWithFormat:@"HH: %@đ",[Utils getBalance:dict]];
            
            if ([Utils isShowPromotion:dict]) {
                cell.viewCurrentCostItem2.hidden = NO;
                cell.labelPercent2.hidden = NO;
                cell.labelPercent2.text = [NSString stringWithFormat:@"  - %@%c  ",dict[@"PERCENT"],'%'];
                cell.labelCurrentCostItem2.text = [NSString stringWithFormat:@"%@đ",[Utils strCurrency:dict[@"PRICE"]]];
            }else{
                cell.viewCurrentCostItem2.hidden = YES;
                cell.labelPercent2.hidden = YES;
            }
            
            NSString *link = [dict[@"COVER"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            link = [Utils convertStringUrl:link];
            link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
            NSURL *urlImage = [NSURL URLWithString:link];
            [cell.imageItem2 sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"]];
            [cell.btnDetail2 addTarget:self action:@selector(detailHome2:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.view2.hidden = YES;
        }
        
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return arrayHouses1.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"ĐIỂM ĐẾN YÊU THÍCH";
    }else{
        return @"TOP NHÀ NỔI BẬT";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor whiteColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:RGB_COLOR(75, 109, 179)];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == arrayHouses1.count-1 && isCanLoadMore) {
        page++;
        [self getListHome];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [UIScreen mainScreen].bounds.size.height*1/4;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (void)detailHome1 : (id)sender {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsLogin];
    
    if (isLogin) {
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        NSDictionary *dict = [Utils converDictRemoveNullValue:arrayHouses1[hitIndex.row]];
        
        HomeDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetailViewController"];
        vc.dictHome = dict;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [Utils alert:@"Thông báo" content:@"Vui lòng đăng nhập để sửa dụng chức năng này" titleOK:@"Đăng nhập" titleCancel:@"Để sau" viewController:nil completion:^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [[self appDelegate].window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
            [[self appDelegate].window makeKeyAndVisible];
        }];
    }
}

- (void)detailHome2 : (id)sender {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultIsLogin];
    
    if (isLogin) {
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        NSDictionary *dict = [Utils converDictRemoveNullValue:arrayHouses2[hitIndex.row]];
        
        HomeDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetailViewController"];
        vc.dictHome = dict;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [Utils alert:@"Thông báo" content:@"Vui lòng đăng nhập để sửa dụng chức năng này" titleOK:@"Đăng nhập" titleCancel:@"Để sau" viewController:nil completion:^{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [[self appDelegate].window setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
            [[self appDelegate].window makeKeyAndVisible];
        }];
    }
}

- (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark SecondCellDelegate
- (void)pushViewControllerShowDetailItem:(NSDictionary *)dictSkill {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"LOCATION" : @"",
                            @"ID_PROVINCE" : dictSkill[@"ID_PROVINCE"],
                            @"CHECKIN" : @"",
                            @"CHECKOUT" : @"",
                            @"PEOPLE" : @"",
                            @"PRICE_FROM" : @"",
                            @"PRICE_TO" : @"",
                            @"AMENITIES" : @""
    };
    
    SearchResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    vc.paramSearch = param;
    vc.arrayHouses = @[];
    vc.arrayBanner = arrayBanner;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark CallAPI

- (void)getListHome {
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName];
    
    NSDictionary *param = @{@"USERNAME" : user ? user : @"",
                            @"PAGE" : [NSString stringWithFormat:@"%d",page],
                            @"NUMOFPAGE" : @"20"
    };
    
    [CallAPI callApiService:@"room/get_listroom_idx" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        NSArray *arrayResult = dictData[@"INFO"];
        for (int i=0;i < arrayResult.count;i++) {
            if (i%2==0) {
                [self->arrayHouses1 addObject:arrayResult[i]];
            }else{
                [self->arrayHouses2 addObject:arrayResult[i]];
            }
        }
        
        self->isCanLoadMore = arrayResult.count >= 20;
        [self.tableView reloadData];
    }];
}

- (void)getListBanner {
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName];
    
    NSDictionary *param = @{@"USERNAME" : user ? user : @""};
    
    [CallAPI callApiService:@"room/get_banner_city" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayBanner = dictData[@"INFO"];
        [VariableStatic sharedInstance].arrayBanner = dictData[@"INFO"];
        [self.tableView reloadData];
    }];
}

@end
