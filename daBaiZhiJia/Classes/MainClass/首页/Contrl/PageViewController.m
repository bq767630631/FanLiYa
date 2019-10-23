//
//  PageViewController.m
//  NavTabScrollView
//
//  Created by tashaxing on 9/15/16.
//  Copyright © 2016 tashaxing. All rights reserved.
//

#import "PageViewController.h"
#import <WebKit/WebKit.h>
#import "Home_headView.h"
#import "GoodDetailContrl.h"
#import "SearchResulModel.h"
#import "Home_AdVerView.h"
#import "HomePage_Model.h"
#import "Home_zbyView.h"
#import "Home_FlashSale.h"
#import "Home_EveeChoiView.h"
#import "New_HomeFlashSale.h"
#import "BrandSpecialArea.h"
#import "HomePage_NewPersonPopV.h"
#import "MSLaunchView.h"

#import "HomePage_UpdateV.h"
#import "MessageManger.h"
#import "ShenQianJiaoChenContrl.h"
#import "DetailWebContrl.h"
#import "ShowPopVManager.h"

#define DateKey  @"DateKey"
#define DateKey_UpDate  @"DateKey_UpDate" //更新V
@interface PageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scroView;

@property (nonatomic, strong) Home_headView*head;

@property (nonatomic, strong) Home_AdVerView*adverView; //广告

@property (nonatomic, strong) Home_zbyView*zbyView; //直播鸭

@property (nonatomic, strong) Home_FlashSale*flashSaView; //限时购

@property (nonatomic, strong) New_HomeFlashSale *sec_flashSaView; //改版限时购

@property (nonatomic, strong) BrandSpecialArea *brandView; //品牌专区

@property (nonatomic, strong) Home_EveeChoiView*evDayView; //每日精选

@property (nonatomic, strong) UIButton *shenQianBtn;

@property (nonatomic, strong) UIButton *scroTopBtn;

@property (nonatomic, strong) NSMutableArray *goodArr; //每日精选的商品

@property (nonatomic, assign) BOOL haveNoMoreData;  //没有更多数据。 默认是否

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) CGFloat scro_ConteH; //scroViewn内容高度

@property (nonatomic, assign) BOOL allRequestComp;  //所有请求完成

@property (nonatomic, strong) HomePage_bg_bannernfo *popInfo;//弹窗模型
@property (nonatomic, assign) BOOL  appBecomeActive;
@end

@implementation PageViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.page = 1;
    [self.view addSubview:self.scroView];
    [self.view addSubview:self.scroTopBtn];
    [self.view addSubview:self.shenQianBtn];
    [self queryBroadCastData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshData) name:HomePageRefresh_NotiFacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)setBannerArr:(NSMutableArray *)bannerArr{
    _bannerArr = bannerArr;
    self.head.bannerArr = bannerArr;
}

- (void)reFreshData{
    [self queryBroadCastData];
}

- (void)applicationBecomeActive{
    self.appBecomeActive = YES;
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    self.head.myScroview.autoScroll = YES;
    NSLog(@"%d", self.appBecomeActive);
}

- (void)listDidDisappear {
    self.head.myScroview.autoScroll = NO;
}

