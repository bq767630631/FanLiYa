//
//  GoodDetailContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailContrl.h"
#import "GoodDetailModel.h"
#import "GoodDetailHeadView.h"

#import "GoodDetailSegment.h"
#import "GoodDetailBottom.h"
#import "GoodDetailTop.h"
#import "GoodDetail_Barrage.h"
#import "MJProxy.h"
#import "GoodDetail_ShengjiV.h"
#import "MyCollecTionContrl.h"
#import "LoginContrl.h"
#import "GoodDetailInvalidV.h"

@interface GoodDetailContrl ()<UIScrollViewDelegate,GoodDetailModelDelegate>

@property (nonatomic, copy) NSString *sku;

@property (nonatomic, strong) GoodDetailTop *topView;

@property (nonatomic, strong) GoodDetail_Barrage *barRage;//弹幕

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, strong) GoodDetailModel *model;

@property (nonatomic, strong) UIScrollView *scroView;

@property (nonatomic, strong) UIButton *returnBtn;

@property (nonatomic, strong) UIButton *scroTopBtn;

@property (nonatomic, strong) GoodDetailHeadView *headView;

@property (nonatomic, strong) GoodDetailBottom *boottom;

@property (nonatomic, strong) GoodDetailSegment *segMenu;

@property (nonatomic, strong) GoodDetail_ShengjiV *shenJiV;

@property (nonatomic, strong) NSArray *goodArr;//推荐商品

@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, strong) CouponListBlankView *blankView;

@property (nonatomic, assign) NSInteger cur_index;//显示当前的弹幕内容

@property (nonatomic, strong) NSMutableArray *barrageArr;//弹幕内容数组

@end

@implementation GoodDetailContrl

- (instancetype)initWithSku:(NSString*)sku{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.sku = sku;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.model queryData];
//    [self.model queryIsCollection];
//    [self.model queryViewPeople];
//    self.navigationItem.titleView = self.segMenu;
    [self initRightBarButtonWithImage:@"icon_like_top"];
}

- (void)onTapRightBarButton{
    if ([self judgeisLogin]) {
          [self.navigationController pushViewController:[MyCollecTionContrl new] animated:YES];
    }
}

- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0&&token.length >0) {
        return YES;
    }else{
        [self.navigationController pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
}

- (void)dealloc{
    NSLog(@"");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar navBarBackGroundColor:RGBColor(34, 34, 34) image:nil isOpaque:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - GoodDetailModelDelegate
- (void)detailModel:(GoodDetailModel *)model querySucWithDetailInfo:(GoodDetailInfo *)info tuiJianArr:(NSMutableArray *)arr{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationItem.titleView = self.segMenu;
    [self.timer fire];
    [self.view addSubview:self.scroView];
    [self.view addSubview:self.boottom];
    [self.view addSubview:self.scroTopBtn];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.barRage];
   
    self.goodArr = arr;
    [self.headView setInfo:info tuijianArr:arr];
    [self.boottom setInfo:info];
    [self.shenJiV setInfo:info.profit_up];
    [self.boottom handleIsCollection:info.is_favorite];
     self.blankView.hidden = YES;
    self.topView.info = info;
    [self.model queryViewPeople];
}

- (void)detailModel:(GoodDetailModel *)model queryFail:(id)res{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"商品详情";
    GoodDetailInvalidV *inaV = [GoodDetailInvalidV viewFromXib];
    inaV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:inaV];
}

- (void)detailModel:(GoodDetailModel *)model noticeError:(NSError *)error{
    
    self.blankView.hidden = NO;
    [self.timer invalidate];
    BlankViewInfo *info = [BlankViewInfo infoWithNoticeNetError];
    [self.blankView setModel:info];
    @weakify(self);
    self.blankView.block = ^{
        @strongify(self);
        [self.model queryData];
    };
}

- (void)detailModel:(GoodDetailModel *)model isCollection:(BOOL)isCollection{
    [self.boottom handleIsCollection:isCollection];
}

