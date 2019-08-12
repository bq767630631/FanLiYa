//
//  SearchResultContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/3.
//  Copyright © 2019 包强. All rights reserved.
//

#import "SearchResultContrl.h"
#import "DWQSearchBar.h"
#import "SearchResultMenu.h"
#import "SearchResultHead.h"
#import "SearchResultCell.h"
#import "SearchResulModel.h"
#import "TableGoodCell.h"
#import "CouponSearchView.h"
#import "GoodDetailContrl.h"
#import "Home_EveeChoiCell.h"
#import "Home_SecSingleCell.h"

@interface SearchResultContrl ()<UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) DWQSearchBar *searchBar;

@property (nonatomic,strong) SearchResultMenu *menu;

@property (nonatomic,strong) UIScrollView *scroview;

@property (nonatomic,strong) SearchResultHead *head;//空白头

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) CouponSearchView *couponSear;

@property (nonatomic, strong) UIButton *scroTopBtn;

@property (nonatomic, strong) UICollectionViewFlowLayout *doubleLayout;//一排两个视图

@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排一个视图

@property (nonatomic,copy) NSString *searchStr;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,copy) NSString *has_coupon; //true表示该商品有优惠券，false或不设置表示不限

@property (nonatomic,copy) NSString *sort;//取值：sales/ratio/price/stoptime

@property (nonatomic,strong) NSMutableArray *searchGoodsArr;//搜索的商品

@property (nonatomic, assign) BOOL haveNoMoreData;  //没有更多数据。 默认是否

@property (nonatomic, assign) BOOL switchBtnSelect; //默认 no
@end

static NSString *collecTioncellId = @"collecTioncellId";
static NSString *tableCellId = @"tableCellId";
@implementation SearchResultContrl

- (instancetype)initWithSearchStr:(NSString *)str{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.searchStr = str ;
    self.page = 1;
    self.sort = @"";
    self.has_coupon = @"false";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self questData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)creatUI{
    self.navigationItem.titleView = self.searchBar;
    
    [self.view addSubview:self.menu];
    [self.view addSubview:self.couponSear];
    [self.view addSubview:self.scroview];
}

- (void)questData{
    NSDictionary *dict = @{@"kw":self.searchStr,@"page":@(self.page),@"sort":self.sort,@"has_coupon":self.has_coupon,@"token":ToKen,@"v":APP_Version};
     NSLog(@"dict =%@",dict.mj_keyValues);
    if (self.haveNoMoreData) {
        [self.scroview.mj_footer endRefreshing];
        [self.scroview.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getAllListByKeyword") parameters:dict success:^(id responseObject) {
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
                    self.head.hidden = YES;
                    if (self.page == 1) {
                        self.searchGoodsArr = listArray.mutableCopy;
                    }else{
                        [self.searchGoodsArr addObjectsFromArray:listArray];
                    }
                    self.page = currPage;
                    [self.scroview.mj_footer endRefreshing];
                    [self reloadeData];
                }
               
            }else{  //没数据 空白页
                self.head.hidden = NO;
                self.haveNoMoreData = YES;
                [self.searchGoodsArr removeAllObjects]; //没数据就清空 防止出错
                [self.scroview.mj_footer endRefreshing];
                [self.scroview.mj_footer endRefreshingWithNoMoreData];
                [self reloadeData];
            }
        }else{//请求失败
              self.head.hidden = NO;
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
    if (!self.switchBtnSelect) {
        [self caculteCollectionFrame];
    }else{
        [self caculteTableFrame];
    }
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
    frame.origin.y = 0;
    frame.size.height = contentH;
    self.collectionView.frame = frame;
    self.collectionView.collectionViewLayout = self.doubleLayout;
    [self.collectionView reloadData];
    self.scroview.contentSize = CGSizeMake(0, contentH );
}

