//
//  PingDuoduoPageHomecontrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PingDuoduoPageHomecontrl.h"
#import "PingDuoduoHomeModel.h"
#import "PingDuoduoHomeHeadV.h"
#import "Home_SecSingleCell.h"
#import "GoodDetailContrl.h"
#define Cell_H 139.f
@interface PingDuoduoPageHomecontrl ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) PingDuoduoHomeHeadV *headV;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排一个视图

@property (nonatomic, strong) UIButton *scroTopBtn;

@property (nonatomic, strong) NSMutableArray *goodArr;

@property (nonatomic, assign) BOOL haveNoMoreData;  //没有更多数据。 默认是否

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) CGFloat scro_ConteH; //scroViewn内容高度

@property (nonatomic, assign) BOOL allRequestComp;  //所有请求完成
@end
static NSString *cellId = @"cellId";
@implementation PingDuoduoPageHomecontrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self queryBroadCastData];
}

- (void)setUp{
    self.page = 1;
    [self.view addSubview:self.scroView];
    [self.view addSubview:self.scroTopBtn];
}

- (void)queryBroadCastData{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [PingDuoduoHomeModel queryBannerWithpt:self.pt Block:^(id res, NSError *error) {
           dispatch_group_leave(group);
        if (res) {
            self.headV.bannerArr = res;
        }
    }];
    dispatch_group_enter(group);
    [self queryEveryDataWithGroup:group];
     @weakify(self);
    dispatch_group_notify(group,  dispatch_get_main_queue(), ^{
        @strongify(self);
        NSLog(@"请求完成");
        
        [self.scroView.mj_header endRefreshing];
        [self.scroView.mj_footer endRefreshing];
        self.allRequestComp = YES;
        self.scro_ConteH +=  self.headV.height;
        self.scro_ConteH +=  self.goodArr.count *Cell_H;
        
        self.collectionView.top = self.headV.bottom;
        self.scroView.contentSize = CGSizeMake(0, self.scro_ConteH);
    });
}

//查询商品
- (void)queryEveryDataWithGroup:(dispatch_group_t)group{
    NSDictionary *dict = @{@"page":@(self.page),@"cid":self.cid,@"token":ToKen,@"v":APP_Version};
       NSLog(@"精选 dict =%@",dict.mj_keyValues);
    if (self.haveNoMoreData) {
        [self.scroView.mj_footer endRefreshing];
        [self.scroView.mj_header endRefreshing];
        [self.scroView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
      NSString *url = (self.pt == FLYPT_Type_Pdd) ?@"/v.php/goods.pdd/getGoodsList":@"/v.php/goods.jd/getGoodsList";
    [PPNetworkHelper POST:URL_Add(url) parameters:dict success:^(id responseObject) {
        if (group) {
            dispatch_group_leave(group);
        }
       // NSLog(@"精选 responseObject %@",responseObject);
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
                    [self.collectionView reloadData];
                    self.collectionView.height = self.goodArr.count * Cell_H;
                    if (self.allRequestComp) {//上拉加载更多
                        
                        self.scro_ConteH += listArray.count * Cell_H;
                        self.scroView.contentSize = CGSizeMake(0,  self.scro_ConteH);
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
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    info.is_From_PddOrJd = YES;
    Home_SecSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell setModel:info];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     return CGSizeMake(SCREEN_WIDTH, Cell_H);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    detail.pt = self.pt;
    [self.naviContrl pushViewController:detail animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offY = scrollView.contentOffset.y;
    //    NSLog(@"offY =%.f",offY);
    self.scroTopBtn.hidden = offY < self.headV.bottom;
   // self.head.myScroview.autoScroll = offY < self.head.myScroview.bottom;
}


- (void)gotoTopAction{
    [self.scroView scrollToTop];
}


- (void)refreshData{
    self.scro_ConteH = 0;
    self.page = 1;
    self.allRequestComp = NO;
    [self queryBroadCastData];
}

#pragma mark - getter
- (UIScrollView *)scroView{
    if (!_scroView) {
          _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.viewH)];
        [_scroView addSubview:self.headV];
        [_scroView addSubview:self.collectionView];
        _scroView.delegate = self;
        @weakify(self);
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self queryEveryDataWithGroup:nil];
        }];
        _scroView.mj_footer = footer;
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
           
            [self refreshData];
        }];
        [head setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        _scroView.mj_header = head;
    }
    return _scroView;
}

- (PingDuoduoHomeHeadV *)headV{
    if (!_headV) {
        _headV = [PingDuoduoHomeHeadV viewFromXib];
        _headV.frame = CGRectMake(0, 0, SCREEN_WIDTH, _headV.height);
        _headV.pt = self.pt;
    }
    return _headV;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGRect frame = CGRectMake(0, self.headV.bottom, SCREEN_WIDTH, 300);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.singleLayout];
        _collectionView.dataSource  = self;
        _collectionView.delegate    = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = RGBColor(242, 242, 242);
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Home_SecSingleCell class]) bundle:nil] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)singleLayout{
    if (!_singleLayout) {
        _singleLayout = [[UICollectionViewFlowLayout alloc] init];
        _singleLayout.minimumLineSpacing = 0;
        _singleLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _singleLayout;
}


- (UIButton *)scroTopBtn{
    if (!_scroTopBtn) {
        _scroTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scroTopBtn.frame = CGRectMake(self.view.width -32- 13, self.viewH - 32  - 20 - Height_TabBar, 32, 32);
        [_scroTopBtn addTarget:self action:@selector(gotoTopAction) forControlEvents:UIControlEventTouchUpInside];
        [_scroTopBtn setImage:ZDBImage(@"icon_top") forState:UIControlStateNormal];
        _scroTopBtn.hidden= YES;
        [self.view addSubview:_scroTopBtn];
    }
    return _scroTopBtn;
}

- (NSMutableArray *)goodArr{
    if (!_goodArr) {
        _goodArr = [NSMutableArray array];
    }
    return _goodArr;
}
@end
