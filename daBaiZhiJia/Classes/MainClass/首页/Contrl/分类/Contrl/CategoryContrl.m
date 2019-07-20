//
//  CategoryContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import "CategoryContrl.h"
#import "CategoryHeadView.h"
#import "SearchResultMenu.h"
#import "SearchResultCell.h"
#import "SearchResulModel.h"
#import "CategoryInfo.h"
#import "TableGoodCell.h"
#import "GoodDetailContrl.h"
#import "Home_EveeChoiCell.h"
#import "Home_SecSingleCell.h"

@interface CategoryContrl ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scroview;

@property (nonatomic, strong) CategoryHeadView *headView;

@property (nonatomic, strong) SearchResultMenu *menu;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *scroTopBtn;

@property (nonatomic, strong) UICollectionViewFlowLayout *doubleLayout;//一排两个视图

@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排一个视图

@property (nonatomic, copy) NSString* cid;

@property (nonatomic, assign) NSInteger  page;

@property (nonatomic, copy) NSString* sort; //排序

@property (nonatomic,strong) NSMutableArray *searchGoodsArr;//搜索的商品

@property (nonatomic,strong) NSArray *cateArray;   //二级分类

@property (nonatomic, assign) BOOL haveNoMoreData;  //没有更多数据。 默认是否

@property (nonatomic, assign) BOOL switchBtnSelect; //默认 no

@property (nonatomic, assign) BOOL isSec; //默认 no 是否是二级界面

@property (nonatomic,strong) NSString *secTitle;

@property (nonatomic, strong) UIImageView *blankView;

@end

static NSString *collecTioncellId = @"collecTioncellId";
static NSString *tableCellId = @"tableCellId";
@implementation CategoryContrl
- (instancetype)initWithCateId:(NSString*)cid  isSec:(BOOL)isSec secTitle:(nonnull NSString *)secTitle{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.cid = cid;
    self.page = 1;
    self.sort = @"";
    self.isSec = isSec;
    self.secTitle = secTitle;
    return self;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"cid =%@",self.cid);
    if (!self.isSec) {
         [self query2thedCate];
    }else{ //二级界面
       self.title = self.secTitle;
      [self.view addSubview:self.menu];
      [self.view addSubview:self.scroview];
    }
    [self queryData];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar navBarBackGroundColor:ThemeColor image:nil isOpaque:YES];
//}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)query2thedCate{
    //查询二级分类
      NSDictionary *dict = @{@"cid":self.cid,@"token":ToKen};
    NSLog(@"查询二级分类dict %@",dict);
     [PPNetworkHelper GET:URL_Add(@"/v.php/goods.goods/getCateList") parameters:dict success:^(id responseObject) {
     NSLog(@"查询二级分类 =%@",responseObject);
     NSInteger code = [responseObject[@"code"] integerValue];
     if (code == SucCode) {
     NSArray *cateArray = [CategoryInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
     self.cateArray = cateArray;
     [self.view addSubview:self.scroview];
     [self.headView setModelWithArr:cateArray];
     }
     } failure:^(NSError *error) {
     NSLog(@"%@",error);
     }];
}

- (void)queryData{
 
    NSDictionary *para = @{@"cid":self.cid, @"page":@(self.page),@"sort":self.sort,@"token":ToKen};
    
    NSLog(@"para =%@", para);
    @weakify(self);
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getGoodsList") parameters:para success:^(id responseObject) {
        @strongify(self);
      //  NSLog(@"responseObject %@",responseObject);
         NSInteger code = [responseObject[@"code"] integerValue];
        [self.scroview.mj_header endRefreshing];
        if (code == SucCode) {
             self.blankView.hidden = YES;
            NSArray *listArray = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            for (SearchResulGoodInfo *info in listArray) {
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
            }
            if (listArray.count  ||self.page != 1) { //第一页有数据或者第二页起进来
                NSInteger totalPage = [responseObject[@"data"][@"totalPage"] integerValue];
                NSInteger currPage = [responseObject[@"data"][@"page"] integerValue];
              
                if (currPage == totalPage) { // 当前页数等于最大页数 提示没有更多数据
                    self.haveNoMoreData = YES;
                    [self.scroview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    self.haveNoMoreData = NO;
                }
                
                if (listArray.count) { //通知有数据。
                
                    if (self.page == 1) {
                        self.searchGoodsArr = listArray.mutableCopy;
                    }else{
                        [self.searchGoodsArr addObjectsFromArray:listArray];
                    }
                      self.page = currPage;
                     [self.scroview.mj_footer endRefreshing];
                    
                    if (!self.switchBtnSelect) {
                        [self caculteCollectionFrame];
                    }else{
                        [self caculteTableFrame];
                    }
                    
                }
                
            }else{  //没数据 空白页
                self.haveNoMoreData = YES;
                [self.searchGoodsArr removeAllObjects]; //没数据就清空 防止出错
            }
        }else{//请求失败
            [self.scroview.mj_footer endRefreshing];
            
            self.blankView.hidden = !(code == NoDataCode);
            
        }
    } failure:^(NSError *error) {
         NSLog(@"error %@",error);
    }];
}

