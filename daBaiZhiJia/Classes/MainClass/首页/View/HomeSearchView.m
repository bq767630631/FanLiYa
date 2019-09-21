//
//  HomeSearchView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomeSearchView.h"
#import "HomeTextFidld.h"
#import "DWQSearchController.h"
#import "DBZJ_ScanContrl.h"
#import "UIView+DKSBadge.h"
#import "ContactKefuContrl.h"
@interface HomeSearchView ()<UITextFieldDelegate,LBXScanViewControllerDelegate>
@property (weak, nonatomic) IBOutlet HomeTextFidld *searText;
@property (weak, nonatomic) IBOutlet UIButton *msegBtn;

@end
@implementation HomeSearchView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.searText.delegate = self;
  //  [self.msegBtn showBadge];
  //  [self.msegBtn showBadgeWithCount:10];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"开始编辑");
    DWQSearchController *search = [DWQSearchController new];
    search.searchType = 1;
    [self.viewController.navigationController pushViewController:search animated:YES];
    return NO;
}

- (IBAction)scanAction:(UIButton *)sender {
    NSLog(@"scanAction");
//    LBXScanViewController *scan = [[LBXScanViewController alloc] init];
//
//    scan.libraryType = SLT_Native;
//    scan.scanCodeType = SCT_QRCode;
//    scan.isOpenInterestRect = YES;
//    scan.style = [self changeColor];
//    scan.title = @"扫一扫";
//    scan.delegate = self;
//    [self.viewController.navigationController pushViewController:scan animated:YES];
    
    DBZJ_ScanContrl *scan = [[DBZJ_ScanContrl alloc] init];
     [self.viewController.navigationController pushViewController:scan animated:YES];
}

#pragma mark - LBXScanViewControllerDelegate
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array{
    NSLog(@" res =%@",array);
}


- (IBAction)messageAction:(UIButton *)sender {
    NSLog(@"messageAction");
    ContactKefuContrl *canVc = [ContactKefuContrl new];
    [self.viewController.navigationController pushViewController:canVc animated:YES];
}

- (LBXScanViewStyle*)changeColor
{
   
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    return style;
}

@end
