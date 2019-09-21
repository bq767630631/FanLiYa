//
//  PingDuoduoHomeContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PingDuoduoHomeContrl.h"
#import "PingDuoduoHomeModel.h"
#import "PingDuoduoHomeSearch.h"
#import "JXCategoryView.h"
#import "PingDuoduoPageHomecontrl.h"
#import "CategoryContrl.h"

@interface PingDuoduoHomeContrl ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) PingDuoduoHomeSearch *searchV;
@property (nonatomic, strong) PingDuoduoPageHomecontrl *pageVc;
@property (nonatomic, strong) CategoryContrl *cateVc;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray*cateTitleArr;
@property (nonatomic, strong) NSMutableArray*cateIdArr;

@property (nonatomic, assign) NSInteger  cur_index;
@end

@implementation PingDuoduoHomeContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.pt == FLYPT_Type_Pdd ?@"拼多多":@"京东";//
    [self setUp];
    [self queryData];
    
}

- (void)setUp{
    [self initRightBarButtonWithImage:@"icon_refresh_pdd"];
    [self.view addSubview:self.searchV];
    
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    [self.view addSubview:self.categoryView];
    
    self.listContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar navBarBackGroundColor:RGBColor(51, 51, 51) image:nil isOpaque:YES];
}

- (void)onTapRightBarButton{
    NSLog(@"refresh");
    if (self.cur_index==0) {
        [self.pageVc refreshData];
    }else{
        [self.cateVc refreshData];
    }
}

- (void)queryData{
    [PingDuoduoHomeModel queryCateInfoWithpt:self.pt Block:^(NSMutableArray *cateTitleArr, NSMutableArray *cateIdArr, NSString *msg) {
        if (cateTitleArr&&cateIdArr){
            self.cateTitleArr = cateTitleArr;
            self.cateIdArr = cateIdArr;
            self.categoryView.titles = cateTitleArr;
            [self.categoryView reloadData];
            [self.listContainerView reloadData];
        }
    }];
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.cur_index = index;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = nil;
    if (index== 0) {
        self.pageVc = [[PingDuoduoPageHomecontrl alloc] init];
        self.pageVc.pt = self.pt;
        self.pageVc.naviContrl = self.navigationController;
        self.pageVc.tabBarContrl = self.tabBarController;
        self.pageVc.viewH = listContainerView.height;
        self.pageVc.cid = self.cateIdArr.firstObject;
        self.pageVc.view.height =  listContainerView.height;
        list =  self.pageVc;
    }else{
        NSString *cid = self.cateIdArr[index];
        CategoryContrl *cate =  [[CategoryContrl alloc] initWithCateId:cid isSec:NO secTitle:@""];
        self.cateVc = cate;
        cate.naviContrl = self.navigationController;
        cate.tabBarContrl = self.tabBarController;
        cate.pt = self.pt;
        list =  cate;
    }
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.cateTitleArr.count;
}


#pragma mark - getter
- (PingDuoduoHomeSearch *)searchV{
    if (!_searchV) {
        _searchV = [PingDuoduoHomeSearch viewFromXib];
        _searchV.pt = self.pt;
        _searchV.frame = CGRectMake(0, NavigationBarBottom(self.navigationController.navigationBar), SCREEN_WIDTH, 60.f);
    }
    return _searchV;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        CGFloat height =  Is_Show_Info?40.f:0;
        _categoryView.frame = CGRectMake(0, _searchV.bottom, SCREEN_WIDTH, height);
        _categoryView.backgroundColor= RGBColor(245, 245, 245);
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleColor = RGBColor(51, 51, 51);
        _categoryView.titleSelectedColor = RGBColor(51, 51, 51);
        _categoryView.titleFont = [UIFont systemFontOfSize:15];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:17];
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
        lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
        lineView.indicatorColor =  RGBColor(51, 51, 51);
        lineView.indicatorHeight = 1.f;
        lineView.verticalMargin = 2.f;
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView{
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
        _listContainerView.frame = CGRectMake(0, _categoryView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - _categoryView.bottom );
//        NSLog(@"disH =%.f",_categoryView.bottom + Height_TabBar );
    }
    return _listContainerView;
}

@end
