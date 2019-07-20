//
//  DBZJ_ScanContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_ScanContrl.h"
#import "SearchResultContrl.h"
#import "GoodDetailContrl.h"

@interface DBZJ_ScanContrl ()

@end

@implementation DBZJ_ScanContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.libraryType = SLT_Native;
    self.scanCodeType = SCT_QRCode;
    self.isOpenInterestRect = YES;
    self.style = [self changeColor];
    self.title = @"扫一扫";
    self.cameraInvokeMsg = @"相机启动中";
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -实现类继承该方法，作出对应处理
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array{
    NSLog(@" %@",array);
    LBXScanResult *res = array.firstObject;
    NSLog(@"%@",res.strScanned);
    if (res.strScanned.length > 0) {
        SearchResultContrl *search = [[SearchResultContrl alloc] initWithSearchStr:res.strScanned];
        [self.navigationController pushViewController:search animated:YES];
    }
}

#pragma mark - private
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
