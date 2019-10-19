//
//  DBZJ_CommunityContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_CommunityContrl.h"
#import <AlibabaAuthSDK/albbsdk.h>
#import "DBZJ_CommunityHead.h"
#import "DBZJ_CommunityCell.h"
#import "DBZJ_CommunityModel.h"
#import "DBZJ_ComNewHandCell.h"
#import <WebKit/WebKit.h>


@interface DBZJ_CommunityContrl ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DBZJ_CommunityModelDelegate>
@property (nonatomic, strong) UIView *black_bgV;
@property (nonatomic, strong) DBZJ_CommunityHead *head;
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) UIImageView *bannerV;
@property (nonatomic, strong) UIImageView *bannerV2;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) UITableView *tableView3;

@property (nonatomic, strong) WKWebView *webView; //展示商学院
@property (nonatomic, strong) UIImageView *blankView;
@property (nonatomic, strong) UIButton *scroTopBtn;

@property (nonatomic, strong) DBZJ_CommunityModel *model;
@property (nonatomic, assign) NSInteger type; //1,2,3
@end
static NSString *cellid = @"cellid";
static NSString *newHandCell = @"newHandCell";
@implementation DBZJ_CommunityContrl

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"社区";
    self.view.backgroundColor = RGBColor(245, 245, 245);
     self.type = 1;
    [self.view addSubview:self.black_bgV];
    [self.view addSubview:self.head];
    [self.view addSubview:self.scroView];
    
    [self.model queryRecommendWithType:self.type];
}

- (void)setMenuSelected:(NSInteger)index{
    [self.head setBtnSelectedWithIndex:index];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.jumpToSucai) {
        self.jumpToSucai = NO;
        [self.head setBtnSelectedWithIndex:1];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type ==1) {
        return self.model.RecomArr.count;
    }else if (self.type ==2){
        return self.model.MarketArr.count;
    }
    return self.model.NewHandArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 3) {
        DBZJ_ComNewHandCell *newCell = [tableView dequeueReusableCellWithIdentifier:newHandCell];
        CommunityRecommendInfo *info = self.model.NewHandArr[indexPath.row];
        info.indexPath = indexPath;
        [newCell setInfoWithModel:info];
        return newCell;
    }else{
        DBZJ_CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        CommunityRecommendInfo *info = self.type ==1 ?self.model.RecomArr[indexPath.row] :self.model.MarketArr[indexPath.row];
        info.indexPath = indexPath;
        [cell setInfoWithModel:info];
        return cell;
    }
}

#pragma mark - DBZJ_CommunityModelDelegate
- (void)communityModel:(DBZJ_CommunityModel *)model dataSouse:(NSArray *)dataArr type:(NSInteger)type logo:(nonnull NSString *)logo{
    self.blankView.hidden = YES;
    if (type==1) {
          [self.tableView.mj_header endRefreshing];
          [self.tableView.mj_footer endRefreshing];
          [self.tableView reloadData];
    }else if (type==2 ){
          [self.tableView2.mj_header endRefreshing];
          [self.tableView2.mj_footer endRefreshing];
          [self.tableView2 reloadData];
    }
}

- (void)noticeNomoreDataWithCommunityModel:(DBZJ_CommunityModel *)model type:(NSInteger)type{
    if (type ==1) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else if (type==2){
        [self.tableView2.mj_footer endRefreshing];
        [self.tableView2.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)noticeBlankViewWithModel:(DBZJ_CommunityModel *)model type:(NSInteger)type{
    self.blankView.hidden = NO;
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    if (self.scroView == scrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger index = offsetX /SCREEN_WIDTH;
          self.type = index + 1;
        [self.head setBtnSelectedWithIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offY = scrollView.contentOffset.y;
    self.scroTopBtn.hidden = offY < self.head.bottom;
}

- (void)gotoTopAction{
    if (self.type ==1) {
        [self.tableView scrollToTop];
    }else if (self.type==2){
        [self.tableView2 scrollToTop];
    }
}

#pragma mark - getter
- (UIView *)black_bgV{
    if (!_black_bgV) {
        CGFloat orgy = NavigationBarBottom(self.navigationController.navigationBar);
        CGRect rec = CGRectMake(0, orgy, SCREEN_WIDTH, 200 - orgy);
        _black_bgV = [[UIView alloc] initWithFrame:rec];
        _black_bgV.backgroundColor = ThemeColor;
    }
    return _black_bgV;
}

- (DBZJ_CommunityHead *)head{
    if (!_head) {
        _head = [DBZJ_CommunityHead viewFromXib];
        _head.frame = CGRectMake(0, _black_bgV.top, SCREEN_WIDTH, 50);
        @weakify(self);
        _head.block = ^(NSInteger index) {
            @strongify(self);
            [self.scroView setContentOffset:CGPointMake(index *SCREEN_WIDTH, 0) animated:YES];
            self.type = index + 1;
            self.blankView.hidden = ![self.model showblankViewWithType:self.type];
            if (index==0 && self.model.RecomArr.count ==0) {//没数据请求
                self.model.pageNum_Rec = 1;
                [self.model queryRecommendWithType:self.type];
                
            }else if (index==0) {//有数据显示
                [self.tableView reloadData];
            }
           
            if (index==1 && self.model.MarketArr.count ==0) {//没数据请求
                  self.model.pageNum_Marketing = 1;
                 [self.model queryRecommendWithType:self.type];
            
            }else if (index==1){//有数据显示
                [self.tableView2 reloadData];
            }
            
        };
    }
    return _head;
}

- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat height = SCREEN_HEIGHT - self.head.bottom  - TabBar_H;;
         CGRect frame = CGRectMake(0, self.head.bottom, SCREEN_WIDTH, height);
        _scroView = [[UIScrollView alloc] initWithFrame:frame];
        _scroView.contentSize = CGSizeMake(SCREEN_WIDTH *3, 0);
        _scroView.pagingEnabled = YES;
        _scroView.showsVerticalScrollIndicator = NO;
        _scroView.showsHorizontalScrollIndicator = NO;
        _scroView.delegate = self;
        _scroView.bounces = NO;
        _scroView.backgroundColor = UIColor.clearColor;
        [_scroView addSubview:self.tableView];
        [_scroView addSubview:self.tableView2];
        [_scroView addSubview:self.webView];
    }
    return _scroView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(15, 0, SCREEN_WIDTH- 15*2, self.scroView.height);
         NSString *cell =  NSStringFromClass([DBZJ_CommunityCell class]);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        [_tableView registerNib:[UINib nibWithNibName:cell bundle:nil] forCellReuseIdentifier:cellid];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 425.f;//一定得加 不然加载更多出现问题
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1f)];
        ViewBorderRadius(_tableView, 7, UIColor.clearColor);
        @weakify(self);
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self.model queryRecommendWithType:self.type];
            
        }];
        [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = footer;
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
             self.model.pageNum_Rec = 1;
             self.model.haveNoMoreData_Rec = NO;
             [self.model queryRecommendWithType:1];
        }];
        [head setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        _tableView.mj_header = head;
    }
    return _tableView;
}

