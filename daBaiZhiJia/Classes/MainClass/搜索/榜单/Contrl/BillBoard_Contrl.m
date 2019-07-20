//
//  BillBoard_Contrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "BillBoard_Contrl.h"
#import "BillBoard_FirstMenu.h"
#import "BillBoard_SecCell.h"
#import "BillBoard_Model.h"
#import "BillBoard_GoodCell.h"
#import "GoodDetailContrl.h"
#define Row_Height  127.f
@interface BillBoard_Contrl ()<UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *bg_imageV;

@property (nonatomic, strong) BillBoard_FirstMenu *firstMenu;

@property (nonatomic, strong) UICollectionView *collecTionMen;

@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排-个视图
@property (nonatomic, strong) BillBoard_Model *model;
@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) UITableView *tableV2;
@property (nonatomic, strong) UITableView *tableV3;
@property (nonatomic, strong) UIButton *scroTopBtn;
@property (nonatomic, strong) NSMutableArray *cateArr;

@property (nonatomic, strong) NSMutableArray *goodArr;
@property (nonatomic, strong) NSMutableArray *goodArr2;
@property (nonatomic, strong) NSMutableArray *goodArr3;
@property (nonatomic, assign) NSInteger  rankeType;//1,2,3
@property (nonatomic, assign) NSInteger  cid;
@end
static NSString *colleCellID = @"colleCellID";
static NSString *tableCellID = @"tableCellID";
static NSString *tableCellID2 = @"tableCellID2";
static NSString *tableCellID3 = @"tableCellID3";
@implementation BillBoard_Contrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"榜单";
    self.view.backgroundColor = RGBColor(242, 242, 242);
    [self.view addSubview:self.bg_imageV];
    [self.view addSubview:self.firstMenu];
    [self.view addSubview:self.collecTionMen];
    [self.view addSubview:self.scroView];
    [BillBoard_Model queryCateInfoWithBlock:^(NSMutableArray *catInfoArr, NSError *err) {
        if (catInfoArr) {
            self.cateArr = catInfoArr;
            [self.collecTionMen reloadData];
        }
    }];
    self.rankeType = 1;
    self.cid = 0;
    [self queryGoodData];
}