- (void)detailModel:(GoodDetailModel *)model viewPeople:(NSMutableArray *)arr{
    self.barrageArr = arr;
    [self.timer fire];
}

#pragma mark - Action
- (void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//弹幕动画
- (void)doAniMation{
    [self.barRage startAnimation];
    [self.barRage setModel:self.barrageArr[self.cur_index]];
    [self delayDoWork:2 WithBlock:^{
        [self.barRage disMis];
    }];
    NSInteger count = self.barrageArr.count;
    if (self.cur_index < count) {
        self.cur_index ++;
        self.cur_index = (self.cur_index == count)?0: self.cur_index;
    }else if (self.cur_index == count){
        self.cur_index = 0;
    }
}

- (void)gotoTopAction{
      [self.scroView scrollToTop];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offy = scrollView.contentOffset.y;
//    NSLog(@"offy =%.f",offy);
//    NSLog(@"likeView.top  %.f", self.headView.likeView.top);
//    NSLog(@"detailV.top %.f", self.headView.detailV.top);
//    NSLog(@"webTop %.f", self.headView.webTop);
//    NSLog(@"likeVTop %.f", self.headView.likeVTop);
    CGFloat bottom = NavigationBarBottom(self.navigationController.navigationBar);
    self.navigationController.navigationBarHidden = offy < bottom;
    self.scroTopBtn.hidden = offy < self.headView.webTop;
    
    if (!self.segMenu.selfIsClick) {
        if (offy <= self.headView.webTop&& offy>self.headView.likeVTop) {
               [self.segMenu setSegmentToTuiJian];
        }else if (offy >= self.headView.webTop ){
              [self.segMenu setSegmentToDetail];
        }else if (offy ==0 ){
            [self.segMenu setSegmentToDetailToBaobei];
        }
    }
}

#pragma mark - getter
- (GoodDetailTop *)topView{
    if (!_topView) {
        _topView = [GoodDetailTop viewFromXib];
        CGFloat orgy = Height_StatusBar + 5;
        _topView.frame = CGRectMake(0, orgy, SCREEN_WIDTH, 32);
    }
    return _topView;
}

- (GoodDetail_Barrage *)barRage{
    if (!_barRage) {
        _barRage = [GoodDetail_Barrage viewFromXib];
        _barRage.alpha = 0.0;
        _barRage.frame = CGRectMake(12, SCREEN_HEIGHT - 300, 200, 22);
    }
    return _barRage;
}

- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat height = SCREEN_HEIGHT - 50;
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH;
        }
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH,height);
        _scroView = [[UIScrollView alloc] initWithFrame:frame];
        _scroView.delegate = self;
        [_scroView addSubview:self.headView];
         _scroView.showsVerticalScrollIndicator = NO;
        _scroView.contentSize = CGSizeMake(0, 3000);
        @weakify(self);
        self.headView.heightBlock = ^(CGFloat height ,BOOL isSelected) {
            @strongify(self);
            self.scroView.contentSize = CGSizeMake(0, height);
        };
        
    }
    return _scroView;
}

- (GoodDetailSegment *)segMenu{
    if (!_segMenu) {
        _segMenu = [GoodDetailSegment viewFromXib];
        _segMenu.frame = CGRectMake(0,0, SCREEN_WIDTH, 40.f);
         @weakify(self);
        _segMenu.typeBlock = ^(NSInteger type) {
              @strongify(self);
            if (type ==0) {
                [self.scroView scrollToTop];
            }else if (type ==1){
                CGPoint offset = self.scroView.contentOffset;
                offset.y = self.headView.likeVTop;
                   NSLog(@"y = %.f",offset.y);
                [self.scroView setContentOffset:offset animated:YES];
            }else if (type == 2){
                CGPoint offset = self.scroView.contentOffset;
                offset.y = self.headView.webTop;
                NSLog(@"y = %.f",offset.y);
                [self.scroView setContentOffset:offset animated:YES];
            }
            [self delayDoWork:.5 WithBlock:^{
                 self.segMenu.selfIsClick = NO;
            }];
        };
    }
    return _segMenu;
}


