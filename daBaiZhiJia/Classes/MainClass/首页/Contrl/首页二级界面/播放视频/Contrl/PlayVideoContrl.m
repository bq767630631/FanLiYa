//
//  PlayVideoContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PlayVideoContrl.h"
#import "SDCycleScrollView.h"
#import "PlayVideo_Cell.h"
#import "ZbySec_Model.h"
#import "GKDYVideoPlayer.h"
#import "PlayVideo_Model.h"
#import "PlayVideo_Barrage.h"
#import "MJProxy.h"

@interface PlayVideoContrl ()<UIScrollViewDelegate,GKDYVideoPlayerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) UIScrollView *scroView;
//@property (nonatomic, strong) ZbySec_Model *model;
@property (nonatomic, strong) PlayVideo_Model *videoModel;
@property (nonatomic, strong) NSMutableArray *goodArray;
@property (nonatomic, strong) GKDYVideoPlayer *player;

@property (nonatomic, strong) PlayVideo_Cell *cur_cell;

@property (nonatomic, strong) SearchResulGoodInfo *firstInfo;
//@property (nonatomic, assign) NSInteger  cur_Barindex;
@property (nonatomic, assign) BOOL  isFisrtPage; //是否是第一页,默认是第一页
@property (nonatomic, assign) BOOL  is_loadMore;
@property (nonatomic, assign) CGFloat lastOffSetY;

@property (nonatomic, strong) PlayVideo_Barrage *barRage;//弹幕
@property (nonatomic, assign) NSInteger cur_Barindex;//显示当前的弹幕内容
@property (nonatomic, strong) NSMutableArray *barrageArr;//弹幕内容数组
@property (nonatomic, copy)  NSString *cur_sku;
@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, assign) NSInteger  page;

@end
static NSString *collecTioncellId = @"collecTioncellId";
@implementation PlayVideoContrl
- (instancetype)initWithInfo:(SearchResulGoodInfo *)info{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.cur_sku = info.sku;
    self.page = 1;
    self.isFisrtPage = YES;
    self.firstInfo = info;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collection];
    [self queryGoodData];
    [self queryBarrage];
}

