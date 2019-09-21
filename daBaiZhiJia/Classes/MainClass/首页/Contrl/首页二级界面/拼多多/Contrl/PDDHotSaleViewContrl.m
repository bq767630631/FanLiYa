//
//  PDDHotSaleViewContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PDDHotSaleViewContrl.h"
#import "PDDHotSaleMenu.h"
#import "SearchResulModel.h"
#import "Home_SecSingleCell.h"
#import "GoodDetailContrl.h"

#define Cell_H 139.f
#define Menu_H 41.f
@interface PDDHotSaleViewContrl ()<UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scroview;
@property (nonatomic, strong) UIImageView *bannerImageV;
@property (nonatomic, strong) PDDHotSaleMenu *menu;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排一个视图
@property (nonatomic, strong) UIImageView *blankView;
@property (nonatomic, strong) UIButton *scroTopBtn;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger sort_type;//1-实时热销榜；2-实时收益榜
@property (nonatomic, assign) BOOL haveNoMoreData;  //没有更多数据。 默认是否
@property (nonatomic,strong) NSMutableArray *searchGoodsArr;
@end

static NSString *tableCellId = @"tableCellId";

@implementation PDDHotSaleViewContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热销排行";
    [self setUp];
    [self questData];
}

- (void)setUp{
    self.page  = 1;
    self.sort_type = 1;
    [self.view addSubview:self.scroview];
}
- (void)questData{
    NSDictionary *dict = @{@"sort_type":@(self.sort_type),@"page":@(self.page),@"token":ToKen,@"v":APP_Version};
    
    NSLog(@"dict =%@",dict.mj_keyValues);
    if (self.haveNoMoreData) {
        [self.scroview.mj_footer endRefreshing];
        [self.scroview.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.pdd/top") parameters:dict success:^(id responseObject) {
        NSLog(@"responseObject %@",responseObject);
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
                    [self.scroview.mj_footer endRefreshing];
                    [self.scroview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    self.haveNoMoreData = NO;
                }
                
                if (listArray.count) { //通知有数据。
                    self.blankView.hidden = YES;
                    if (self.page == 1) {
                        self.searchGoodsArr = listArray.mutableCopy;
                    }else{
                        [self.searchGoodsArr addObjectsFromArray:listArray];
                    }
                    self.page = currPage;
                    [self.scroview.mj_footer endRefreshing];
                }else{
                    self.blankView.hidden = NO;
                }
                [self reloadeData];
            }else{  //没数据 空白页
                self.blankView.hidden = NO;
                self.haveNoMoreData = YES;
                [self.searchGoodsArr removeAllObjects]; //没数据就清空 防止出错
                [self.scroview.mj_footer endRefreshing];
                [self.scroview.mj_footer endRefreshingWithNoMoreData];
                [self reloadeData];
            }
        }else{//请求失败
            self.blankView.hidden = NO;
            self.haveNoMoreData = YES;
            [self.searchGoodsArr removeAllObjects]; //没数据就清空 防止出错
            [self.scroview.mj_footer endRefreshing];
            [self.scroview.mj_footer endRefreshingWithNoMoreData];
            [self reloadeData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}

- (void)reloadeData{
    CGFloat contentH = Menu_H + self.bannerImageV.height +  10;
    CGFloat tb_h = self.searchGoodsArr.count *Cell_H;
    CGRect frame = self.collectionView.frame;
    frame.size.height = tb_h;
    self.collectionView.frame = frame;
    [self.collectionView reloadData];
    self.scroview.contentSize = CGSizeMake(0, contentH + tb_h);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchGoodsArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.searchGoodsArr[indexPath.row];
    Home_SecSingleCell *tablecell = [collectionView dequeueReusableCellWithReuseIdentifier:tableCellId forIndexPath:indexPath];
    [tablecell setModel:info];
    return tablecell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     return CGSizeMake(SCREEN_WIDTH, Cell_H);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.searchGoodsArr[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    detail.pt = info.pt;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offY = scrollView.contentOffset.y;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    self.scroTopBtn.hidden = offY < layout.itemSize.height*3;
    
    if (offY >= self.bannerImageV.bottom) {
        CGRect frame = self.menu.frame;
        frame.origin.y = offY;
        self.menu.frame = frame;
    }else{
        CGRect frame = self.menu.frame;
        frame.origin.y = self.bannerImageV.bottom;
        self.menu.frame = frame;
    }
}

- (void)gotoTopAction{
    [self.scroview scrollToTop];
}

#pragma mark -- getter
- (UIScrollView *)scroview{
    if (!_scroview) {
        CGFloat hight = 0;
        if (IS_X_Xr_Xs_XsMax) {
            hight = SCREEN_HEIGHT - Bottom_Safe_AreaH;
        }else{
            hight = SCREEN_HEIGHT ;
        }
        CGRect frame = CGRectMake(0, NavigationBarBottom(self.navigationController.navigationBar), SCREEN_WIDTH, hight);
        _scroview = [[UIScrollView alloc] initWithFrame:frame];
        [_scroview addSubview:self.bannerImageV];
        [_scroview addSubview:self.menu];
        [_scroview addSubview:self.collectionView];
        [_scroview addSubview:self.blankView];
        [_scroview bringSubviewToFront:self.menu];
        _scroview.delegate = self;
        _scroview.showsVerticalScrollIndicator = NO;
        @weakify(self);
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self questData];
        }];
        [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        _scroview.mj_footer = footer;
    }
    return  _scroview;
}

- (UIImageView *)bannerImageV{
    if (!_bannerImageV) {
        _bannerImageV = [[UIImageView alloc] init];
        CGFloat rato = 140.f/355.f;
        CGFloat wd   =  SCREEN_WIDTH - 20;
        _bannerImageV.frame = CGRectMake(10, 10,wd, rato*wd);
        _bannerImageV.image = ZDBImage(@"img_banner_paihang");
    }
    return _bannerImageV;
}

- (PDDHotSaleMenu *)menu{
    if (!_menu) {
        _menu = [PDDHotSaleMenu viewFromXib];
        _menu.frame = CGRectMake(0, _bannerImageV.bottom, SCREEN_WIDTH, Menu_H );
        @weakify(self);
        _menu.block = ^(NSUInteger x) {
            @strongify(self);
            self.sort_type = x;
            self.page = 1;
            self.haveNoMoreData = NO;
            [self questData];
        };
    }
    return _menu;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
       
        CGRect frame = CGRectMake(0, self.menu.bottom, SCREEN_WIDTH, SCREEN_HEIGHT -  self.menu.bottom);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.singleLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.backgroundColor = RGBColor(245, 245, 245);
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Home_SecSingleCell class]) bundle:nil] forCellWithReuseIdentifier:tableCellId];
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
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

- (UIImageView *)blankView{
    if (!_blankView) {
        UIImage *image = ZDBImage(@"img_nodata_loading");
        _blankView = [[UIImageView alloc] initWithImage:image];
        _blankView.center = self.view.center;
        _blankView.top = self.menu.bottom + 5;
    }
    return _blankView;
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

- (NSMutableArray *)searchGoodsArr{
    if (!_searchGoodsArr) {
        _searchGoodsArr = [NSMutableArray array];
    }
    return _searchGoodsArr;
}

@end
