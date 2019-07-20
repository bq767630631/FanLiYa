//
//  NavTabViewController.m
//  NavTabScrollView
//
//  Created by tashaxing on 9/15/16.
//  Copyright © 2016 tashaxing. All rights reserved.
//

#import "NavTabViewController.h"
#import "PageViewController.h"
#import "CategoryContrl.h"
// 常量
#define kFrameWidth self.view.frame.size.width
#define kFrameHeight self.view.frame.size.height

//static const CGFloat kUpMargin = 30; // 顶部间距
static const CGFloat kTitleHeight = 51; // 标题高度
static const CGFloat kButtonWidth = 84; // 导航按钮宽度
static const CGFloat kButtonLineHeight = 2.f; // 小横线高度
static const CGFloat kMaxTitleScale = 1.214; // 标题的最大缩放比例


@interface HomePageCategoryInfo : NSObject
@property (nonatomic, copy) NSString *cid; //类别ID
@property (nonatomic, copy) NSString *title; //类别名
@end

@implementation HomePageCategoryInfo


@end

@interface NavTabViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_titleScrollView;    // 标题栏
    UIScrollView *_contentScrollview;  // 内容区
    UIView *_buttonLine;               // 标题小横线
    NSInteger _pageCount;              // 分页数
    NSMutableArray *_cateInfoArray;
    NSArray *_titleArray;
}

@property (nonatomic, strong) CategoryContrl *cateContrl;

@property (nonatomic, strong) NSString* cid;

@property (nonatomic, strong) CouponListBlankView *blankView;
@end

@implementation NavTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryData];
}

- (void)queryData{
    @weakify(self);
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getCateList") parameters:nil success:^(id responseObject) {
        @strongify(self);
          // NSLog(@"分类responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            self->_cateInfoArray =   [HomePageCategoryInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSMutableArray *titleArray = [NSMutableArray array];
            for (HomePageCategoryInfo *info in self->_cateInfoArray) {
                [titleArray addObject:info.title];
            }
            self->_titleArray = titleArray;
            [self createTitleScrollView];
            [self createButtonLine];
            [self createContentScrollview];
             self.blankView.hidden = YES;
        }else{
            
        }
     
    } failure:^(NSError *error) {
        NSLog(@"查询分类error %@",error);
        self.blankView.hidden = NO;
        [SVProgressHUD popActivity];
        BlankViewInfo *info = [BlankViewInfo infoWithNoticeNetError];
        [self.blankView setModel:info];

        @weakify(self);
        self.blankView.block = ^{
            @strongify(self);
             [self queryData];
        };
    }];
}


#pragma mark - 初始化UI
- (void)createTitleScrollView
{
    // 根据是否有导航栏调整坐标
   
    CGFloat   marginY =  0;//StatusBar_H + 7.f + 30.f;
    NSLog(@"marginY =%.f",marginY);
    // 标题栏,包括小横线的位置
    _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, marginY, kFrameWidth, kTitleHeight + kButtonLineHeight)];
    NSLog(@"_titleScrollView.frame %@", NSStringFromCGRect(_titleScrollView.frame));
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.bounces = NO;
    _titleScrollView.delegate = self;
    [self.view addSubview:_titleScrollView];
    
    // 添加button
    _pageCount = _titleArray.count;
    _titleScrollView.contentSize = CGSizeMake(kButtonWidth * _pageCount, kTitleHeight);
    for (int i = 0; i < _pageCount; i++)
    {
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(kButtonWidth * i, 0, kButtonWidth, kTitleHeight)];
        [titleBtn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [titleBtn addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchDown];
        titleBtn.tag = 1000 + i; // button做标记，方便后面索引，为了不出冲突，就把这个数值设得大一些
        [_titleScrollView addSubview:titleBtn];
    };
}

- (void)createButtonLine
{
    // 初始时刻停在最左边与按钮对齐
    _buttonLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45.f, kButtonWidth, kButtonLineHeight)];
    _buttonLine.backgroundColor = [UIColor whiteColor];
    // 小横线加载scrollview上才能跟随button联动
    [_titleScrollView addSubview:_buttonLine];
}

- (void)createContentScrollview
{
    CGFloat marginY = -2;//StatusBar_H + 7.f + 28.f;;
    
    // 添加内容页面
    _contentScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, marginY + kTitleHeight + kButtonLineHeight, kFrameWidth, kFrameHeight - marginY - kTitleHeight - kButtonLineHeight)];
    NSLog(@"_contentScrollview.frame =%@", NSStringFromCGRect(_contentScrollview.frame));
    _contentScrollview.pagingEnabled = YES;
    _contentScrollview.bounces = NO;
     _contentScrollview.contentSize = CGSizeMake(kFrameWidth * _pageCount, 0);
    _contentScrollview.showsHorizontalScrollIndicator = NO;
    _contentScrollview.showsVerticalScrollIndicator = NO;
    
    _contentScrollview.delegate = self;
    _contentScrollview.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_contentScrollview];
    
    // 添加分页面

    PageViewController *pageViewController = [[PageViewController alloc] init];
    UIButton *button = [_titleScrollView viewWithTag:1000 + 0];
    pageViewController.title = button.currentTitle;
    pageViewController.view.frame = CGRectMake( 0, 0, kFrameWidth, kFrameHeight - marginY - kTitleHeight);
    [self addChildViewController:pageViewController];
    [_contentScrollview addSubview:pageViewController.view];
    
    for(int i = 0; i < _pageCount; i++) {
        if ( i > 0) {
            HomePageCategoryInfo *info= _cateInfoArray[i];
            self.cid = info.cid;
            _cateContrl = [[CategoryContrl alloc] initWithCateId:self.cid isSec:NO secTitle:@""];
            [self addChildViewController:self.cateContrl];
        }
    }
    
    
    // 初始化后选中某个栏目
    [self titleButtonClicked:[_titleScrollView viewWithTag:1000 + 0]];
}

