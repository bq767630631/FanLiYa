//
//  NewPeople_EnjoyContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeople_EnjoyContrl.h"
#import "ZKCycleScrollView.h"
#import "NewPeople_EnjoyCell.h"
#import "NewPeople_EnjoyModel.h"
#import "DBZJ_ComShareView.h"


@interface NewPeople_EnjoyContrl ()<ZKCycleScrollViewDelegate,ZKCycleScrollViewDataSource>
@property (nonatomic, strong) ZKCycleScrollView *scroView;
@property (nonatomic, strong) NSArray *listArr;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, assign) NSInteger  cur_index;
@end
static NSString *KcellId = @"KcellId";
@implementation NewPeople_EnjoyContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    [self.view addSubview:self.scroView];
    [self.view addSubview:self.shareBtn];
    [self queryData];
}

- (void)queryData{
    [NewPeople_EnjoyModel queryHaiBaoWitkBlcok:^(NSArray*list) {
        if (list) {
            self.listArr = list;
            [self.scroView reloadData];
        }
    }];
}


#pragma mark- action
- (void)shareAction{
    NSLog(@"");
    NewPeople_EnjoyCell *cell = [NewPeople_EnjoyCell viewFromXib];
    cell.frame = self.view.bounds;
    [cell setModel:self.listArr[self.cur_index]];
    
    CGSize size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self delayDoWork:0.2 WithBlock:^{
        UIImage*image = [self getmakeImageWithView:cell andWithSize:size];
        
        DBZJ_ComShareView *share = [DBZJ_ComShareView viewFromXib];
        share.isFrom_haiBao = YES;
        share.frame  = self.view.bounds;
        share.model = image;
        [share show];
    }];
}

#pragma mark - ZKCycleScrollViewDataSource &ZKCycleScrollViewDelegate
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView{
    return self.listArr.count;
}

- (UICollectionViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index{
    NewPeople_EnjoyCell *cell =  [cycleScrollView dequeueReusableCellWithReuseIdentifier:KcellId forIndex:index];
    NewPeople_EnjoyInfo *info = self.listArr[index];
    [cell setModel:info];
    return cell;
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    self.cur_index = toIndex;
    NSLog(@" fromIndex: %zd  toIndex =%zd", fromIndex, toIndex);
}


#pragma mark - getter

- (ZKCycleScrollView *)scroView{
    if (!_scroView) {
        CGFloat orgy = NavigationBarBottom(self.navigationController.navigationBar) + 35;
        CGRect frame = CGRectMake(0, orgy*SCALE_Normal, SCREEN_WIDTH, 458*SCALE_Normal);
        _scroView = [[ZKCycleScrollView alloc] initWithFrame:frame];
        _scroView.delegate = self;
        _scroView.dataSource = self;
        _scroView.hidesPageControl = YES;
        _scroView.autoScroll = NO;
        _scroView.itemSpacing = 20.f*SCALE_Normal;
        _scroView.itemZoomScale =  0.94;//0.85;
        _scroView.itemSize = CGSizeMake(257*SCALE_Normal, _scroView.bounds.size.height);
        [_scroView registerCellNib:[UINib nibWithNibName:@"NewPeople_EnjoyCell" bundle:nil] forCellWithReuseIdentifier:KcellId];
    }
    return _scroView;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(0, self.scroView.bottom + 40*SCALE_Normal, 257*SCALE_Normal, 40*SCALE_Normal);
        _shareBtn.centerX = SCREEN_WIDTH*0.5;
        _shareBtn.backgroundColor = RGBColor(51, 51, 51);
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        ViewBorderRadius(_shareBtn, _shareBtn.height*0.5, UIColor.clearColor);
        [_shareBtn setTitle:@"分享专属海报" forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
@end