- (void)caculteCollectionFrame{
    CGFloat wd = (SCREEN_WIDTH - Item_Gap*3 ) / 2;
    CGFloat ht = wd + Margin;
    
    CGFloat contentH =  0.f;
    if (self.searchGoodsArr.count %2 ==0) { //偶数
        contentH += ht * self.searchGoodsArr.count/2;
    }else{//奇数
        contentH += ht * (self.searchGoodsArr.count/2 + 1);
    }
    CGRect frame = self.collectionView.frame;
    frame.size.height = contentH;
    self.collectionView.frame = frame;
    self.collectionView.collectionViewLayout = self.doubleLayout;
    [self.collectionView reloadData];
    contentH += _isSec? 36:208 + 36;
    self.scroview.contentSize = CGSizeMake(0, contentH );
}

- (void)caculteTableFrame{
    CGFloat contentH =  0.f;
    contentH += self.searchGoodsArr.count * 139.f;
    CGRect frame = self.collectionView.frame;
    frame.size.height = contentH;
    self.collectionView.frame = frame;
    self.collectionView.collectionViewLayout = self.singleLayout;
    [self.collectionView reloadData];
    contentH += _isSec? 36:208 + 36;
    self.scroview.contentSize = CGSizeMake(0, contentH);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchGoodsArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     SearchResulGoodInfo *info = self.searchGoodsArr[indexPath.row];
    info.is_Cate_Sec = self.isSec;
    info.is_From_cate = YES;
    if (!self.switchBtnSelect) {
        Home_EveeChoiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecTioncellId forIndexPath:indexPath];
        
        [cell setModel:info];
        return cell;
    }else{
        Home_SecSingleCell *tablecell = [collectionView dequeueReusableCellWithReuseIdentifier:tableCellId forIndexPath:indexPath];
        [tablecell setModel:info];
        return tablecell;
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
    SearchResulGoodInfo *info = self.searchGoodsArr[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    NSLog(@"naviContrl  %@",self.naviContrl);
      NSLog(@"navigationController  %@",self.navigationController);
    if (self.isSec) {
         [self.navigationController pushViewController:detail animated:YES];
    }else{
         [self.naviContrl pushViewController:detail animated:YES];
    }
}

- (void)gotoTopAction{
    [self.scroview scrollToTop];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_isSec) {
        CGFloat offsety = scrollView.contentOffset.y;
        if (offsety >= self.headView.height) {
            CGRect frame = self.menu.frame;
            frame.origin.y = offsety;
            self.menu.frame = frame;
        }else{
            CGRect frame = self.menu.frame;
            frame.origin.y = self.headView.height;
            self.menu.frame = frame;
        }
    }
    
    CGFloat offY = scrollView.contentOffset.y;
    if (self.isSec) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        self.scroTopBtn.hidden = offY < layout.itemSize.height*3;
    }else{
        self.scroTopBtn.hidden = offY< self.headView.bottom;
    }
    
}

