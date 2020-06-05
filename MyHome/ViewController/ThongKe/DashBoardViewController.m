//
//  DashBoardViewController.m
//  MyHome
//
//  Created by Macbook on 8/27/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "DashBoardViewController.h"
#import "ThongKeChiTiet/ThongKeViewController.h"
#import "AAGlobalMacro.h"
#import "AAChartView.h"

@interface DashBoardViewController ()

@end

@implementation DashBoardViewController {
    BOOL isSettup;
    NSDictionary *dictReportThisMonth;
    NSDictionary *dictReportLastMonth;
    
    NSString *thisMonth;
    NSString *lastMonth;
    
    ManaDropDownMenu *dropDownMKH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getReport];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!isSettup) {
        [self performSelector:@selector(settupViewSelectType) withObject:nil afterDelay:1.0];
        isSettup = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [dropDownMKH animateForClose];
}

- (IBAction)showDetailTotal:(id)sender {
    [dropDownMKH animateForClose];
    [self performSelector:@selector(showDetail) withObject:nil afterDelay:0.5];
}

- (IBAction)choseReportMonth:(id)sender {
    [self.textFieldReportMonth becomeFirstResponder];
}

- (IBAction)getReport:(id)sender {
    [self getReport];
}

- (void)showDetail {
    ThongKeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ThongKeViewController"];
    vc.month = self.textFieldReportMonth.text;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)settupViewSelectType {
    NSArray *arrayStyleView = @[@"Dạng số liệu",@"Dạng biểu đồ "];
    
    CGRect frame = self.viewKieuHienThi.frame;
    frame.origin.x = frame.origin.x + 2;
    frame.origin.y = frame.origin.y + 20;
    frame.size.width = frame.size.width - 4;
    frame.size.height = frame.size.height - 21;
    
    dropDownMKH = [[ManaDropDownMenu alloc] initWithFrame:frame title:arrayStyleView[0]];
    dropDownMKH.delegate = self;
    dropDownMKH.numberOfRows = arrayStyleView.count;
    dropDownMKH.textOfRows = arrayStyleView;
    dropDownMKH.seperatorColor = RGB_COLOR(75, 109, 179);
    dropDownMKH.inactiveColor = RGB_COLOR(75, 109, 179);
    [self.view addSubview:dropDownMKH];
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    if (index == 0) {
        self.viewSoLieu.hidden = NO;
        self.viewBieuDo.hidden = YES;
    }else{
        self.viewSoLieu.hidden = YES;
        self.viewBieuDo.hidden = NO;
    }
}

- (void)fillInfo : (NSDictionary *)dictReport {
    self.labelDoanhThuTong.text = [[Utils strCurrency:dictReport[@"TOTAL_REVENUE"]] stringByAppendingString:@"\n(vnđ)"];
    self.labelChiPhiBanHang.text = [[Utils strCurrency:dictReport[@"TOTAL_SELLING_COSTS"]] stringByAppendingString:@" vnđ"];
    self.labelChiPhiDichVu.text = [[Utils strCurrency:dictReport[@"TOTAL_SERVICE_COSTS"]] stringByAppendingString:@" vnđ"];
    self.labelChiPhiKhac.text = [[Utils strCurrency:dictReport[@"TOTAL_OTHER_COSTS"]] stringByAppendingString:@" vnđ"];
    
    self.labelDoanhThuTong2.text = [[Utils strCurrency:dictReport[@"TOTAL_REVENUE"]] stringByAppendingString:@" vnđ"];
    self.labelLoiNhuan.text = [[Utils strCurrency:dictReport[@"REVENUE"]] stringByAppendingString:@" vnđ"];
    
    long long totalChiPhi = [dictReport[@"TOTAL_OTHER_COSTS"] longLongValue] + [dictReport[@"TOTAL_SELLING_COSTS"] longLongValue] + [dictReport[@"TOTAL_SERVICE_COSTS"] longLongValue];
    self.labelChiPhiTong.text = [[Utils strCurrency:[NSString stringWithFormat:@"%lld",totalChiPhi]] stringByAppendingString:@" vnđ"];
    
    long long tongDoanhThu = [dictReport[@"TOTAL_REVENUE"] longLongValue];
    float percentChiPhiBanHang = tongDoanhThu > 0 ? (float)[dictReport[@"TOTAL_SELLING_COSTS"] longLongValue]/tongDoanhThu : 0;
    float percentChiPhiDichVu = tongDoanhThu > 0 ? (float)[dictReport[@"TOTAL_SERVICE_COSTS"] longLongValue] / tongDoanhThu : 0;
    float percentChiPhiKhac = tongDoanhThu > 0 ? (float)[dictReport[@"TOTAL_OTHER_COSTS"] longLongValue] / tongDoanhThu : 0;
    
    [self.circleChiPhiBanHang setProgress:percentChiPhiBanHang animated:YES];
    [self.circleChiPhiDichVu setProgress:percentChiPhiDichVu animated:YES];
    [self.circleChiPhiKhac setProgress:percentChiPhiKhac animated:YES];
}

