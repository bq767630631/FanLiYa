//
//  DBZJ_SearchContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_SearchContrl.h"
#import "LoginContrl.h"
#import "DBZJ_SearchHead.h"
#import "SearchResultCell.h"
#import "SearchResulModel.h"
#import "GoodDetailContrl.h"

@interface DBZJ_SearchContrl ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) DBZJ_SearchHead *head;
@property (nonatomic, strong) UICollectionView *collcetion;
@property (nonatomic, strong) UIImageView *blankView;
@property (nonatomic, strong) NSMutableArray *goodArr;
@property (nonatomic, assign) BOOL haveNoMoreData;  //没有更多数据。 默认是否
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UICollectionViewFlowLayout *doubleLayout;//一排两个视图
@end
static NSString *collecTioncellId = @"collecTioncellId";
@implementation DBZJ_SearchContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self.view addSubview:self.head];
    [self.view addSubview:self.collcetion];
    [self queryData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar navBarBackGroundColor:ThemeColor image:nil isOpaque:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)queryData{
    NSDictionary *dict = @{@"page":@(self.page),@"token":ToKen,@"v":APP_Version};
    NSLog(@"dict =%@",dict.mj_keyValues);
    if (self.haveNoMoreData) {
        [self collecViewEndRefresh];
        [self.collcetion.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [PPNetworkHelper POST:URL_Add(@"/v.php/index.index/jingxuan") parameters:dict success:^(id responseObject) {
        NSLog(@"推荐 responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSArray *listArray = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (listArray.count  ||self.page != 1) { //第一页有数据或者第二页起进来
                 self.blankView.hidden = YES;
                NSInteger totalPage = [responseObject[@"data"][@"totalPage"] integerValue];
                NSInteger currPage = [responseObject[@"data"][@"page"] integerValue];
                if (currPage >= totalPage) { // 当前页数等于最大页数 提示没有更多数据
                    self.haveNoMoreData = YES;
                    [self collecViewEndRefresh];
                    [self.collcetion.mj_footer endRefreshingWithNoMoreData];
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
                    [self collecViewEndRefresh];
                    [self.collcetion reloadData];
                }
                
            }else{  //没数据 空白页
                self.blankView.hidden = NO;
                self.haveNoMoreData = YES;
                [self.goodArr removeAllObjects]; //没数据就清空 防止出错
            }
        }else{//请求失败
            [self collecViewEndRefresh];
            [self.collcetion.mj_footer endRefreshingWithNoMoreData];
            if (code == NoDataCode) {
                self.blankView.hidden = NO;
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}

- (void)collecViewEndRefresh{
    [self.collcetion.mj_footer endRefreshing];
    [self.collcetion.mj_header endRefreshing];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    SearchResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecTioncellId forIndexPath:indexPath];
    [cell setInfo:info];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat wd = (SCREEN_WIDTH - 5.f*3 ) / 2;
    CGFloat ht = wd + 115.f;
    CGSize itemSize = CGSizeMake(wd,ht);
    return itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
   [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - getter
- (DBZJ_SearchHead *)head{
    if (!_head) {
       _head = [DBZJ_SearchHead viewFromXib];
        _head.frame = CGRectMake(0, 0, SCREEN_WIDTH, 280);
    }
    return _head;
}

- (UICollectionView *)collcetion{
    if (!_collcetion) {
        CGRect frame = CGRectMake(0, self.head.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - TabBar_H - self.head.bottom);
        _collcetion = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.doubleLayout];
        _collcetion.dataSource = self;
        _collcetion.delegate    = self;
        _collcetion.backgroundColor = RGBColor(242, 242, 242);
        NSString *cellStr = NSStringFromClass([SearchResultCell class]);
        [_collcetion registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
        _collcetion.showsVerticalScrollIndicator = NO;
        @weakify(self);
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self queryData];
        }];
        [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        _collcetion.mj_footer = footer;
        MJRefreshStateHeader *head = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self queryData];
        }];
        [head setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
        _collcetion.mj_header = head;
    }
    return _collcetion;
}

- (UIImageView *)blankView{
    if (!_blankView) {
        _blankView = [[UIImageView alloc] initWithImage:ZDBImage(@"img_nodata_loading")];
        _blankView.center = self.collcetion.center;
        [self.view addSubview:_blankView];
    }
    return _blankView;
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

@end
