//
//  MyCombatContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyCombatContrl.h"
#import "MyCombat_ContentV.h"
#import "MyCombat_Model.h"
#import "MyCombat_Bottom.h"
@interface MyCombatContrl ()
@property (nonatomic, strong) UIScrollView *scroView;

@property (nonatomic, strong) MyCombat_Bottom *bottom;

@property (nonatomic, strong) MyCombat_ContentV *contentV;
@end

@implementation MyCombatContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日战绩";
      [self.view addSubview:self.bottom];
    [self.view addSubview:self.scroView];
    [self queryData];
}

- (void)queryData{
    [MyCombat_Model queryDataWithBlock:^(MyCombat_Info *info, NSError *error) {
        if (info) {
            [self.contentV setModel:info];
            self.bottom.contentV = self.contentV;
            //self.bottom.shareimg = self.contentV.shareimg;
        }else{
            [self.scroView removeFromSuperview];
        }
    }];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scroView.contentSize = CGSizeMake(0, self.contentV.height);
    NSLog(@" self.contentV.height =%.f", self.contentV.height);
}

#pragma mark - getter
- (MyCombat_Bottom *)bottom{
    if (!_bottom) {
        _bottom = [MyCombat_Bottom viewFromXib];
        CGFloat height = 130.f;
        CGFloat orgy = SCREEN_HEIGHT - height;
        if (IS_X_Xr_Xs_XsMax) {
            orgy -= Bottom_Safe_AreaH;
        }
        _bottom.frame = CGRectMake(0, orgy, SCREEN_WIDTH, height);
    }
    return _bottom;
}

- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat orgy = NavigationBarBottom(self.navigationController.navigationBar);
        CGFloat height = SCREEN_HEIGHT - orgy - self.bottom.height;
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH;
        }
        CGRect rec = CGRectMake(0 , orgy , SCREEN_WIDTH, height);
        _scroView = [[UIScrollView alloc] initWithFrame:rec];
        _scroView.showsVerticalScrollIndicator = NO;
        [_scroView addSubview:self.contentV];
        
    }
    return _scroView;
}

- (MyCombat_ContentV *)contentV{
    if (!_contentV) {
        _contentV = [MyCombat_ContentV viewFromXib];
        _contentV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    }
    return _contentV;
}

@end