#pragma mark BieuDo

- (void)settupViewChart {
    CGRect frame = CGRectMake(0, 0, self.viewBieuDo.frame.size.width, self.viewBieuDo.frame.size.height);
    
    NSMutableArray *arrayThisYear = [NSMutableArray array];
    NSMutableArray *arrayLastYear = [NSMutableArray array];
    NSArray *arrayMonth = @[@"Doang thu tổng",@"Chi phí tổng",@"Lợi nhuận"];
    
    [arrayThisYear addObject:[NSNumber numberWithLongLong:[dictReportThisMonth[@"TOTAL_REVENUE"] longLongValue]]];
    [arrayThisYear addObject:[NSNumber numberWithLongLong:[dictReportThisMonth[@"TOTAL_SELLING_COSTS"] longLongValue]]];
    [arrayThisYear addObject:[NSNumber numberWithLongLong:[dictReportThisMonth[@"REVENUE"] longLongValue]]];
    
    [arrayLastYear addObject:[NSNumber numberWithLongLong:[dictReportLastMonth[@"TOTAL_REVENUE"] longLongValue]]];
    [arrayLastYear addObject:[NSNumber numberWithLongLong:[dictReportLastMonth[@"TOTAL_SELLING_COSTS"] longLongValue]]];
    [arrayLastYear addObject:[NSNumber numberWithLongLong:[dictReportLastMonth[@"REVENUE"] longLongValue]]];
    
    [self drawChartWithName:@"Biểu đồ so sánh Doanh Thu" frame:frame arrayMonth:arrayMonth arrayThisYear:arrayThisYear arrayLastYear:arrayLastYear];
}

- (void)drawChartWithName : (NSString *)name frame : (CGRect) frame arrayMonth:(NSArray *)arrayMonth arrayThisYear : (NSArray *)arrayThisYear arrayLastYear : (NSArray *)arrayLastYear {
    for (UIView *view in self.viewBieuDo.subviews) {
        [view removeFromSuperview];
    }
    
    AAChartView *aaChartView = [[AAChartView alloc]initWithFrame:frame];
    aaChartView.contentHeight = frame.size.height;
    [self.viewBieuDo addSubview:aaChartView];
    
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeColumn)
    .titleSet(name)
    .subtitleSet(@"Số tiền")
    .categoriesSet(arrayMonth)
    .yAxisTitleSet(@"VNĐ")
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(lastMonth)
                 .dataSet(arrayLastYear),
                 AAObject(AASeriesElement)
                 .nameSet(thisMonth)
                 .dataSet(arrayThisYear)
                 ])
    ;
    
    aaChartModel.colorsTheme = @[@"#1263BB",@"#EC1C24"];
    
    [aaChartView aa_drawChartWithChartModel:aaChartModel];
}

#pragma mark CallAPI

- (void)getReport {
    thisMonth = self.textFieldReportMonth.text;
    
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"MONTH":self.textFieldReportMonth.text};
    
    [CallAPI callApiService:@"report/get_report" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->dictReportThisMonth = dictData;
        [self fillInfo:dictData];
        [self getReportLastMonth];
    }];
}

- (void)getReportLastMonth {
    NSString *dateReport = [@"01/" stringByAppendingString:self.textFieldReportMonth.text];
    NSDate *date = [Utils getDateFromStringDate:dateReport];
    
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    [calender setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    comps.day = 1;
    comps.month = comps.month - 1;
    NSDate *dateLastMonth = [calender dateFromComponents:comps];
    lastMonth = [Utils getDateFromDate:dateLastMonth];
    lastMonth = [lastMonth substringFromIndex:3];
    
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"MONTH":lastMonth};
    
    [CallAPI callApiService:@"report/get_report" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->dictReportLastMonth = dictData;
        [self settupViewChart];
    }];
}

@end
