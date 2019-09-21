//
//  DBZJ_HomeViewContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_HomeViewContrl.h"
#import "HomeSearchView.h"
#import "JXCategoryView.h"
#import "PageViewController.h"
#import "CategoryContrl.h"
#import "HomePage_Model.h"
#import "MP_ZG_Const.h"
#import "CouponListBlankView.h"
@interface DBZJ_HomeViewContrl ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) PageViewController *pageVc;
@property (nonatomic, strong) UIImageView *home_bg;
@property (nonatomic, strong) HomeSearchView *searchView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray*cateTitleArr;
@property (nonatomic, strong) NSMutableArray*cateIdArr;
@property (nonatomic, strong) NSMutableArray*bg_bannerArr; //背景数组

@property (nonatomic, strong) CouponListBlankView *blankv;
@end

@implementation DBZJ_HomeViewContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.home_bg];
    [self.view addSubview:self.searchView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePage_Bg_change:) name:Home_pageScro_ChangeBgNoti object:nil];

    [HomePage_Model queryVerson:^{
        [self setUpCategory];
        [self queryData];
    }];
}


- (void)setUpCategory{
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    [self.view addSubview:self.categoryView];
    
    self.listContainerView.didAppearPercent = 0.01; //滚动一点就触发加载
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
}

- (void)queryData{
        [HomePage_Model queryCateInfoWithBlock:^(NSMutableArray*cateTitleArr, NSMutableArray*cateIdArr,NSString *msg) {
            
            if (cateTitleArr&&cateIdArr) {
                self.blankv.hidden = YES;
                self.cateTitleArr = cateTitleArr;
                self.cateIdArr = cateIdArr;
                self.categoryView.titles = cateTitleArr;
                [self.categoryView reloadData];
                [self.listContainerView reloadData];
                
                [HomePage_Model queryHomeBannerImagesBlcok:^(NSMutableArray*bg_bannerArr,NSMutableArray*bannerArr , NSError *error) {
                    if (bg_bannerArr&&bannerArr) {
                        self.bg_bannerArr = bg_bannerArr;
                        [self.home_bg setDefultPlaceholderWithFullPath:bg_bannerArr.firstObject];
                        self.pageVc.bannerArr = bannerArr;
                    }
                    
                }];
            }else{ //空白页
                  NSLog(@"空白页  %@",msg);
                self.blankv.hidden = NO;
              
                BlankViewInfo *info = [BlankViewInfo new];
                info.title = msg;
                info.image = ZDBImage(@"");
                info.btnTitle = @"请点击按钮重新加载";
                info.isShowActionBtn = YES;
                 CGFloat  wd = [info.btnTitle textWidthWithFont:  self.blankv.actionBtn.titleLabel.font maxHeight:30];
                info.btnW = wd + 12;
                [self.blankv  setModel:info];
            }
        }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar navBarBackGroundColor:ThemeColor image:nil isOpaque:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - notifation action
- (void)homePage_Bg_change:(NSNotification*)noti{
    NSDictionary *info = noti.userInfo;
    NSInteger index = [info[@"index"] integerValue];
    NSString *imgStr = self.bg_bannerArr[index];
    [self.home_bg setDefultPlaceholderWithFullPath:imgStr];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 0) {//如果点的是首页 就回到精选
        [self.categoryView selectItemAtIndex:0];
    }
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (index ==0) {
         [self.home_bg setDefultPlaceholderWithFullPath:self.bg_bannerArr.firstObject];
    }else{
        self.home_bg.image = [UIImage imageWithColor:RGBColor(34, 34, 34)];
    }
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = nil;  
    if (index== 0) {
        self.pageVc = [[PageViewController alloc] init];
        self.pageVc.naviContrl = self.navigationController;
        self.pageVc.tabBarContrl = self.tabBarController;
        self.pageVc.viewH = listContainerView.height;
        self.pageVc.view.height =  listContainerView.height;
        list =  self.pageVc;
    }else{
        NSString *cid = self.cateIdArr[index];
        CategoryContrl *cate =  [[CategoryContrl alloc] initWithCateId:cid isSec:NO secTitle:@""];
        cate.naviContrl = self.navigationController;
        cate.tabBarContrl = self.tabBarController;
        cate.pt = FLYPT_Type_TB;
        list =  cate;
    }
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.cateTitleArr.count;//
}


#pragma mark - getter
- (UIImageView *)home_bg{
    if (!_home_bg) {
        UIImage *banner_hm = [UIImage imageNamed:@"img_banner_home_bg"];
        _home_bg = [[UIImageView alloc] initWithImage:banner_hm];
        _home_bg.frame = CGRectMake(0, 0, SCREEN_WIDTH, banner_hm.size.height);

    }
    return _home_bg;
}

- (HomeSearchView *)searchView{
    if (!_searchView) {
        _searchView = [HomeSearchView viewFromXib];
        CGRect frame = CGRectMake(0, StatusBar_H , SCREEN_WIDTH, 34.f);
        _searchView.frame = frame;
    }
    return _searchView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        CGFloat height =  Is_Show_Info?40.f:0;
        _categoryView.frame = CGRectMake(0, _searchView.bottom, SCREEN_WIDTH, height);
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleColor = UIColor.whiteColor;
        _categoryView.titleSelectedColor = UIColor.whiteColor;
        _categoryView.titleFont = [UIFont systemFontOfSize:14];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:15];
    
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
        NSLog(@"disH =%.f",_categoryView.bottom + Height_TabBar );
    }
    return _listContainerView;
}

- (CouponListBlankView *)blankv{
    if (!_blankv) {
        _blankv = [CouponListBlankView viewFromXib];
        _blankv.frame =  CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - Height_TabBar);
        [self.view addSubview:_blankv];
        @weakify(self);
        _blankv.block = ^{
            @strongify(self);
            [self queryData];
            [[NSNotificationCenter defaultCenter] postNotificationName:HomePageRefresh_NotiFacation object:nil];
        };
    }
    return _blankv;
}




@end