- (void)queryBroadCastData{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [HomePage_Model queryBroadCastWithBlock:^(BOOL is_showNew, NSMutableArray *broadsArr, NSError *error) {
          dispatch_group_leave(group);
        if (broadsArr) {
            [self.adverView setBroadCastInfoWith:is_showNew strArr:broadsArr];
        }
    }];
     dispatch_group_enter(group);
    [HomePage_Model queryMiddleAdverseWithBlock:^(NSMutableArray *adArr, NSError *error) {
        dispatch_group_leave(group);
        if (adArr) {
            [self.adverView setAdvInfoWithArr:adArr];
        }
    }];
       dispatch_group_enter(group);
    [HomePage_Model queryZbyGoodWithBlock:^(NSMutableArray *goodArr, NSError *erro) {
        dispatch_group_leave(group);
        if (goodArr) {
            [self.zbyView setInfoWithModel:goodArr];
        }
    }];
     dispatch_group_enter(group);
    [HomePage_Model queryFlashSaleWithBlock:^(NSMutableArray *timeArr, NSMutableArray *goodArr, NSInteger timeDiff,NSError *error) {
          dispatch_group_leave(group);
        if (timeArr) {
            [self.sec_flashSaView setInfoWith:timeArr goodArr:goodArr];
            [self.head setInfoWith:timeArr goodArr:goodArr];
        }
    }];
    
      dispatch_group_enter(group);
    [HomePage_Model queryBrandinfoArrWithBlock:^(NSMutableArray *list, NSError *error) {
        NSLog(@"queryBrandinfoArr");
          dispatch_group_leave(group);
        if (list) {
            [self.brandView setInfoWithModel:list];
        }
    }];
      dispatch_group_enter(group);
    [HomePage_Model queryAppTopSideWithBlock:^(id res, NSError *error) {
          dispatch_group_leave(group);
       // NSLog(@"queryAppTopSide");
        if (res) {
            self.popInfo = res;
            BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"];
            if (isFirstLaunch) {//如果有引导页
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstLaunch"];
                [[NSUserDefaults standardUserDefaults]  synchronize];
                NSLog(@"如果有引导页");
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideVLoadFinsh) name:GuideViewLoadFinishNotification object:nil];
            }else{//
                [self showPopV:1];
            }
        }
    }];
    
     dispatch_group_enter(group);
    [self queryEveryDataWithGroup:group];
    
      dispatch_group_enter(group);
    [HomePage_Model queryTianMaoUrlWithBlock:^(NSString *tmCS, NSString *tmGJ) {
        //NSLog(@"queryTianMaoUrl");
           dispatch_group_leave(group);
        if (tmCS&&tmGJ) {
            self.head.tmcs = tmCS;
            self.head.tmgj = tmGJ;
        }
    }];
      dispatch_group_enter(group);
    [HomePage_Model queryAppSoreInfoWithCallBack:^(NSUInteger res) {
          dispatch_group_leave(group);
//        NSLog(@"is_Force_Update %d", is_Force_Update);
        if (res ==1) {
            
            if (is_Force_Update) { //强制更新，每次都出现
                HomePage_UpdateV *up = [HomePage_UpdateV viewFromXib];
                up.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                [up show];
            }else{ //一天出现一次
                [self showPopV:2];
            }
        }
    }];
    
     dispatch_group_enter(group);
    [HomePage_Model queryMenuSceneWithBlock:^(NSMutableArray *list, NSError *error) {
        dispatch_group_leave(group);
        if (list) {
            self.head.menuList = list;
        }
        
    }];
    
    @weakify(self);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        @strongify(self);
        NSLog(@"请求完成");
        [self.scroView.mj_header endRefreshing];
        [self.scroView.mj_footer endRefreshing];
        self.allRequestComp = YES;
        self.scro_ConteH +=  self.head.height;
        self.scro_ConteH +=  self.adverView.height;
        self.scro_ConteH +=  self.zbyView.height;
        self.scro_ConteH +=  self.sec_flashSaView.height;
        self.scro_ConteH +=  self.brandView.height;
        self.scro_ConteH +=  self.evDayView.height;
        
        self.adverView.top = self.head.bottom;
        self.zbyView.top = self.adverView.bottom;
        self.sec_flashSaView.top = self.zbyView.bottom;
        self.brandView.top = self.sec_flashSaView.bottom;
        self.evDayView.top = self.brandView.bottom;
        //NSLog(@"scro_ConteH ==%.f",self.scro_ConteH);
        self.scroView.contentSize = CGSizeMake(0,  self.scro_ConteH);
        self.scro_ConteH -=  self.evDayView.height;

        if ([MessageManger shareMessage].remoteNotification) {
            [MessageManger handleMessageWithInfo:[MessageManger shareMessage].remoteNotification];
        }
        //如果有粘贴板有内容就弹出来
        [[ShowPopVManager shareInstance] showPopV];
    });
}

