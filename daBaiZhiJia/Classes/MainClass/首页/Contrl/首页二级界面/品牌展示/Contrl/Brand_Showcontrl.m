//
//  Brand_Showcontrl.m

#import "Brand_Showcontrl.h"
#import "JXCategoryView.h"
#import "Home_SecHasCatModel.h"
#import "Brand_ShowCells.h"
#import "Brand_ShowModel.h"
#import "Brand_ShowDetail.h"
#define Gap 14.f
@interface Brand_Showcontrl ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,JXCategoryListContentViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic,strong) UICollectionView *collcetion;
@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排一个视图
@property (nonatomic, strong) Brand_ShowModel *model;
@property (nonatomic, strong) UIImageView *blankView;
@property (nonatomic, strong) UIButton *scroTopBtn;

@property (nonatomic, strong) NSMutableArray*cateTitleArr;
@property (nonatomic, strong) NSMutableArray*cateIdArr;
@property (nonatomic, strong) NSMutableArray*goodArr;
@property (nonatomic, assign) NSString* cid;
@end
static NSString *collecTioncellId = @"collecTioncellId";
@implementation Brand_Showcontrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌展示";
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    [self.view addSubview:self.categoryView];
    
    self.listContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
    [self.view addSubview:self.collcetion];
    if (self.isFromTabContrl) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
    }
    
    [Home_SecHasCatModel  querySecCateWithType:SecHasCatType_BrandShow Block:^(NSMutableArray *cateTitleArr, NSMutableArray *cateIdArr, NSString *msg) {
        if (cateTitleArr) {
            self.cateTitleArr = cateTitleArr;
            self.cateIdArr = cateIdArr;
            self.categoryView.titles = cateTitleArr;
            [self.categoryView reloadData];
            [self.listContainerView reloadData];
            self.cid = cateIdArr.firstObject ;
            [self queryGoodData];
        }
    }];
}

- (void)queryGoodData{
    self.model.brandcat = self.cid;
    [self.model queryDataWithBlcok:^(NSMutableArray *goodArr, NSError *error) {
        if (!error) {
            if (self.model.isHaveNomoreData) {
                [self.collcetion.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collcetion.mj_footer endRefreshing];
            }
            [self.collcetion.mj_header endRefreshing];
            self.goodArr = goodArr;
            [self.collcetion reloadData];
            self.blankView.hidden = goodArr.count ?YES:NO;
        }
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Brand_ShowCells *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecTioncellId forIndexPath:indexPath];
    BrandCat_info *info = self.goodArr[indexPath.row];
    [cell setInfoWithModel:info];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"");
    BrandCat_info *info = self.goodArr[indexPath.row];
    Brand_ShowDetail *detail = [[Brand_ShowDetail alloc] initWithId:info.brandid];
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
    self.cid = self.cateIdArr[index] ;
    self.model.page = 1;
    self.model.isHaveNomoreData = NO;
    [self queryGoodData];
    [self delayDoWork:0.5 WithBlock:^{
        [self.collcetion scrollToTop];
    }];
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

- (UICollectionView *)collcetion{
    if (!_collcetion) {
        CGFloat height = SCREEN_HEIGHT  - self.categoryView.bottom;
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH;
        }
        CGRect frame = CGRectMake(0, self.categoryView.bottom, SCREEN_WIDTH, height);
        _collcetion = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.singleLayout];
        _collcetion.dataSource = self;
        _collcetion.delegate    = self;
        _collcetion.backgroundColor = RGBColor(242, 242, 242);
        NSString *cellStr = NSStringFromClass([Brand_ShowCells class]);
        [_collcetion registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
    
        _collcetion.showsVerticalScrollIndicator = NO;
        @weakify(self); 
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@"加载更多数据");
            [self queryGoodData];
        }];
        _collcetion.mj_footer = footer;
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.model.page = 1;
            self.model.isHaveNomoreData = NO;
            [self queryGoodData];
        }];
        [head setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        _collcetion.mj_header = head;
    }
    return _collcetion;
}

- (UICollectionViewFlowLayout *)singleLayout{
    if (!_singleLayout) {
        _singleLayout = [[UICollectionViewFlowLayout alloc] init];
        _singleLayout.minimumLineSpacing = Gap;
        _singleLayout.sectionInset = UIEdgeInsetsMake(Gap, Gap, 0, Gap);
        CGFloat ratio = 112.f/168.f;
        CGFloat itemW = (SCREEN_WIDTH - 3*Gap)/2;
        CGFloat itemH = itemW*ratio;
        _singleLayout.itemSize = CGSizeMake(itemW, itemH);
    }
    return _singleLayout;
}

- (UIImageView *)blankView{
    if (!_blankView) {
        _blankView = [[UIImageView alloc] initWithImage:ZDBImage(@"img_nodata_loading")];
        _blankView.center = self.collcetion.center;
        [self.view addSubview:_blankView];
    }
    return _blankView;
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

- (Brand_ShowModel *)model{
    if (!_model) {
        _model = [Brand_ShowModel new];
    }
    return _model;
}
@end
