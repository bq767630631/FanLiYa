//
//  DBZJ_MineContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_MineContrl.h"
#import <AlibabaAuthSDK/albbsdk.h>
#import "MineFirstView.h"
#import "MineActiveAndTool.h"
#import "LoginContrl.h"
#import "PrersonInfoModel.h"
#import "WXApi.h"
#import "Goto_Login_model.h"
#import "Bind_PhoneContrl.h"

@interface DBZJ_MineContrl ()<WXApiDelegate>
@property (nonatomic, strong) UIScrollView *scroview;

@property (nonatomic, strong) MineFirstView *first;
@property (nonatomic, strong) MineActiveAndTool *active;
@property (nonatomic, strong) MineActiveAndTool *tool;

@property (nonatomic, assign) BOOL loginColse;
@end

@implementation DBZJ_MineContrl

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"我的";
    [self.view addSubview:self.scroview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar navBarBackGroundColor:ThemeColor image:nil isOpaque:YES];
    [self queryPersonRevenue];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)queryPersonRevenue{
    [PrersonInfoModel queryPersonRevenueWithBlcok:^(PersonRevenue * _Nullable reve ,NSInteger code) {
        if (reve) {
            [self.first setModel:reve];
        
            self.tool.top = self.first.bottom + 10;
            self.tool.model = reve;
            self.scroview.contentSize = CGSizeMake(0,  self.tool.bottom);
            [PrersonInfoModel queryMyMidddleWithblock:^(id res, NSError *error) {
                if (res) {
                    [self.first setAddVerInfo:res];
                }
            }];
        }else if (code == Token_isInvalidCode ){
            LoginContrl *login  = [LoginContrl new];
            login.isFrom_homePage = YES;
            [self.navigationController pushViewController:login animated:YES];
        }
    }];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *temp = (SendAuthResp *)resp;
        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_BASE_URL , WXAPPID, WXAPPSECRET, temp.code];
        
        [Goto_Login_model getWx_TokenWithUrl:accessUrlStr callBack:^(NSInteger code) {
            if (code == 1004) { //下一步
                [self.navigationController pushViewController:[Bind_PhoneContrl new] animated:YES];
            }else if (code == SucCode){
                [self delayDoWork:0.5 WithBlock:^{
                    [YJProgressHUD showMsgWithoutView:@"登录成功!"];
                }];
                self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
                self.navigationController.tabBarController.selectedIndex = 4;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if (code == 2068){
                  [YJProgressHUD showMsgWithoutView:@"你的微信号已经绑定过其他手机"];
            }
        }];
    }
}

#pragma mark - getter
- (UIScrollView *)scroview{
    if (!_scroview) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - Height_TabBar);
        _scroview = [[UIScrollView alloc] initWithFrame:frame];
        [_scroview addSubview:self.first];
//        [_scroview addSubview:self.active];
        [_scroview addSubview:self.tool];
        _scroview.contentSize = CGSizeMake(0, 409 + StatusBar_H +210 );
        _scroview.backgroundColor = RGBColor(245, 245, 245);
        _scroview.showsVerticalScrollIndicator = NO;
    }
    return _scroview;
}

- (MineFirstView *)first{
    if (!_first) {
        _first = [MineFirstView viewFromXib];
        _first.frame = CGRectMake(0, 0, SCREEN_WIDTH, _first.height);
    }
    return _first;
}

- (MineActiveAndTool *)tool{
    if (!_tool) {
        _tool = [MineActiveAndTool viewFromXib];
        _tool.frame = CGRectMake(10, self.first.bottom + 5, SCREEN_WIDTH - 20, 210);
    }
    return _tool;
}
@end