#pragma mark - getter
- (UIScrollView *)scroview{
    if (!_scroview) {
        CGFloat orgy = _isSec?self.menu.bottom:0;
        
        _scroview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, orgy, SCREEN_WIDTH, self.view.height)];
        _scroview.delegate = self;
        _scroview.backgroundColor = RGBColor(242, 242, 242);
        _scroview.showsVerticalScrollIndicator = NO;
        if (!_isSec) {
            [_scroview addSubview:self.headView];
            [_scroview addSubview:self.menu];
            [_scroview addSubview:self.collectionView];
            [_scroview bringSubviewToFront:self.menu];
        }else{
            [_scroview addSubview:self.collectionView];
        }
        @weakify(self);
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self queryData];
        }];
        [footer setTitle:@"已经是最后一页了" forState:MJRefreshStateNoMoreData];
        _scroview.mj_footer = footer;
        
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
             @strongify(self);
             self.page = 1;
             [self queryData];
        }];
        [head setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        _scroview.mj_header = head;
    }
    return _scroview;
}

- (CategoryHeadView *)headView{
    if (!_headView) {
        _headView = [CategoryHeadView viewFromXib];
        CGFloat height = 0;
        if (self.cateArray.count <=4 && self.cateArray.count > 0) {
            height = 104.f;
        }else if (self.cateArray.count >4){
            height = 208.f;
        }
        _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    }
    return _headView;
}

- (SearchResultMenu *)menu{
    if (!_menu) {
        _menu = [SearchResultMenu viewFromXib];
        CGFloat orgy = _isSec ? NavigationBarBottom(self.navigationController.navigationBar):_headView.bottom;
        
        _menu.frame = CGRectMake(0, orgy, SCREEN_WIDTH, 47);
        @weakify(self);
        _menu.searchBlock = ^(NSString * _Nullable searchType) {
            @strongify(self);
            NSLog(@"searchType  =%@",searchType);
            self.sort = searchType;
            self.page = 1;
            [self queryData];
            [self.scroview scrollToTop];
        };
        
        _menu.switchBlock = ^(BOOL isSelected) {
            @strongify(self);
            self.switchBtnSelect = isSelected;
            if (!isSelected) {
                [self caculteCollectionFrame];
            }else{
                 [self caculteTableFrame];
            }
        };
    }
    return _menu;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat hight = 0;
        if (IS_X_Xr_Xs_XsMax) {
            if (!_isSec) {
                 hight = SCREEN_HEIGHT -  self.menu.bottom - Bottom_Safe_AreaH -TabBar_H;
            }else{
                hight = SCREEN_HEIGHT - self.menu.bottom - Bottom_Safe_AreaH;
            }
           
        }else{
            if (!_isSec) {
                  hight = SCREEN_HEIGHT -  self.menu.bottom - TabBar_H - 80;
            }else{
                 hight = SCREEN_HEIGHT -  self.menu.bottom ;
            }
          
        }
        
        CGFloat orgy = 0;
        if (!_isSec) {
            orgy = self.menu.bottom;
        }else{
            orgy = 0;
        }
        CGRect frame = CGRectMake(0, orgy, SCREEN_WIDTH, hight);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.doubleLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate    = self;
        _collectionView.backgroundColor = RGBColor(242, 242, 242);
        NSString *cellStr = NSStringFromClass([Home_EveeChoiCell class]);
        [_collectionView registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
         [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Home_SecSingleCell class]) bundle:nil] forCellWithReuseIdentifier:tableCellId];
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}


- (UIImageView *)blankView{
    if (!_blankView) {
        _blankView = [[UIImageView alloc] initWithImage:ZDBImage(@"img_nodata_loading")];
        _blankView.center = self.collectionView.center;
        if (!self.isSec) {
            _blankView.mj_y -=  50 ;
        }
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

- (UICollectionViewFlowLayout *)doubleLayout{
    if (!_doubleLayout) {
        _doubleLayout = [[UICollectionViewFlowLayout alloc] init];
        _doubleLayout.minimumLineSpacing = 5 ;
        _doubleLayout.minimumInteritemSpacing = 5;;
        _doubleLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
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


- (NSMutableArray *)searchGoodsArr{
    if (!_searchGoodsArr) {
        _searchGoodsArr = [NSMutableArray array];
    }
    return _searchGoodsArr;
}
@end
