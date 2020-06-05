//
//  MyRoomDetailViewController.m
//  MyHome
//
//  Created by Macbook on 8/28/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "MyRoomDetailViewController.h"
#import "RoomPriceList/RoomPriceListViewController.h"
#import "RoomInformation/RoomInforViewController.h"
#import "RoomAmenitiesViewController.h"

@interface MyRoomDetailViewController ()

@end

@implementation MyRoomDetailViewController {
    BOOL isSettup;
    BOOL isCreateSuccess;
    NSDictionary *dictRoomCreate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:kUpdateRoomInfor object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:kUpdateRoomInforProperty object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotifi:) name:kUpdateRoomInforPrice object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isSettup) {
        if (self.isCreate) {
            [self createRoom];
        }else{
            [self getInfoRoom:self.dictRoom];
            self.navigationItem.title = @"Cập nhật thông tin nhà";
        }
        
        isSettup = YES;
    }
}

- (void)goback {
    if (self.isCreate) {
        if (isCreateSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCreateRoomSuccess object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self removeThisRoom:dictRoomCreate];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)removeRoom:(id)sender {
    [Utils alert:@"Thông báo" content:@"Bạn chắc chắn muốn xóa nhà này ?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        [self removeThisRoom:self.dictRoom];
    }];
}

- (IBAction)changeView:(UISegmentedControl *)sender {
    CGPoint point = CGPointMake(self.scrollView.bounds.size.width*sender.selectedSegmentIndex, 0);
    [self.scrollView setContentOffset:point animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = (int)scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    self.controllView.selectedSegmentIndex = currentPage;
}

#pragma mark CallAPI

- (void)createRoom {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName]};
    
    [CallAPI callApiService:@"room/new_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [self getInfoRoom:dictData];
        self->dictRoomCreate = dictData;
        self.dictRoom = dictData;
    }];
}

- (void)getInfoRoom : (NSDictionary *)dict {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : dict[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"room/get_room_detail" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        RoomInforViewController *vcInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomInforViewController"];
        vcInfo.dictRoom = dictData;
        vcInfo.isCreate = self.isCreate;
        vcInfo.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:vcInfo.view];
        [self addChildViewController:vcInfo];
        
        RoomPriceListViewController *vcMoney = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomPriceListViewController"];
        vcMoney.dictRoom = dictData;
        vcMoney.isCreate = self.isCreate;
        vcMoney.view.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:vcMoney.view];
        [self addChildViewController:vcMoney];
        
        RoomAmenitiesViewController *vcAmenities = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomAmenitiesViewController"];
        vcAmenities.dictRoom = dictData;
        vcAmenities.isCreate = self.isCreate;
        vcAmenities.view.frame = CGRectMake(self.scrollView.frame.size.width*2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:vcAmenities.view];
        [self addChildViewController:vcAmenities];
        
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width*3, self.scrollView.bounds.size.height)];
    }];
}

- (void)removeThisRoom : (NSDictionary *)dictRemove {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK":dictRemove[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"room/del_room" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateRoomInfor object:param];
    }];
}

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:kUpdateRoomInforProperty]) {
        CGPoint point = CGPointMake(self.scrollView.bounds.size.width, 0);
        [self.scrollView setContentOffset:point animated:YES];
        isCreateSuccess = YES;
    }else if ([notif.name isEqualToString:kUpdateRoomInforPrice]) {
        CGPoint point = CGPointMake(self.scrollView.bounds.size.width*2, 0);
        [self.scrollView setContentOffset:point animated:YES];
        isCreateSuccess = YES;
    }else if ([notif.name isEqualToString:kUpdateRoomInfor]) {
        isCreateSuccess = YES;
    }
}


@end
