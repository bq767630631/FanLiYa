//
//  DBZJ_IncomeContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_IncomeContrl.h"
#import "LoginContrl.h"
#import "DBZJ_Income_First.h"
#import "DBZJ_IncomeModel.h"
#import "ZhuanQianYaFirstV.h"

@interface DBZJ_IncomeContrl ()
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) DBZJ_Income_First *first;
@property (nonatomic, strong) ZhuanQianYaFirstV *zqy_V;
@end

@implementation DBZJ_IncomeContrl

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"赚钱鸭";
    [self.view addSubview:self.scroView];
}

- (void)queryData{
    [DBZJ_IncomeModel queryZqyDataWickBlock:^(DBZJ_Zqy_Info *info, NSError *error ,NSInteger code) {
        if (info) {
            [self.zqy_V setModel:info];
        }else if (code == Token_isInvalidCode ){
//            LoginContrl *login =  [LoginContrl new];
//            login.isFrom_homePage = YES;
//            [self.navigationController pushViewController:login animated:YES];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
    // [self.navigationController.navigationBar navBarBackGroundColor:RGBColor(33, 33, 33) image:nil isOpaque:YES];
    [self queryData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - getter
-(UIScrollView *)scroView{
    if (!_scroView) {
        _scroView = [[UIScrollView alloc] init];
        CGFloat height = SCREEN_HEIGHT - Height_TabBar;
        _scroView.frame = CGRectMake(0,0, SCREEN_WIDTH, height);
        [_scroView addSubview:self.zqy_V];
        _scroView.contentSize = CGSizeMake(0, 1256.f);
        _scroView.showsVerticalScrollIndicator = NO;
    }
    return _scroView;
}

- (DBZJ_Income_First *)first{
    if (!_first) {
        _first = [DBZJ_Income_First viewFromXib];
        _first.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1682);
    }
    return _first;
}

- (ZhuanQianYaFirstV *)zqy_V{
    if (!_zqy_V) {
        _zqy_V = [ZhuanQianYaFirstV viewFromXib];
        _zqy_V.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1256);
    }
    return _zqy_V;
}

@end