- (UITableView *)tableView2{
    if (!_tableView2) {
         CGRect frame = CGRectMake(SCREEN_WIDTH+ 15, 0, SCREEN_WIDTH -15*2, self.scroView.height);
        _tableView2 = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
      
         NSString *cell =  NSStringFromClass([DBZJ_CommunityCell class]);
         [_tableView2 registerNib:[UINib nibWithNibName:cell bundle:nil] forCellReuseIdentifier:cellid];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        
        _tableView2.backgroundColor = UIColor.whiteColor;
        _tableView2.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 332.f;//一定得加 不然加载更多出现问题
        _tableView2.showsVerticalScrollIndicator = NO;
        _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        ViewBorderRadius(_tableView2, 7, UIColor.clearColor);
        _tableView2.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1f)];
        @weakify(self);
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self.model queryRecommendWithType:self.type];
            
        }];
        [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
        _tableView2.mj_footer = footer;
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.model.pageNum_Marketing = 1;
            self.model.haveNoMoreData_Marketing = NO;
            [self.model queryRecommendWithType:self.type];
        }];
        [head setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        _tableView2.mj_header = head;
    }
    
    return _tableView2;
}

- (UITableView *)tableView3{
    if (!_tableView3) {
        CGRect frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, self.scroView.height);
        _tableView3 = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        UIView *tableHed = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1f)];
        _tableView3.tableHeaderView = tableHed;
        _tableView3.backgroundColor = RGBColor(245, 245, 245);
        NSString *cell =  NSStringFromClass([DBZJ_ComNewHandCell class]);
        [_tableView3 registerNib:[UINib nibWithNibName:cell bundle:nil] forCellReuseIdentifier:newHandCell];
        _tableView3.delegate   = self;
        _tableView3.dataSource = self;
        _tableView3.rowHeight = 180 *SCREEN_WIDTH/375 + 45;
        _tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView3.backgroundColor = UIColor.whiteColor;
        @weakify(self);
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self.model queryRecommendWithType:self.type];
        }];
        [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
        _tableView3.mj_footer = footer;
    }
    
    return _tableView3;
}

-(WKWebView *)webView{
    if (!_webView) {
         CGRect frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, self.scroView.height);
        _webView = [[WKWebView alloc] initWithFrame:frame];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@",BASE_WEB_URL,@"businessSchool.html",ToKen]]];
        [_webView loadRequest:req];
    }
    return _webView;
}

- (UIButton *)scroTopBtn{
    if (!_scroTopBtn) {
        _scroTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scroTopBtn.frame = CGRectMake(SCREEN_WIDTH -32- 13,SCREEN_HEIGHT - Height_TabBar - 32  - 20, 32, 32);
        [_scroTopBtn addTarget:self action:@selector(gotoTopAction) forControlEvents:UIControlEventTouchUpInside];
        [_scroTopBtn setImage:ZDBImage(@"icon_top") forState:UIControlStateNormal];
        _scroTopBtn.hidden= YES;
        [self.view addSubview:_scroTopBtn];
    }
    return _scroTopBtn;
}

- (UIImageView *)blankView{
    if (!_blankView) {
        _blankView = [[UIImageView alloc] initWithImage:ZDBImage(@"img_nodata_loading")];
        _blankView.center = self.scroView.center;
        [self.view addSubview:_blankView];
    }
    return _blankView;
}

- (UIImageView *)bannerV{
    if (!_bannerV) {
        _bannerV = [UIImageView new];
        CGFloat sca = 345.0/140;
       _bannerV.height =  (SCREEN_WIDTH - 30)/sca;
    }
    return _bannerV;
}

- (UIImageView *)bannerV2{
    if (!_bannerV2) {
        _bannerV2 = [UIImageView new];
        CGFloat sca = 345.0/140;
        _bannerV2.height =  (SCREEN_WIDTH - 30)/sca;
    }
    return _bannerV2;
}

- (DBZJ_CommunityModel *)model{
    if (!_model) {
        _model = [DBZJ_CommunityModel new];
        _model.delegate = self;
    }
    return _model;
}


@end
