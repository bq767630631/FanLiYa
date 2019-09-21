//
//  LimitSale_SecContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "LimitSale_SecContrl.h"
#import "HomePage_Model.h"
#import "JXCategoryView.h"
#import "LimitSale_SecModel.h"
#import "Home_SecSingleCell.h"
#import "GoodDetailContrl.h"

#import "LimitSale_SecStatusCell.h"

#define Item_W 70.f
@interface LimitSale_SecContrl ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *titleView;


@property (nonatomic, strong) UICollectionView *menuV;

@property (nonatomic, strong) UICollectionViewFlowLayout *menuLayout;

@property (nonatomic,strong) UICollectionView *collcetion;

@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排一个视图
@property (nonatomic, strong) LimitSale_SecModel *model;
@property (nonatomic, copy)  NSString *time_;
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, strong) NSMutableArray*goodArr;
@property (nonatomic, assign) NSInteger  index;

@property (nonatomic, strong) UIImageView *blankView;
@end

static NSString *collecTioncellId = @"collecTioncellId";
static NSString *menuCellId = @"menuCellId";


@implementation LimitSale_SecContrl

- (instancetype)initWithTime_:(NSString *)time_ timeArr:(NSMutableArray*)timeArr index:(NSInteger)index{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.time_ = time_;
    self.timeArr = timeArr;
    self.index = index;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.titleView;
    [self.view addSubview:self.menuV];
    
    [self.view addSubview:self.collcetion];
    
    for (int i = 0; i < self.timeArr.count; i ++) {
        HomePage_FlashSaleInfo *info = self.timeArr[i];
        if (self.index == i) {
            info.isSelected = YES;
        }else{
            info.isSelected = NO;
        }
    }
    [self.menuV reloadData];
    self.menuV.contentOffset = CGPointMake(12 + Item_W *self.index, 0);
     self.model.time_ =  self.time_;
    [self queryData];
}

- (void)queryData{
   
    [self.model queryDataWithBlock:^(NSMutableArray *goodArr, NSError *error) {
        if (!error) {
            if (self.model.isHaveNomoreData) {
                [self.collcetion.mj_footer endRefreshingWithNoMoreData];
            }
            
            self.goodArr = goodArr;
            [self.collcetion reloadData];
            [self.collcetion.mj_header endRefreshing];
            [self.collcetion.mj_footer endRefreshing];
            self.blankView.hidden = goodArr.count ?YES:NO;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:ZDBImage(@"img_limitsec_banner_bg") forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.clearColor] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"self.timeArr.count %zd",self.timeArr.count);
    return  (collectionView == self.menuV) ?self.timeArr.count: self.goodArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.menuV) {
        LimitSale_SecStatusCell *menuCell = [collectionView dequeueReusableCellWithReuseIdentifier:menuCellId forIndexPath:indexPath];
        NSLog(@"menuCell");
        HomePage_FlashSaleInfo *fla = self.timeArr[indexPath.row];
        [menuCell setInfo:fla];
        return menuCell;
    }else{
        SearchResulGoodInfo *info = self.goodArr[indexPath.row];
        Home_SecSingleCell *tablecell = [collectionView dequeueReusableCellWithReuseIdentifier:collecTioncellId forIndexPath:indexPath];
        [tablecell setModel:info];
        return tablecell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.menuV) {
          HomePage_FlashSaleInfo *fla = self.timeArr[indexPath.row];
        
        for (int i = 0; i < self.timeArr.count; i ++) {
            HomePage_FlashSaleInfo *info = self.timeArr[i];
            if (i == indexPath.row) {
                info.isSelected = YES;
            }else{
                info.isSelected = NO;
            }
        }
        [collectionView reloadData];
        self.model.time_ = fla.time_;
        self.model.page = 1;
        self.model.isHaveNomoreData = NO;
        [self queryData];
        return;
    }
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    detail.pt = info.pt;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - getter
-(UIImageView *)titleView{
    if (!_titleView) {
        UIImage *image = ZDBImage(@"img_limit_title");
        _titleView = [[UIImageView alloc] initWithImage:image];
    }
    return _titleView;
}

- (UICollectionView *)menuV{
    if (!_menuV) {
          CGRect frame = CGRectMake(0, NavigationBarBottom(self.navigationController.navigationBar), SCREEN_WIDTH, 50);
        _menuV = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.menuLayout];
        _menuV.backgroundColor = RGBColor(34, 34, 34);
        _menuV.delegate   = self;
        _menuV.dataSource = self;
          NSString *cellStr = NSStringFromClass([LimitSale_SecStatusCell class]);
        [_menuV registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:menuCellId];
        _menuV.showsHorizontalScrollIndicator = NO;
    }
    return _menuV;
}

- (UICollectionViewFlowLayout *)menuLayout{
    if (!_menuLayout) {
        _menuLayout = [[UICollectionViewFlowLayout alloc] init];
        _menuLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 0);
        _menuLayout.itemSize = CGSizeMake(Item_W, 50.f);
        _menuLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _menuLayout;
}

- (UICollectionView *)collcetion{
    if (!_collcetion) {
        CGFloat height = SCREEN_HEIGHT  - self.menuV.bottom;
        if (IS_X_Xr_Xs_XsMax) {
            height -=  Bottom_Safe_AreaH;
        }
        CGRect frame = CGRectMake(0, self.menuV.bottom, SCREEN_WIDTH, height);
        _collcetion = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.singleLayout];
        _collcetion.dataSource = self;
        _collcetion.delegate    = self;
        _collcetion.backgroundColor = RGBColor(242, 242, 242);
        NSString *cellStr = NSStringFromClass([Home_SecSingleCell class]);
        [_collcetion registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
        _collcetion.showsVerticalScrollIndicator = NO;
        @weakify(self);
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@"加载更多数据");
            [self queryData];
        }];
        _collcetion.mj_footer = footer;
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.model.isHaveNomoreData = NO;
            self.model.page = 1;
            [self queryData];
        }];
        [head setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        _collcetion.mj_header = head;
    }
    return _collcetion;
}


- (UICollectionViewFlowLayout *)singleLayout{
    if (!_singleLayout) {
        _singleLayout = [[UICollectionViewFlowLayout alloc] init];
        _singleLayout.minimumLineSpacing = 0;
        _singleLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _singleLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 139.f);
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
- (LimitSale_SecModel *)model{
    if (!_model) {
        _model = [LimitSale_SecModel new];
    }
    return _model;
}
@end
