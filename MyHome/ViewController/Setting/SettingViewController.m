//
//  SettingViewController.m
//  MyHome
//
//  Created by HuCuBi on 8/4/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "InformationViewController.h"
#import "ListCustomerViewController.h"
#import "ChangePasswordViewController.h"
#import "ListUserViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController {
    NSMutableArray *arraySetting;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *array = @[@{@"id":@"0",
                       @"title":@"HỒ SƠ",
                       @"image":@"setting_0"
                     },
                     @{@"id":@"1",
                       @"title":@"DANH SÁCH KHÁCH HÀNG",
                       @"image":@"setting_2"
                     },
                     @{@"id":@"2",
                       @"title":@"CHĂM SÓC KHÁCH HÀNG",
                       @"image":@"setting_3"
                     },
                     @{@"id":@"3",
                       @"title":@"HỖ TRỢ",
                       @"image":@"setting_4"
                     },
                     @{@"id":@"4",
                       @"title":@"CHIA SẺ ỨNG DỤNG",
                       @"image":@"setting_5"
                     },
                     @{@"id":@"5",
                       @"title":@"ĐỔI MẬT KHẨU",
                       @"image":@"setting_6"
                     }];
    
    arraySetting = [NSMutableArray arrayWithArray:array];
    
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserInfo];
    if ([userInfo[@"USER_TYPE"] intValue] == 0) {
        NSDictionary *dictUser = @{@"id":@"6",
                                   @"title":@"DANH SÁCH NGƯỜI DÙNG",
                                   @"image":@"setting_1"
        };
        
        [arraySetting addObject:dictUser];
    }

//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    self.labelVersion.text = [NSString stringWithFormat:@"version: %@",appVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [Utils alert:@"Đăng xuất" content:@"Bạn chắc chắn muốn đăng xuất" titleOK:@"Đồng ý" titleCancel:@"Huỷ bỏ" viewController:nil completion:^{
        NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        for (NSString *key in [defaultsDictionary allKeys]) {
            if (![key isEqualToString:kUserDefaultUserName] &&
                ![key isEqualToString:kUserDefaultToken] &&
                ![key isEqualToString:kUserDefaultPassword]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[self appDelegate].window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
        [[self appDelegate].window makeKeyAndVisible];
    }];
}

#pragma mark TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SettingTableViewCell";
    SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    NSDictionary *dict = arraySetting[indexPath.row];
    
    cell.labelTitle.text = dict[@"title"];
    cell.imageItem.image = [UIImage imageNamed:dict[@"image"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arraySetting.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = arraySetting[indexPath.row];
    
    int idStr = [dict[@"id"] intValue];
    
    switch (idStr) {
        case 0:
        {
            InformationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
            vc.isEdit = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:
        {
            ListCustomerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListCustomerViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            [Utils alertError:@"Thông báo" content:@"Chức năng đang được phát triển" viewController:nil completion:^{
                
            }];
        }
            break;
            
        case 3:
        {
            NSString *tel = @"tel://0981045225";
            NSURL *URL = [NSURL URLWithString:tel];
            [[UIApplication sharedApplication] openURL:URL];
        }
            break;
            
        case 4:
        {
            [Utils alert:@"Chia sẻ ứng dụng" content:@"Bạn đồng ý chia sẻ MyHome với những người khác" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
                NSString *str = @"https://apps.apple.com/us/app/myhome/id1476078746?ls=1";
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = str;
                
                UIActivityViewController *controller =
                [[UIActivityViewController alloc] initWithActivityItems:@[str] applicationActivities:nil];
                
                NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                               UIActivityTypePrint,
                                               UIActivityTypeAssignToContact,
                                               UIActivityTypeSaveToCameraRoll,
                                               UIActivityTypeAddToReadingList,
                                               UIActivityTypePostToFlickr,
                                               UIActivityTypePostToVimeo];
                
                controller.excludedActivityTypes = excludeActivities;
                
                //if iPhone
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    [self presentViewController:controller animated:YES completion:nil];
                }else {
                    // Change Rect to position Popover
                    
                    // present the controller
                    // on iPad, this will be a Popover
                    // on iPhone, this will be an action sheet
                    controller.modalPresentationStyle = UIModalPresentationPopover;
                    [self presentViewController:controller animated:YES completion:nil];
                    
                    // configure the Popover presentation controller
                    UIPopoverPresentationController *popController = [controller popoverPresentationController];
                    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
                    popController.delegate = self;
                    
                    // in case we don't have a bar button as reference
                    popController.sourceView = self.view;
                    popController.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0);
                }
            }];
        }
            break;
            
        case 5:
        {
            ChangePasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            case 6:
            {
                ListUserViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListUserViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            
        default:
            break;
    }
}

- (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