//查询每日精选
- (void)queryEveryDataWithGroup:(dispatch_group_t)group{
    NSDictionary *dict = @{@"page":@(self.page),@"token":ToKen,@"v":APP_Version};
 //   NSLog(@"每日精选 dict =%@",dict.mj_keyValues);
    if (self.haveNoMoreData) {
        [self.scroView.mj_footer endRefreshing];
        [self.scroView.mj_header endRefreshing];
        [self.scroView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [PPNetworkHelper POST:URL_Add(@"/v.php/index.index/jingxuan") parameters:dict success:^(id responseObject) {
        if (group) {
              dispatch_group_leave(group);
        }
      
        //NSLog(@"推荐 responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSArray *listArray = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            for (SearchResulGoodInfo *info in listArray) {
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
            }
            if (listArray.count  ||self.page != 1) { //第一页有数据或者第二页起进来
                NSInteger totalPage = [responseObject[@"data"][@"totalPage"] integerValue];
                NSInteger currPage = [responseObject[@"data"][@"page"] integerValue];
             
                if (currPage >= totalPage) { // 当前页数等于最大页数 提示没有更多数据
                    self.haveNoMoreData = YES;
                    [self.scroView.mj_footer endRefreshing];
                    [self.scroView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    self.haveNoMoreData = NO;
                }
                
                if (listArray.count) { //通知有数据。
                    if (self.page == 1) {
                        self.goodArr = listArray.mutableCopy;
                    }else{
                        [self.goodArr addObjectsFromArray:listArray];
                    }
                    self.page = currPage;
                    [self.scroView.mj_footer endRefreshing];
                    [self.scroView.mj_header endRefreshing];
                    [self.evDayView everyCollecNoticeDataWithArr:self.goodArr];
                    if (self.allRequestComp) {
                     
                        self.scro_ConteH +=  self.evDayView.height;
                        self.scroView.contentSize = CGSizeMake(0,  self.scro_ConteH);
                        self.scro_ConteH -=  self.evDayView.height;
                    }
                }
                
            }else{  //没数据 空白页
                self.haveNoMoreData = YES;
                [self.goodArr removeAllObjects]; //没数据就清空 防止出错
            }
        }else{//请求失败
            [self.scroView.mj_footer endRefreshing];
            [self.scroView.mj_footer endRefreshingWithNoMoreData];
            if (code == NoDataCode) {
                //self.blankView.hidden = NO;
            }
        }
        
    } failure:^(NSError *error) {
        [self.scroView.mj_footer endRefreshing];
        [self.scroView.mj_header endRefreshing];
        if (group) {
             dispatch_group_leave(group);
        }
       
        NSLog(@"error %@",error);
    }];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offY = scrollView.contentOffset.y;
     self.scroTopBtn.hidden = offY < self.head.bottom;
     self.head.myScroview.autoScroll = offY < self.head.myScroview.bottom;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.2 animations:^{
         self.shenQianBtn.mj_x = SCREEN_WIDTH - 18;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.2 animations:^{
         self.shenQianBtn.mj_x = SCREEN_WIDTH - 65;
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [UIView animateWithDuration:0.2 animations:^{
             self.shenQianBtn.mj_x = SCREEN_WIDTH - 65;
        }];
    }
}

#pragma mark - actions
- (void)gotoTopAction{
    [self.scroView scrollToTop];
}

- (void)clickjiaoChenAction{
      DetailWebContrl *detailweb = [[DetailWebContrl alloc] initWithUrl:[NSString stringWithFormat:@"%@?&token=%@",@"http://app.dabaihong.com/appShare/show.html",ToKen] title:@"" para:nil];
    [self.naviContrl pushViewController:detailweb animated:YES];
}

#pragma mark - 通知action
- (void)guideVLoadFinsh{
    [self showPopV:1];
}

//远程消息
- (void)handleRemoteNotification:(NSDictionary*)info{
   // [MessageManger handleMessageWithInfo:info];
}

#pragma mark - private
//显示弹窗 type:1 广告弹窗,2更新弹窗
- (void)showPopV:(NSInteger)type{//
    NSString *key = DateKey;
    if (type == 2) {
        key = DateKey_UpDate;
    }
    NSString *dateStr     =  [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSString *cur_datestr =  [NSString getDateStrByDate:[NSDate date]];
   //  NSLog(@"dateStr1 %@",dateStr);
    // NSLog(@"curDate %@",cur_datestr);
    //如果当前年月日和本地的不一样就展示；
    if ([dateStr isEqualToString:cur_datestr]) {
        return;
    }
    [self delayDoWork:0.5 WithBlock:^{
        if (type==1) {
            HomePage_NewPersonPopV *pop = [HomePage_NewPersonPopV viewFromXib];
            pop.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            pop.navi = self.naviContrl;
            pop.info = self.popInfo;
            [pop show];
        }else if (type==2){
            HomePage_UpdateV *up = [HomePage_UpdateV viewFromXib];
            up.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [up show];
        }
       
        NSString *dateStr = [NSString getDateStrByDate:[NSDate date]];
       // NSLog(@"dateStr2 %@",dateStr);
        [[NSUserDefaults standardUserDefaults] setValue:dateStr forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}




#pragma mark - getter
- (UIScrollView *)scroView{
    if (!_scroView) {
        
        _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.viewH)];//53=titleViewH
        [_scroView addSubview:self.head];
        [_scroView addSubview:self.adverView];
        [_scroView addSubview:self.zbyView];
        [_scroView addSubview:self.sec_flashSaView];
        [_scroView addSubview:self.brandView];
        [_scroView addSubview:self.evDayView];
        NSLog(@"page.scroViewscroView.frame %@",NSStringFromCGRect(_scroView.frame));
        _scroView.showsVerticalScrollIndicator = NO;
        _scroView.delegate = self;
        @weakify(self);
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self queryEveryDataWithGroup:nil];
        }];
        _scroView.mj_footer = footer;
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
              self.scro_ConteH = 0;
              self.page = 1;
              self.allRequestComp = NO;
            [self queryBroadCastData];
        }];
        [head setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        _scroView.mj_header = head;
    }
    return _scroView;
}


