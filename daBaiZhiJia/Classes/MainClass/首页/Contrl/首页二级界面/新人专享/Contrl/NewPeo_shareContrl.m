//
//  NewPeo_shareContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_shareContrl.h"
#import "NewPeo_shareContentV.h"
#import "NewPeo_shareModel.h"


@interface NewPeo_shareContrl ()
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) NewPeo_shareContentV *contentV;
@end

@implementation NewPeo_shareContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新人专享";
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_retBlack"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.leftBarButtonItem = leftBar;

    [self.view addSubview:self.scroView];
    [self queryData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(countDownEnd) name:NewPeo_CountdownNotifation object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBColor(38, 38, 38) ,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
    [self.navigationController.navigationBar navBarBackGroundColor:UIColor.whiteColor image:nil isOpaque:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor ,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
    [self.contentV.timeV.timer invalidate];
    self.contentV.timeV.timer = nil;
}

- (void)dealloc{
    NSLog(@"");
}

- (void)countDownEnd{
    [self queryData];
}

- (void)queryData{
    [NewPeo_shareModel queryNewPeoGoodWithBlock:^(NSMutableArray *goodArr, NSInteger time, NewPeo_shareRuleInfo *rule, NSError *error) {
        if (goodArr) {
            for (SearchResulGoodInfo *info in goodArr) {
                info.countTime = time;
            }
            [self.contentV setInfoWith:goodArr time:time rule:rule];
            
            self.scroView.contentSize = CGSizeMake(0, self.contentV.height + 20);
        }
    }];
}


- (void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat height = SCREEN_HEIGHT ;
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH ;
        }
        _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [_scroView addSubview:self.contentV];
        _scroView.contentSize = CGSizeMake(0,2000);
    }
    return _scroView;
}

- (NewPeo_shareContentV *)contentV{
    if (!_contentV) {
        _contentV = [NewPeo_shareContentV viewFromXib];
        _contentV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 896);
    }
    return _contentV;
}


@end
