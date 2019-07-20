//
//  TeachYouContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import "TeachYouContrl.h"
#import "DBZJ_CommunityModel.h"
#import "DBZJ_ComNewHandCell.h"

@interface TeachYouContrl ()<UITableViewDataSource,DBZJ_CommunityModelDelegate>
@property (nonatomic, strong) UITableView *tableView3;
@property (nonatomic, strong) UIImageView *blankView;
@property (nonatomic, strong) DBZJ_CommunityModel *model;
@end

static NSString *newHandCell = @"newHandCell";
@implementation TeachYouContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新手教程";
    [self.model queryRecommendWithType:3];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.NewHandArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        DBZJ_ComNewHandCell *newCell = [tableView dequeueReusableCellWithIdentifier:newHandCell];
        CommunityRecommendInfo *info = self.model.NewHandArr[indexPath.row];
        info.indexPath = indexPath;
        [newCell setInfoWithModel:info];
        return newCell;
}

#pragma mark - DBZJ_CommunityModelDelegate
- (void)communityModel:(DBZJ_CommunityModel *)model dataSouse:(NSArray *)dataArr type:(NSInteger)type{
     self.blankView.hidden = YES;
    [self.tableView3 reloadData];
}

- (void)noticeNomoreDataWithCommunityModel:(DBZJ_CommunityModel *)model type:(NSInteger)type{
    [self.tableView3.mj_footer endRefreshing];
    [self.tableView3.mj_footer endRefreshingWithNoMoreData];
}

- (void)noticeBlankViewWithModel:(DBZJ_CommunityModel *)model type:(NSInteger)type{
    self.blankView.hidden = NO;
}

#pragma mark - getter
- (UITableView *)tableView3{
    if (!_tableView3) {
         CGFloat orgy = NavigationBarBottom(self.navigationController.navigationBar);
        CGFloat height = 0;
        if (IS_X_Xr_Xs_XsMax) {
            height = SCREEN_HEIGHT - orgy - Bottom_Safe_AreaH;
        }else{
            height = SCREEN_HEIGHT - orgy ;
        }
        CGRect frame = CGRectMake(0, orgy + 17, SCREEN_WIDTH, height);
        _tableView3 = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        UIView *tableHed = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1f)];
        _tableView3.tableHeaderView = tableHed;
        _tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView3.backgroundColor = RGBColor(245, 245, 245);
        self.view.backgroundColor = RGBColor(245, 245, 245);
        NSString *cell =  NSStringFromClass([DBZJ_ComNewHandCell class]);
        [_tableView3 registerNib:[UINib nibWithNibName:cell bundle:nil] forCellReuseIdentifier:newHandCell];
        _tableView3.dataSource = self;
        _tableView3.rowHeight = 180 *SCREEN_WIDTH/375 + 45;
        @weakify(self);
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self.model queryRecommendWithType:3];
            
        }];
        [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
        _tableView3.mj_footer = footer;
        [self.view addSubview:_tableView3];
    }
    
    return _tableView3;
}

- (UIImageView *)blankView{
    if (!_blankView) {
        _blankView = [[UIImageView alloc] initWithImage:ZDBImage(@"img_nodata_loading")];
        _blankView.center = self.tableView3.center;
        [self.view addSubview:_blankView];
    }
    return _blankView;
}


- (DBZJ_CommunityModel *)model{
    if (!_model) {
        _model = [DBZJ_CommunityModel new];
        _model.delegate = self;
    }
    return _model;
}




@end
