//
//  ImageCleanHomeViewController.m
//  MyHome
//
//  Created by HuCuBi on 6/27/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "ImageCleanHomeViewController.h"
#import "ImageDetailViewController.h"

@interface ImageCleanHomeViewController ()

@end

@implementation ImageCleanHomeViewController {
    NSArray *arrayListImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getListImagesClean];
}

#pragma mark TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ImageCleanTableViewCell";
    ImageCleanTableViewCell *cell = (ImageCleanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dictImage = arrayListImage[indexPath.section];
    NSArray *arrayImage = dictImage[@"DATA"];
    [cell setData:arrayImage];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (tableView.frame.size.width / 5) * 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrayListImage.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *dictImage = arrayListImage[section];
    return [NSString stringWithFormat:@"%@",dictImage[@"TYPE_NAME"]];
}

- (void)didSelectImage:(NSArray *)arrayImage :(int)indexSelect {
    ImageDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
    vc.arrayImages = arrayImage;
    vc.index = indexSelect;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark CallAPI

- (void)getListImagesClean {
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName];
    
    NSDictionary *param = @{@"USERNAME" : user ? user : @"",
                            @"ID_BOOK_SERVICES" : self.idDictBookClean
    };
    
    [CallAPI callApiService:@"book/get_img_svs" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayListImage = dictData[@"INFO"];
        [self.tableView reloadData];
    }];
}

@end
