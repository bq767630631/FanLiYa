//
//  Home_SecHasCatContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_SecHasCatContrl.h"
#import "JXCategoryView.h"
#import "SearchResultMenu.h"
#import "Home_EveeChoiCell.h"
#import "GoodDetailContrl.h"
#import "Home_SecSingleCell.h"
@interface Home_SecHasCatContrl ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,JXCategoryListContentViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic,strong) SearchResultMenu *menu;
@property (nonatomic,strong) UICollectionView *collcetion;
@property (nonatomic, strong) UICollectionViewFlowLayout *doubleLayout;//一排两个视图
@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排一个视图
@property (nonatomic, strong) UIButton *scroTopBtn;
@property (nonatomic, strong) NSMutableArray*cateTitleArr;
@property (nonatomic, strong) NSMutableArray*cateIdArr;
@property (nonatomic, strong) NSMutableArray*goodArr;
@property (nonatomic, assign) SecHasCatType  type;


@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy)  NSString *sort;
@property (nonatomic, assign) BOOL switchBtnSelect; //默认 no

@property (nonatomic, strong) UIImageView *blankV;
@end
static NSString *collecTioncellId = @"collecTioncellId";
static NSString *tableCellId = @"tableCellId";
@implementation Home_SecHasCatContrl

- (instancetype)initWithType:(SecHasCatType)type title:(NSString*)title{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.type = type;
    self.title = title;
    [Home_SecHasCatModel shareInstance].page = 1;
    self.sort = @"";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    [self.view addSubview:self.categoryView];
  
    self.listContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
     self.categoryView.contentScrollView = self.listContainerView.scrollView;
    [self.view addSubview:self.menu];
    [self.view addSubview:self.collcetion];
    
    [Home_SecHasCatModel  querySecCateWithType:self.type Block:^(NSMutableArray *cateTitleArr, NSMutableArray *cateIdArr, NSString *msg) {
        if (cateTitleArr) {
            self.cateTitleArr = cateTitleArr;
            self.cateIdArr = cateIdArr;
            self.categoryView.titles = cateTitleArr;
            [self.categoryView reloadData];
            [self.listContainerView reloadData];
            self.cid = [cateIdArr.firstObject integerValue];
            [self queryGoodData];
        }
    }];
}

- (void)queryGoodData{
    [Home_SecHasCatModel querySecGoodwithType:self.type page: [Home_SecHasCatModel shareInstance].page cid:self.cid sort:self.sort block:^(NSMutableArray *goodArr, NSError *error) {
        if ([Home_SecHasCatModel shareInstance].isHaveNomoreData&& [Home_SecHasCatModel shareInstance].page!=1) {
            [self.collcetion.mj_header endRefreshing];
            [self.collcetion.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        if (goodArr.count) {
            [self.collcetion.mj_header endRefreshing];
            [self.collcetion.mj_footer endRefreshing];
            
            self.blankV.hidden = YES;
        }else{
            NSLog(@"添加空白页");
            self.blankV.hidden = NO;
        }
        self.goodArr = goodArr;
        [self.collcetion reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar navBarBackGroundColor:RGBColor(33, 33, 33) image:nil isOpaque:YES];
}

- (void)dealloc{
    [Home_SecHasCatModel shareInstance].isHaveNomoreData = NO;
    [[Home_SecHasCatModel shareInstance].goodArr removeAllObjects];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    if (!self.switchBtnSelect) {
        Home_EveeChoiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecTioncellId forIndexPath:indexPath];
        [cell setModel:info];
        return cell;
    }else{
        Home_SecSingleCell *singleCell =[collectionView dequeueReusableCellWithReuseIdentifier:tableCellId forIndexPath:indexPath];
        [singleCell setModel:info];
          return singleCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.switchBtnSelect) {
        CGFloat wd = (SCREEN_WIDTH - Item_Gap*3 ) / 2;
        CGFloat ht = wd + Margin;
        CGSize itemSize = CGSizeMake(wd,ht);
        return itemSize;
    }else{
        return CGSizeMake(SCREEN_WIDTH, 139.f);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" indexPath =%@",indexPath);
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offY = scrollView.contentOffset.y;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collcetion.collectionViewLayout;
    self.scroTopBtn.hidden = offY < layout.itemSize.height*3;
}

- (void)gotoTopAction{
    [self.collcetion scrollToTop];
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.cid = [self.cateIdArr[index] integerValue];
     [Home_SecHasCatModel shareInstance].page = 1;
     [Home_SecHasCatModel shareInstance].isHaveNomoreData = NO;
     [self.collcetion scrollToTop];
     [self queryGoodData];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}
#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.cateTitleArr.count;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView{
    return self.view;
}

#pragma mark - getter
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.frame = CGRectMake(0,NavigationBarBottom(self.navigationController.navigationBar), SCREEN_WIDTH, 40.f);
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleColor = UIColor.whiteColor;
        _categoryView.titleSelectedColor = UIColor.whiteColor;
        _categoryView.titleFont = [UIFont systemFontOfSize:14];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:15];
        _categoryView.backgroundColor= RGBColor(33, 33, 33);
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
        lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
        lineView.indicatorColor = UIColor.whiteColor;
        lineView.indicatorHeight = 1.f;
        lineView.verticalMargin = 2.f;
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView{
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
        _listContainerView.frame = CGRectMake(0, _categoryView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - _categoryView.bottom - Height_TabBar);
    }
    return _listContainerView;
}

