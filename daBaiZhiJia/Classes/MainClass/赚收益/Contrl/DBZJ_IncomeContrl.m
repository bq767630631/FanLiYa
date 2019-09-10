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


@interface DBZJ_IncomeContrl ()
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) DBZJ_Income_First *first;
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
            [self.first setModel:info];
            self.scroView.contentSize = CGSizeMake(0,  self.first.height);
        }else if (code == Token_isInvalidCode ){
//            LoginContrl *login =  [LoginContrl new];
//            login.isFrom_homePage = YES;
//            [self.navigationController pushViewController:login animated:YES];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = NO;
     [self.navigationController.navigationBar navBarBackGroundColor:RGBColor(33, 33, 33) image:nil isOpaque:YES];
    [self queryData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - getter
-(UIScrollView *)scroView{
    if (!_scroView) {
        _scroView = [[UIScrollView alloc] init];
        CGFloat orgy = NavigationBarBottom(self.navigationController.navigationBar);
        CGFloat height = SCREEN_HEIGHT - orgy - Height_TabBar;
        _scroView.frame = CGRectMake(0,orgy, SCREEN_WIDTH, height);
        [_scroView addSubview:self.first];
        _scroView.contentSize = CGSizeMake(0, self.first.height);
        _scroView.showsVerticalScrollIndicator = NO;
        NSLog(@"_scroView.frame = %@", NSStringFromCGRect(_scroView.frame));
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
@end
