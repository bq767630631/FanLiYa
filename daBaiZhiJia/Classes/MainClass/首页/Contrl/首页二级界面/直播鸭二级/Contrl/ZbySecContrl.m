//
//  ZbySecContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ZbySecContrl.h"
#import "Home_SecHasCatModel.h"
#import "JXCategoryView.h"
#import "ZbySec_Model.h"
#import "Home_EveeChoiCell.h"
#import "PlayVideoContrl.h"
#import "ZF_PlayVideoContrl.h"
@interface ZbySecContrl ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,JXCategoryListContentViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic,strong) UICollectionView *collcetion;
@property (nonatomic, strong) UICollectionViewFlowLayout *doubleLayout;//一排两个视图
@property (nonatomic, strong) NSMutableArray*cateTitleArr;
@property (nonatomic, strong) NSMutableArray*cateIdArr;
@property (nonatomic, strong) NSMutableArray*goodArr;

@property (nonatomic, strong) UIImageView *blankV;
@property (nonatomic, strong) UIButton *scroTopBtn;

@property (nonatomic, strong) ZbySec_Model *model;
@end

static NSString *collecTioncellId = @"collecTioncellId";
@implementation ZbySecContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播鸭";
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    [self.view addSubview:self.categoryView];
    
    self.listContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
    
    [self.view addSubview:self.collcetion];
    
    [Home_SecHasCatModel querySecCateWithType:SecHasCatType_Zby Block:^(NSMutableArray *cateTitleArr, NSMutableArray *cateIdArr,  NSString*msg) {
        if (cateTitleArr) {
            self.cateTitleArr = cateTitleArr;
            self.cateIdArr = cateIdArr;
            self.categoryView.titles = cateTitleArr;
            [self.categoryView reloadData];
            [self.listContainerView reloadData];
            self.model.cid =  [cateIdArr.firstObject integerValue];
            
            [self queryGoodData];
        }
    }];
}

- (void)queryGoodData{
    @weakify(self);
    [self.model queryDataWithBlock:^(NSMutableArray *goodArr, NSError *error) {
        @strongify(self);
        if (self.model.isHaveNomoreData) {
            [self.collcetion.mj_footer endRefreshing];
            [self.collcetion.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self.collcetion.mj_header endRefreshing];
        [self.collcetion.mj_footer endRefreshing];
        if (goodArr.count) {
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
    [self.navigationController.navigationBar navBarBackGroundColor:RGBColor(33, 33, 33) image:nil isOpaque:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    
    Home_EveeChoiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecTioncellId forIndexPath:indexPath];
    [cell setModel:info];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat wd = (SCREEN_WIDTH - Item_Gap*3 ) / 2;
    CGFloat ht = wd + Margin;
    CGSize itemSize = CGSizeMake(wd,ht);
    return itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" indexPath =%@",indexPath);
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    ZF_PlayVideoContrl *zf = [[ZF_PlayVideoContrl alloc] initWithInfo:info];
    [self.navigationController pushViewController:zf animated:YES];
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
    self.model.cid = [self.cateIdArr[index] integerValue];
    self.model.page = 1;
    self.model.isHaveNomoreData = NO;
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
      NSLog(@"");
    return self;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
      NSLog(@"");
    return self.cateTitleArr.count;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView{
      NSLog(@"");
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

- (UICollectionView *)collcetion{
    if (!_collcetion) {
        CGFloat height = SCREEN_HEIGHT  - self.categoryView.bottom;
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH;
        }
        CGRect frame = CGRectMake(0, self.categoryView.bottom, SCREEN_WIDTH, height);
        _collcetion = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.doubleLayout];
        _collcetion.dataSource = self;
        _collcetion.delegate    = self;
        _collcetion.backgroundColor = RGBColor(242, 242, 242);
        NSString *cellStr = NSStringFromClass([Home_EveeChoiCell class]);
        [_collcetion registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
        _collcetion.showsVerticalScrollIndicator = NO;
        @weakify(self);
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@"加载更多数据");
            [self queryGoodData];
        }];
        [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        _collcetion.mj_footer = footer;
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.model.isHaveNomoreData = NO;
            self.model.page = 1;
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

- (ZbySec_Model *)model{
    if (!_model) {
        _model = [ZbySec_Model new];
    }
    return _model;
}
@end