- (void)queryGoodData{
    [self.videoModel queryZBYInfoCallBack:^(NSMutableArray *goodArr, NSError *error) {
        if (self.videoModel.isHaveNomoreData) {
              [self.collection.mj_footer endRefreshingWithNoMoreData];
        }
        self.goodArray = self.videoModel.goodArr;
        [self.goodArray insertObject:self.firstInfo atIndex:0];
        [self.collection.mj_footer endRefreshing];
        [self.collection reloadData];
        
        
        //如果不是第一页，保留上一页的数据
        if ( self.page!=1) {
            NSInteger myindex = (self.goodArray.count - goodArr.count) ;
            NSLog(@"myindex =%zd",myindex);
            NSIndexPath *indexParh  = [NSIndexPath indexPathForItem:myindex inSection:0];
            [self.collection scrollToItemAtIndexPath:indexParh atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        self.page ++;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.player resumePlay];
    [self.timer fire];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player pausePlay];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc{
    NSLog(@"");
    [self.player removeVideo];
    self.player = nil;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"goodArray.count =%zd",self.goodArray.count);
    return self.goodArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    PlayVideo_Cell *cells = [collectionView dequeueReusableCellWithReuseIdentifier:collecTioncellId forIndexPath:indexPath];
   // SearchResulGoodInfo *info = self.goodArray[indexPath.row];
//    [cells setInfoModel:info];
    return cells;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath1  =%@",indexPath);
//    NSLog(@"indexPath2 =%@",index);
    if (self.isFisrtPage) {
             self.isFisrtPage = NO;
             SearchResulGoodInfo *info = self.goodArray[indexPath.row];
            [self delayDoWork:0.2f WithBlock:^{
                NSLog(@"title =%@",info.title);
                NSLog(@"video %@",info.video);
                PlayVideo_Cell *cus_cell= collectionView.visibleCells.lastObject;
                [cus_cell setInfoModel:info];
                cus_cell.playImage.hidden = YES;
                self.cur_cell = cus_cell;
                [self.player playVideoWithView: cus_cell.goodImage url:info.video];
            }];
    }else{
    
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
   self.cur_cell =  collectionView.visibleCells.lastObject;
    NSIndexPath *index  =  [collectionView indexPathForCell:self.cur_cell];
     NSLog(@"indexPath2  =%@",indexPath);
     NSLog(@"indexPath3 =%@",index);
    SearchResulGoodInfo *info = self.goodArray[index.row];
    [self.cur_cell setInfoModel:info];
  
    self.cur_Barindex = index.row;
    PlayVideo_Cell *cusCell = (PlayVideo_Cell*)cell;
    cusCell.playImage.hidden = YES;
 
    self.cur_sku = info.sku;
    [self delayDoWork:0.2f WithBlock:^{
        NSLog(@"title =%@",info.title);
        NSLog(@"video %@",info.video);
        [self.player playVideoWithView: self.cur_cell.goodImage url:info.video];
    }];
    [self queryBarrage];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     // SearchResulGoodInfo *info = self.goodArray[indexPath.row];
//
//    NSLog(@"self.cur_cell =%@", self.cur_cell);
//    NSLog(@"visibleCells =%@",collectionView.visibleCells);
//    NSLog(@"lastcell =%@",collectionView.visibleCells.lastObject);
     // SearchResulGoodInfo *info = self.goodArray[indexPath.row];
    if (self.player.isPlaying) {
        [self.player pausePlay];
        self.cur_cell.playImage.hidden = NO;
    }else{
        [self.player resumePlay];
        self.cur_cell.playImage.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offset_y = scrollView.mj_offsetY;
//    NSLog(@"%.f",offset_y);
    if (scrollView.contentOffset.y - self.lastOffSetY > 0) {
          [self.player removeVideo];
//        NSLog(@"正在向上滑动");
    }else {
          [self.player removeVideo];
//        NSLog(@"正在向下滑动");
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastOffSetY = scrollView.contentOffset.y;
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

#pragma mark - GKDYVideoPlayerDelegate
- (void)player:(GKDYVideoPlayer *)player statusChanged:(GKDYVideoPlayerStatus)status{
    switch (status) {
        case GKDYVideoPlayerStatusPrepared:
            NSLog(@"准备播放");
            break;
        case GKDYVideoPlayerStatusLoading:
            NSLog(@"加载中");
             self.cur_cell.playImage.hidden = YES;
            [SVProgressHUD show];
            break;
        case GKDYVideoPlayerStatusPlaying:{
            NSLog(@"播放中");
            self.cur_cell.playImage.hidden = YES;
            [SVProgressHUD popActivity];
            
        }
            break;
        case GKDYVideoPlayerStatusPaused:
        {
            NSLog(@"暂停");
            self.cur_cell.playImage.hidden = NO;
        }
            break;
        case GKDYVideoPlayerStatusEnded:
            NSLog(@"播放完成");
        {  [self delayDoWork:0.1f WithBlock:^{
                   [self.player resetPlay];
        }];}
            break;
        case GKDYVideoPlayerStatusError:
            NSLog(@"GKDYVideoPlayerStatusError");
            [YJProgressHUD showMsgWithoutView:@"播放出现错误"];
            break;
        default:
            break;
    }
//    NSLog(@"status =%zd",status);
}

- (void)player:(GKDYVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress{
    if (currentTime == totalTime) {
        player.status = GKDYVideoPlayerStatusEnded;
    }
}

#pragma mark - getter

- (UICollectionView *)collection{
    if (!_collection) {
        CGFloat height = SCREEN_HEIGHT;
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH;
        }
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, height);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) collectionViewLayout:layout];
        _collection.backgroundColor = RGBColor(242, 242, 242);
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.pagingEnabled = YES;
        _collection.showsVerticalScrollIndicator = NO;
        NSString *cellStr = NSStringFromClass([PlayVideo_Cell class]);
        [_collection registerNib:[UINib nibWithNibName:cellStr bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
        @weakify(self);
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
              self.is_loadMore = YES;
             [self.player removeVideo];
             [self queryGoodData];
        }];
        _collection.mj_footer = footer;
    }
    return _collection;
}

- (NSMutableArray *)goodArray{
    if (!_goodArray) {
        _goodArray = [NSMutableArray array];
    }
    return _goodArray;
}

//- (ZbySec_Model *)model{
//    if (!_model) {
//        _model = [ZbySec_Model new];
//    }
//    return _model;
//}

- (PlayVideo_Model *)videoModel{
    if (!_videoModel) {
        _videoModel = [PlayVideo_Model new];
    }
    return _videoModel;
}

- (GKDYVideoPlayer *)player{
    if (!_player) {
        _player = [GKDYVideoPlayer new];
        _player.delegate = self;
    }
    return _player;
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

- (NSTimer *)timer{
    if (!_timer) {
        _timer =[NSTimer timerWithTimeInterval:3 target:[MJProxy proxyWithTarget:self] selector:@selector(doAniMation) userInfo:nil repeats:YES] ;
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
@end