- (void)queryGoodData{
    [self.model queryGoodWithRankType:self.rankeType cid:self.cid WithBlock:^(NSMutableArray *infoArr, NSError *err) {
        if (self.rankeType ==1) {
            if (self.model.isHaveNomoreData == YES) {
                [self.tableV.mj_footer endRefreshing];
                [self.tableV.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            self.goodArr = infoArr;
            [self.tableV.mj_footer endRefreshing];
            [self.tableV reloadData];
        }else if (self.rankeType ==2){
            if (self.model.isHaveNomoreData == YES) {
                [self.tableV2.mj_footer endRefreshing];
                [self.tableV2.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            self.goodArr2 = infoArr;
            [self.tableV2.mj_footer endRefreshing];
            [self.tableV2 reloadData];
        }else if (self.rankeType ==3){
            if (self.model.isHaveNomoreData == YES) {
                [self.tableV3.mj_footer endRefreshing];
                [self.tableV3.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            self.goodArr3 = infoArr;
            [self.tableV3.mj_footer endRefreshing];
            [self.tableV3 reloadData];
        }
        
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //不隐藏导航栏 把背景色z设置透明
    [self.navigationController.navigationBar navBarBackGroundColor:UIColor.clearColor image:nil isOpaque:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cateArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BillBoard_SecCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:colleCellID forIndexPath:indexPath];
    BillBoard_CatInfo *info = self.cateArr[indexPath.item];
    info.indexPath = indexPath;
    [cell setInfoWithModel:info];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    BillBoard_CatInfo *info = self.cateArr[indexPath.item];
   CGFloat wd =  [info.title textWidthWithFont:[UIFont systemFontOfSize:12] maxHeight:MAXFLOAT];
    return CGSizeMake(wd + 1, 47);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      BillBoard_CatInfo *info = self.cateArr[indexPath.row];
     info.isSelected = YES;
    for ( BillBoard_CatInfo *itemInfo in self.cateArr) {
        if (info!=itemInfo && itemInfo.isSelected) {
            itemInfo.isSelected = NO;
        }
    }
    [collectionView reloadData];
    self.cid = info.cid;
    self.model.page = 1;
    self.model.isHaveNomoreData = NO;
    [self queryGoodData];
    [self delayDoWork:0.2 WithBlock:^{
          [self gotoTopAction];
    }];
}

#pragma mark - UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.rankeType ==1) {
        return self.goodArr.count;
    }else if (self.rankeType==2){
        return self.goodArr2.count;
    }
    return self.goodArr3.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.rankeType==1) {
        BillBoard_GoodCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellID];
        SearchResulGoodInfo *info = self.goodArr[indexPath.row];
        [cell setModel:info];
        return cell;
    }else if (self.rankeType ==2){
        BillBoard_GoodCell *cell2 = [tableView dequeueReusableCellWithIdentifier:tableCellID2];
        SearchResulGoodInfo *info = self.goodArr2[indexPath.row];
        [cell2 setModel:info];
        return cell2;
    }else{
        BillBoard_GoodCell *cell3 = [tableView dequeueReusableCellWithIdentifier:tableCellID3];
        SearchResulGoodInfo *info = self.goodArr3[indexPath.row];
        [cell3 setModel:info];
        return cell3;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = nil;
    if (self.rankeType==1) {
        info = self.goodArr[indexPath.row];
    }else if (self.rankeType==2){
          info = self.goodArr2[indexPath.row];
    }else if (self.rankeType==3){
        info = self.goodArr3[indexPath.row];
    }
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.scroView == scrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger index = offsetX /self.scroView.width;
        NSLog(@"index =%zd",index);
        self.rankeType = index + 1;
        self.model.page = 1;
        self.model.isHaveNomoreData = NO;
        [self.firstMenu setBtnSelectWithType:self.rankeType];
        [self queryGoodData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
       CGFloat offY = scrollView.contentOffset.y;
        self.scroTopBtn.hidden = offY < Row_Height*3;
}

- (void)gotoTopAction{
    if (self.rankeType ==1) {
        [self.tableV scrollToTop];
    }else if (self.rankeType==2){
        [self.tableV2 scrollToTop];
    }else if (self.rankeType==3){
        [self.tableV3 scrollToTop];
    }
}

#pragma mark - getter
- (UIImageView *)bg_imageV{
    if (!_bg_imageV) {
        _bg_imageV = [[UIImageView alloc]initWithImage:ZDBImage(@"billBoard_banner_bg")];
        _bg_imageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, _bg_imageV.image.size.height*SCALE_Normal);
    }
    return _bg_imageV;
}

- (BillBoard_FirstMenu *)firstMenu{
    if (!_firstMenu) {
        _firstMenu = [BillBoard_FirstMenu viewFromXib];
        CGFloat orgy  =  NavigationBarBottom(self.navigationController.navigationBar);
        _firstMenu.frame = CGRectMake(0,orgy, SCREEN_WIDTH, 30.f);
        @weakify(self);
        _firstMenu.clickBlock = ^(NSInteger type) {
            
            @strongify(self);
            [self.scroView setContentOffset:CGPointMake((type-1) *self.collecTionMen.width, 0) animated:YES];
            NSLog(@"type %zd",type);
            self.rankeType = type;
            self.model.page = 1;
            self.model.isHaveNomoreData = NO;
            [self queryGoodData];
            if (type ==3) {
                self.scroView.top = self.collecTionMen.top;
                self.scroView.height = SCREEN_HEIGHT - Height_TabBar - self.firstMenu.bottom - 7;
                self.tableV3.height =  self.scroView.height ;
            }else{
                self.scroView.top = self.collecTionMen.bottom + 7;
                self.scroView.height = SCREEN_HEIGHT - Height_TabBar -  self.collecTionMen.bottom - 7;
                self.tableV3.height =  self.scroView.height ;
            }
          
        };
    }
    return _firstMenu;
}

- (UICollectionView *)collecTionMen{
    if (!_collecTionMen) {
        CGRect frame = CGRectMake(10, self.firstMenu.bottom, SCREEN_WIDTH-20, 70);
        _collecTionMen = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.singleLayout];
        _collecTionMen.backgroundColor = UIColor.whiteColor;
        ViewBorderRadius(_collecTionMen, 10, UIColor.clearColor);
       [_collecTionMen registerNib:[UINib nibWithNibName:NSStringFromClass([BillBoard_SecCell class]) bundle:nil] forCellWithReuseIdentifier:colleCellID];
        _collecTionMen.delegate = self;
        _collecTionMen.dataSource = self;
        _collecTionMen.showsHorizontalScrollIndicator = NO;
    }
    return _collecTionMen;
}

- (UICollectionViewFlowLayout *)singleLayout{
    if (!_singleLayout) {
        _singleLayout = [[UICollectionViewFlowLayout alloc] init];
        _singleLayout.minimumInteritemSpacing = 40;
        _singleLayout.minimumLineSpacing = 40;
        _singleLayout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 0);
        _singleLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _singleLayout;
}

- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat height = SCREEN_HEIGHT - TabBar_H -  self.collecTionMen.bottom - 7;
        CGRect frame = CGRectMake(10, self.collecTionMen.bottom + 7 ,self.collecTionMen.width, height);
        _scroView = [[UIScrollView alloc] initWithFrame:frame];
        _scroView.frame = frame;
        _scroView.delegate  = self;
        _scroView.pagingEnabled = YES;
        _scroView.bounces = NO;
        _scroView.showsHorizontalScrollIndicator = NO;
        _scroView.contentSize = CGSizeMake(self.collecTionMen.width*3, 0);
        [_scroView addSubview:self.tableV];
        [_scroView addSubview:self.tableV2];
        [_scroView addSubview:self.tableV3];
    }
    return _scroView;
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

- (UITableView *)tableV{
    if (!_tableV) {
    
        CGRect frame = CGRectMake(0, 0 ,_scroView.width, _scroView.height);
        NSLog(@"_tableV.frame =%@", NSStringFromCGRect(frame));
        _tableV = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableV.backgroundColor = UIColor.clearColor;
        _tableV.delegate  = self;
        _tableV.dataSource = self;
        _tableV.rowHeight = Row_Height;
        _tableV.backgroundColor = RGBColor(242, 242, 242);
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.showsVerticalScrollIndicator = NO;
         [_tableV registerNib:[UINib nibWithNibName:NSStringFromClass([BillBoard_GoodCell class]) bundle:nil] forCellReuseIdentifier:tableCellID];
        @weakify(self);
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self queryGoodData];
        }];
        [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
        _tableV.mj_footer = footer;
    }
    return _tableV;
}

- (UITableView *)tableV2{
    if (!_tableV2) {
        
        CGRect frame = CGRectMake(_scroView.width, 0 ,_scroView.width,_scroView.height);
        NSLog(@"_tableV2.frame =%@", NSStringFromCGRect(frame));
        _tableV2 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableV2.backgroundColor = UIColor.clearColor;
        _tableV2.delegate  = self;
        _tableV2.dataSource = self;
        _tableV2.rowHeight = Row_Height;
        _tableV2.backgroundColor = RGBColor(242, 242, 242);
        _tableV2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV2.showsVerticalScrollIndicator = NO;
        [_tableV2 registerNib:[UINib nibWithNibName:NSStringFromClass([BillBoard_GoodCell class]) bundle:nil] forCellReuseIdentifier:tableCellID2];
        @weakify(self);
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self queryGoodData];
        }];
        [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
        _tableV2.mj_footer = footer;
    }
    return _tableV2;
}

- (UITableView *)tableV3{
    if (!_tableV3) {
        
        CGRect frame =  CGRectMake(_scroView.width*2, 0 ,_scroView.width,_scroView.height);
        NSLog(@"_tableV3.frame =%@", NSStringFromCGRect(frame));
        _tableV3 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableV3.backgroundColor = UIColor.clearColor;
        _tableV3.delegate  = self;
        _tableV3.dataSource = self;
        _tableV3.rowHeight = Row_Height;
        _tableV3.backgroundColor = RGBColor(242, 242, 242);
        _tableV3.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV3.showsVerticalScrollIndicator = NO;
        [_tableV3 registerNib:[UINib nibWithNibName:NSStringFromClass([BillBoard_GoodCell class]) bundle:nil] forCellReuseIdentifier:tableCellID3];
        @weakify(self);
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self queryGoodData];
        }];
        [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
        _tableV3.mj_footer = footer;
    }
    return _tableV3;
}

- (BillBoard_Model *)model{
    if (!_model) {
        _model = [BillBoard_Model new];
    }
    return _model;
}
@end
