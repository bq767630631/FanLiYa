//
//  ZF_PlayVideoContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/1.
//  Copyright © 2019 包强. All rights reserved.
//


#import "ZF_PlayVideoContrl.h"
#import "PlayVideo_Model.h"
#import "PlayVideo_Cell.h"

#import <ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "ZFDouYinControlView.h"
#import "PlayVideo_Barrage.h"
#import "MJProxy.h"

@interface ZF_PlayVideoContrl ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) PlayVideo_Model *videoModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) ZFDouYinControlView *controlView;

@property (nonatomic, strong) PlayVideo_Barrage *barRage;//弹幕
@property (nonatomic, assign) NSInteger cur_Barindex;//显示当前的弹幕内容
@property (nonatomic, strong) NSMutableArray *barrageArr;//弹幕内容数组
@property (nonatomic, copy)  NSString *cur_sku;
@property (strong, nonatomic) NSTimer *timer;
@end

static NSString *collecTioncellId = @"collecTioncellId";

@implementation ZF_PlayVideoContrl
- (instancetype)initWithInfo:(SearchResulGoodInfo *)info{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.cur_sku = info.sku;
    self.videoModel.firstInfo = info;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collection];
    [self setUpZkPlayer];
    [self queryGoodData];
    [self queryBarrage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.timer fire];
    NSLog(@"");
    @weakify(self);
    [self.collection zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player stopCurrentPlayingCell];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc{
    NSLog(@"");
}

- (void)setUpZkPlayer{
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.collection playerManager:playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    self.player.assetURLs = self.urls;
    self.player.shouldAutoPlay = YES;
    self.player.WWANAutoPlay = YES;
    self.player.disablePanMovingDirection = ZFPlayerDisablePanMovingDirectionAll;
    /// 1.0是消失100%时候
    self.player.playerDisapperaPercent = 1.0;
    self.player.allowOrentitaionRotation = NO;//不允许旋转
    
    @weakify(self);
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
}

#pragma mark - private method
- (void)playTheIndex:(NSInteger)index{
//    @weakify(self)
    /// 指定到某一行播放
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
  
    NSLog(@"指定到某一行播放1 indexPath=%@", indexPath);
    [self.collection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    @weakify(self);
    [self.collection zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        NSLog(@"指定到某一行播放2 indexPath=%@", indexPath);
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
}

- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.controlView resetControlView];
    SearchResulGoodInfo *data = self.dataSource[indexPath.row];
    NSLog(@"playTheVideo title =%@   video=%@",data.title,data.video);
    [self.controlView showCoverViewWithUrl:data.pic withImageMode:UIViewContentModeScaleAspectFill];
}

- (void)queryGoodData{
    [self.videoModel queryZBYInfoCallBack:^(NSMutableArray *goodArr, NSError *error) {
       
        self.dataSource = self.videoModel.goodArr;
        self.urls = self.videoModel.urls;
        NSLog(@"dataSource.count =%zd",self.dataSource.count);
        NSLog(@"urls.count =%zd",self.videoModel.urls.count);
      
        [self.collection.mj_footer endRefreshing];
        [self.collection reloadData];
        self.player.assetURLs =   self.videoModel.urls;
        if (self.videoModel.isHaveNomoreData) {
            [self.collection.mj_footer endRefreshingWithNoMoreData];
        }

    }];
}

- (void)queryBarrage{
    self.cur_Barindex = 0;
    [PlayVideo_Model queryBarragewithsku:self.cur_sku callBack:^(NSMutableArray *barrageArr, NSError *error) {
        if (barrageArr) {
            self.barrageArr = barrageArr;
            [self.timer fire];
        }
    }];
}

//弹幕动画
- (void)doAniMation{
    [self.barRage startAnimation];
    [self.barRage setModel:self.barrageArr[self.cur_Barindex]];
    [self delayDoWork:5 WithBlock:^{
        [self.barRage disMis];
    }];
    NSInteger count = self.barrageArr.count;
    if (self.cur_Barindex < count) {
        self.cur_Barindex ++;
        self.cur_Barindex = (self.cur_Barindex == count)?0: self.cur_Barindex;
    }else if (self.cur_Barindex == count){
        self.cur_Barindex = 0;
    }
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PlayVideo_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecTioncellId forIndexPath:indexPath];
     SearchResulGoodInfo *info = self.dataSource[indexPath.row];
     [cell setInfoModel:info];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - getter
- (UICollectionView *)collection{
    if (!_collection) {
        CGFloat height = SCREEN_HEIGHT;
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH;
        }
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = self.view.frame.size.width;
        CGFloat itemHeight = height;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) collectionViewLayout:layout];
        _collection.backgroundColor = RGBColor(242, 242, 242);
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.pagingEnabled = YES;
        _collection.showsVerticalScrollIndicator = NO;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.scrollsToTop = NO;
        NSString *cellStr = NSStringFromClass([PlayVideo_Cell class]);
        [_collection registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
        
          @weakify(self)
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self.player stopCurrentPlayingCell];
            [self queryGoodData];
        }];
        
        _collection.mj_footer = footer;
        
        /// 停止的时候找出最合适的播放
      
        _collection.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (self.player.playingIndexPath) return;
            if (indexPath.row == self.dataSource.count-1) {
                /// 加载下一页数据
                NSLog(@"加载下一页数据");
            }
            NSLog(@"xxx %zd",indexPath.row);
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
            SearchResulGoodInfo *info = self.dataSource[indexPath.row];
            self.cur_sku  =  info.sku;
            [self queryBarrage];
        };
    
    }
    return _collection;
}

- (ZFDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFDouYinControlView new];
    }
    return _controlView;
}

- (PlayVideo_Model *)videoModel{
    if (!_videoModel) {
        _videoModel = [PlayVideo_Model new];
    }
    return _videoModel;
}

- (PlayVideo_Barrage *)barRage{
    if (!_barRage) {
        _barRage = [PlayVideo_Barrage viewFromXib];
        _barRage.alpha = 0.0;
        _barRage.frame = CGRectMake(12, SCREEN_HEIGHT - 300, 200, 22);
        [self.view addSubview:_barRage];
    }
    return _barRage;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = @[].mutableCopy;
    }
    return _urls;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer =[NSTimer timerWithTimeInterval:3 target:[MJProxy proxyWithTarget:self] selector:@selector(doAniMation) userInfo:nil repeats:YES] ;
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}


@end