- (Home_headView *)head{
    if (!_head) {
        _head = [Home_headView viewFromXib];
        _head.frame = CGRectMake(0, 0, SCREEN_WIDTH, _head.height);
    }
    return _head;
}

- (Home_AdVerView *)adverView{
    if (!_adverView) {
        _adverView = [Home_AdVerView viewFromXib];
        _adverView.frame = CGRectMake(0, self.head.bottom, SCREEN_WIDTH, 468.f);
    }
    return _adverView;
}
- (Home_zbyView *)zbyView{
    if (!_zbyView) {
        _zbyView = [Home_zbyView viewFromXib];
        _zbyView.frame = CGRectMake(0, self.adverView.bottom, SCREEN_WIDTH, 260.f);
    }
    return _zbyView;
}

- (New_HomeFlashSale *)sec_flashSaView{
    if (!_sec_flashSaView) {
        _sec_flashSaView = [New_HomeFlashSale viewFromXib];
        _sec_flashSaView.frame = CGRectMake(0, self.zbyView.bottom, SCREEN_WIDTH, 185);
    }
    return _sec_flashSaView;
}

- (BrandSpecialArea *)brandView{
    if (!_brandView) {
        _brandView = [BrandSpecialArea viewFromXib];
        _brandView.frame = CGRectMake(0, self.sec_flashSaView.bottom, SCREEN_WIDTH, 190);
    }
    return _brandView;
}

- (Home_EveeChoiView *)evDayView{
    if (!_evDayView) {
        _evDayView = [Home_EveeChoiView viewFromXib];
        _evDayView.frame = CGRectMake(0, self.brandView.bottom, SCREEN_WIDTH, 1000);
    }
    return _evDayView;
}

- (UIButton *)scroTopBtn{
    if (!_scroTopBtn) {
        _scroTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scroTopBtn.frame = CGRectMake(SCREEN_WIDTH -32- 13, self.viewH - 32  -20, 32, 32);
        [_scroTopBtn addTarget:self action:@selector(gotoTopAction) forControlEvents:UIControlEventTouchUpInside];
        [_scroTopBtn setImage:ZDBImage(@"icon_top") forState:UIControlStateNormal];
        _scroTopBtn.hidden= YES;
    }
    return _scroTopBtn;
}

- (UIButton *)shenQianBtn{
    if (!_shenQianBtn) {
        _shenQianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat orgy = 320;
        if (IS_iPhone5SE) {
            orgy = 280;
        }
        _shenQianBtn.frame = CGRectMake(SCREEN_WIDTH - 65, orgy, 68, 57.5);
        [_shenQianBtn setImage:ZDBImage(@"img_shengqianjiaocheng") forState:UIControlStateNormal];
        [_shenQianBtn addTarget:self action:@selector(clickjiaoChenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shenQianBtn;
}

- (NSMutableArray *)goodArr{
    if (!_goodArr) {
        _goodArr = [NSMutableArray array];
    }
    return _goodArr;
}

@end