- (GoodDetailHeadView *)headView{
    if (!_headView) {
        _headView = [GoodDetailHeadView viewFromXib];
        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1000);
        @weakify(self);
        _headView.segMenu.typeBlock = ^(NSInteger type) {
            @strongify(self);
            if (type ==0) {
                   [self.scroView scrollToTop];
            }else if (type ==1){
                CGPoint offset = self.scroView.contentOffset;
                offset.y = self.headView.webTop;
                NSLog(@"offset.y2 = %.f", offset.y);
                [self.scroView setContentOffset:offset animated:YES];
            }else{
                CGPoint offset = self.scroView.contentOffset;
                offset.y = self.headView.likeVTop;
                   NSLog(@"offset.y3 = %.f", offset.y);
                [self.scroView setContentOffset:offset animated:YES];
            }
        };
    }
    return _headView;
}

- (GoodDetailBottom *)boottom{
    if (!_boottom) {
        _boottom = [GoodDetailBottom viewFromXib];
        CGFloat origy = 0;
        if (IS_X_Xr_Xs_XsMax) {//34 是安全区域的高度
            origy = SCREEN_HEIGHT - 50 - Bottom_Safe_AreaH;
        }else{
            origy = SCREEN_HEIGHT - 50;
        }
        _boottom.frame = CGRectMake(0, origy, SCREEN_WIDTH, 50);
    }
    return _boottom;
}

- (CouponListBlankView *)blankView{
    if (!_blankView) {
        _blankView = [CouponListBlankView viewFromXib];
        CGFloat origy  = NavigationBarBottom(self.navigationController.navigationBar);
        CGFloat height = SCREEN_HEIGHT - origy;
        if (IS_X_Xr_Xs_XsMax) {
            height = SCREEN_HEIGHT - origy - Bottom_Safe_AreaH;
        }
        CGRect frame =CGRectMake(0,origy, SCREEN_WIDTH, height);
        
        _blankView.frame = frame;
        [self.view addSubview:_blankView];
    }
    return _blankView;
}

- (UIButton *)scroTopBtn{
    if (!_scroTopBtn) {
        _scroTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scroTopBtn.frame = CGRectMake(SCREEN_WIDTH -32- 13, self.boottom.top - 32  -20, 32, 32);
        [_scroTopBtn addTarget:self action:@selector(gotoTopAction) forControlEvents:UIControlEventTouchUpInside];
        [_scroTopBtn setImage:ZDBImage(@"icon_top") forState:UIControlStateNormal];
        _scroTopBtn.hidden= YES;
        
    }
    return _scroTopBtn;
}

- (GoodDetail_ShengjiV *)shenJiV{
    if (!_shenJiV) {
        _shenJiV = [GoodDetail_ShengjiV viewFromXib];
        CGFloat orgy = SCREEN_HEIGHT - 120 - 62;
        if (IS_X_Xr_Xs_XsMax) {
            orgy = SCREEN_HEIGHT - 120 - 62 - Bottom_Safe_AreaH;
        }
        _shenJiV.frame = CGRectMake(SCREEN_WIDTH - 66 - 3, orgy, 66, 62);
        @weakify(self);
        _shenJiV.bloock = ^{
            @strongify(self);
            NSLog(@" 调到首页升级赚");
            self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
            self.navigationController.tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _shenJiV;
}

- (GoodDetailModel *)model{
    if (!_model) {
        _model = [[GoodDetailModel alloc] initWithSku:self.sku];
        _model.delegate  = self;
    }
    return _model;
}

- (NSTimer *)timer{
    if (!_timer) {
           _timer =[NSTimer timerWithTimeInterval:5 target:[MJProxy proxyWithTarget:self] selector:@selector(doAniMation) userInfo:nil repeats:YES] ;
          [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

@end