- (SearchResultMenu *)menu{
    if (!_menu) {
        _menu = [SearchResultMenu viewFromXib];
        _menu.frame = CGRectMake(0, self.categoryView.bottom, SCREEN_WIDTH, 47);
        @weakify(self);
        _menu.searchBlock = ^(NSString *searchType) {
            @strongify(self);
            self.sort = searchType;
            [Home_SecHasCatModel shareInstance].page = 1;
            [Home_SecHasCatModel shareInstance].isHaveNomoreData = NO;
            [self queryGoodData];
        };
        
        _menu.switchBlock = ^(BOOL isSelected) {
            @strongify(self);
            self.switchBtnSelect = isSelected;
            if (!isSelected) {
                self.collcetion.collectionViewLayout = self.doubleLayout;
                
            }else{
                self.collcetion.collectionViewLayout = self.singleLayout;
            }
               [self.collcetion reloadData];
        };
    }
    return _menu;
}

- (UICollectionView *)collcetion{
    if (!_collcetion) {
        CGFloat height = SCREEN_HEIGHT  - self.menu.bottom;
        if (IS_X_Xr_Xs_XsMax) {
                 height = SCREEN_HEIGHT  - self.menu.bottom -Bottom_Safe_AreaH;
        }
        CGRect frame = CGRectMake(0, self.menu.bottom, SCREEN_WIDTH, height);
        _collcetion = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.doubleLayout];
        _collcetion.dataSource = self;
        _collcetion.delegate    = self;
        _collcetion.backgroundColor = RGBColor(242, 242, 242);
        NSString *cellStr = NSStringFromClass([Home_EveeChoiCell class]);
        [_collcetion registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
         [_collcetion registerNib:[UINib nibWithNibName:NSStringFromClass([Home_SecSingleCell class]) bundle:nil] forCellWithReuseIdentifier:tableCellId];
        _collcetion.showsVerticalScrollIndicator = NO;
        @weakify(self);
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@"加载更多数据");
            [self queryGoodData];
        }];
        [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        _collcetion.mj_footer = footer;
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [Home_SecHasCatModel shareInstance].page = 1;
            [Home_SecHasCatModel shareInstance].isHaveNomoreData = NO;
            [self queryGoodData];
        }];
        [head setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        _collcetion.mj_header = head;
    }
    return _collcetion;
}

- (UIButton *)scroTopBtn{
    if (!_scroTopBtn) {
        _scroTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scroTopBtn.frame = CGRectMake(self.view.width -32- 13,self.view.height - Height_TabBar - 32  - 20, 32, 32);
        [_scroTopBtn addTarget:self action:@selector(gotoTopAction) forControlEvents:UIControlEventTouchUpInside];
        [_scroTopBtn setImage:ZDBImage(@"icon_top") forState:UIControlStateNormal];
        _scroTopBtn.hidden= YES;
        [self.view addSubview:_scroTopBtn];
    }
    return _scroTopBtn;
}

- (UICollectionViewFlowLayout *)doubleLayout{
    if (!_doubleLayout) {
        _doubleLayout = [[UICollectionViewFlowLayout alloc] init];
        _doubleLayout.minimumLineSpacing = Item_Gap;
        _doubleLayout.minimumInteritemSpacing = Item_Gap;
        _doubleLayout.sectionInset = UIEdgeInsetsMake(Item_Gap, Item_Gap, 0, Item_Gap);
    }
    return _doubleLayout;
}

- (UICollectionViewFlowLayout *)singleLayout{
    if (!_singleLayout) {
        _singleLayout = [[UICollectionViewFlowLayout alloc] init];
        _singleLayout.minimumLineSpacing = 0;
        _singleLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _singleLayout;
}

- (UIImageView *)blankV{
    if (!_blankV) {
        _blankV = [[UIImageView alloc] initWithImage:ZDBImage(@"img_nodata_loading")];
        _blankV.center = self.view.center;
        [self.view addSubview:_blankV];
    }
    return _blankV;
}
@end