#pragma mark - 标题button点击事件
- (void)titleButtonClicked:(UIButton *)sender
{
    // 根据点击的button切换页面和偏移
    printf("%s clicked\n", sender.currentTitle.UTF8String);
    
    NSInteger tag = sender.tag - 1000;
    NSLog(@"tag: %zd",tag);
   [self addSubViewWithTag:tag];

    // 强调被选中的button
    // 放大聚焦
    sender.transform = CGAffineTransformMakeScale(kMaxTitleScale, kMaxTitleScale);
    // 变色
   // [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    // 居中title
    [self settleTitleButton:sender];
    
    // 带动画切换到对应的内容,会触发scrollViewDidScroll
    NSInteger pageIndex = sender.tag - 1000;
    [_contentScrollview setContentOffset:CGPointMake(kFrameWidth * pageIndex, 0) animated:YES];
}

#pragma mark - scrollview滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据content内容偏移调整标题栏
    if (scrollView == _titleScrollView)
    {
        //printf("title moved\n");
        
        
    }
    else if (scrollView == _contentScrollview)
    {
       // printf("content moved\n");
        
        // 获得左右两个button的索引, 注意最后取整
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger leftTitleIndex = offsetX / kFrameWidth;
        NSInteger rightTitleIndex = leftTitleIndex + 1;
        // 因为设置了到边不能滑动，所以不考虑边界
        UIButton *leftTitleButton = [_titleScrollView viewWithTag:1000 + leftTitleIndex];
        UIButton *rightTitleButton = [_titleScrollView viewWithTag:1000 + rightTitleIndex];
        
        // 设置大小和颜色渐变以及小横线的联动
        // 权重因子 0~1 小数, 左边和右边互补
        CGFloat rightTitleFactor = offsetX / kFrameWidth - leftTitleIndex;
        CGFloat leftTitleFactor = 1 - rightTitleFactor;
        
        // 尺寸
        CGFloat maxExtraScale = kMaxTitleScale - 1;
        leftTitleButton.transform = CGAffineTransformMakeScale(1 + leftTitleFactor * maxExtraScale, 1 + leftTitleFactor * maxExtraScale);
        rightTitleButton.transform = CGAffineTransformMakeScale(1 + rightTitleFactor * maxExtraScale, 1 + rightTitleFactor * maxExtraScale);
        // 颜色
        UIColor *leftTitleColor =  [UIColor whiteColor];//[UIColor colorWithRed:0 green:leftTitleFactor blue:0 alpha:1];
        UIColor *rightTitleColor = [UIColor whiteColor];//[UIColor colorWithRed:0 green:rightTitleFactor blue:0 alpha:1];
        [leftTitleButton setTitleColor:leftTitleColor forState:UIControlStateNormal];
        [rightTitleButton setTitleColor:rightTitleColor forState:UIControlStateNormal];
        // 小横线位移
        _buttonLine.frame = CGRectMake(kButtonWidth * (leftTitleIndex + rightTitleFactor), _buttonLine.frame.origin.y, kButtonWidth, kButtonLineHeight);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 内容区块滑动结束调整标题栏居中
    if (scrollView == _contentScrollview)
    {
        // 取得索引值
        NSInteger titleIndex = scrollView.contentOffset.x / kFrameWidth;
        // title居中
        [self settleTitleButton:[_titleScrollView viewWithTag:1000 + titleIndex]];
        //添加子视图的view
         [self addSubViewWithTag:titleIndex];
       
    }
}

#pragma mark - 标题按钮和横线居中偏移
- (void)settleTitleButton:(UIButton *)button
{
    // 标题
    // 这个偏移量是相对于scrollview的content frame原点的相对对标
    CGFloat deltaX = button.center.x - kFrameWidth / 2;
    // 设置偏移量，记住这段算法
    if (deltaX < 0)
    {
        // 最左边
        deltaX = 0;
    }
    CGFloat maxDeltaX = _titleScrollView.contentSize.width - kFrameWidth;
    if (deltaX > maxDeltaX)
    {
        // 最右边不能超范围
        deltaX = maxDeltaX;
    }
    [_titleScrollView setContentOffset:CGPointMake(deltaX, 0) animated:YES];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
}


#pragma mark - private

- (void)addSubViewWithTag:(NSInteger)tag{
  
        UIViewController *childVc = self.childViewControllers[tag];
        
        UIView *childVcView = childVc.view;
        childVcView.backgroundColor = UIColor.whiteColor;
        //CGFloat marginY = -2;
        childVcView.frame = CGRectMake(kFrameWidth * tag, 0, kFrameWidth,SCREEN_HEIGHT - ( Height_StatusBar + 7.f+ 30.f) - Height_TabBar - 53.f );
  //  NSLog(@"childVcView.frame =%@",NSStringFromCGRect(childVcView.frame));
        [_contentScrollview addSubview:childVcView];
}

- (CouponListBlankView *)blankView{
    if (!_blankView) {
        _blankView = [CouponListBlankView viewFromXib];
        CGFloat origy  = 0;
        CGFloat height = SCREEN_HEIGHT - origy;
        if (IS_X_Xr_Xs_XsMax) {
            height = SCREEN_HEIGHT - origy - Bottom_Safe_AreaH;
        }
        CGRect frame =CGRectMake(0,0, SCREEN_WIDTH, height);
        
        _blankView.frame = frame;
        [self.view addSubview:_blankView];
    }
    return _blankView;
}
@end