- (void)caculteTableFrame{
    CGFloat contentH =  0.f;
    contentH += self.searchGoodsArr.count * 139.f + 45;
    CGRect frame = self.collectionView.frame;
    frame.origin.y = 0;
    frame.size.height = contentH;
    self.collectionView.frame = frame;
     self.collectionView.collectionViewLayout = self.singleLayout;
    [self.collectionView reloadData];
    self.scroview.contentSize = CGSizeMake(0, contentH);
}

#pragma mark - popAction
- (void)leftBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"搜索了什么：%@",textField.text);
    self.searchStr = textField.text;
    self.page = 1;
    self.haveNoMoreData = NO;
    [self questData];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchGoodsArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.searchGoodsArr[indexPath.row];
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
        return itemSize;
    }else{
        return CGSizeMake(SCREEN_WIDTH, 139.f);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.searchGoodsArr[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offY = scrollView.contentOffset.y;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    self.scroTopBtn.hidden = offY < layout.itemSize.height*3;
}

- (void)gotoTopAction{
    [self.scroview scrollToTop];
}

#pragma mark -- getter
- (DWQSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[DWQSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 30)];
        _searchBar.delegate = self;
        _searchBar.text = self.searchStr;
    }
    return _searchBar;
}

- (SearchResultMenu *)menu{
    if (!_menu) {
        _menu = [SearchResultMenu viewFromXib];
        _menu.frame = CGRectMake(0, NavigationBarBottom(self.navigationController.navigationBar), SCREEN_WIDTH, 45);
        @weakify(self);
        _menu.searchBlock = ^(NSString *searchType) {
            @strongify(self);
            self.sort = searchType;
            self.page = 1;
            self.haveNoMoreData = NO;
            [self questData];
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

- (UIScrollView *)scroview{
    if (!_scroview) {
        CGFloat hight = 0;
        if (IS_X_Xr_Xs_XsMax) {
            hight = SCREEN_HEIGHT -  self.couponSear.bottom - Bottom_Safe_AreaH;
        }else{
            hight = SCREEN_HEIGHT -  self.couponSear.bottom;
        }
        CGRect frame = CGRectMake(0, _couponSear.bottom, SCREEN_WIDTH, hight);
        _scroview = [[UIScrollView alloc] initWithFrame:frame];
        [_scroview addSubview:self.head];
        [_scroview addSubview:self.collectionView];
        _scroview.delegate = self;
        _scroview.showsVerticalScrollIndicator = NO;
        @weakify(self);
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self questData];
        }];
        [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        _scroview.mj_footer = footer;
    }
    return  _scroview;
}

- (SearchResultHead *)head{
    if (!_head) {
        _head = [SearchResultHead viewFromXib];
        _head.hidden = YES;
        _head.frame = CGRectMake(0, 0, SCREEN_WIDTH, 233);
    }
    return _head;
}

- (CouponSearchView *)couponSear{
    if (!_couponSear) {
        _couponSear = [CouponSearchView viewFromXib];
        _couponSear.frame = CGRectMake(0, self.menu.bottom, SCREEN_WIDTH, 45);
        @weakify(self);
        _couponSear.block = ^(BOOL isOn) {
            @strongify(self);
            self.page = 1;
            self.has_coupon = isOn?@"true":@"false";
            self.haveNoMoreData = NO;
            [self questData];
        };
    }
    return _couponSear;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat hight = 0;
        if (IS_X_Xr_Xs_XsMax) {
            hight = SCREEN_HEIGHT -  self.head.bottom - Bottom_Safe_AreaH;
        }else{
            hight = SCREEN_HEIGHT -  self.head.bottom;
        }
        CGRect frame = CGRectMake(0, self.head.bottom, SCREEN_WIDTH, hight);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.doubleLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = RGBColor(242, 242, 242);
        NSString *cellStr = NSStringFromClass([Home_EveeChoiCell class]);
        [_collectionView registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
         [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Home_SecSingleCell class]) bundle:nil] forCellWithReuseIdentifier:tableCellId];
         _collectionView.scrollEnabled = NO;
         _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
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
