//
//  Home_Com_Group_Recom.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/24.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_Com_Group_Recom.h"
#import "Home_Com_Group_Model.h"
#import "Home_Com_Group_Cell.h"

@interface Home_Com_Group_Recom ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)  UIImageView *bannerIma;

@property (nonatomic, strong) Home_Com_Group_Model *model;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, strong) NSMutableArray *goodArr;
@end

static NSString *cellId = @"cellId";
@implementation Home_Com_Group_Recom

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"社群推荐";
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_retBlack"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.leftBarButtonItem = leftBar;
  
    
    [self handleTableView];
    [self queryData];
}



- (void)queryData{
    [self.model queryDataWithBlock:^(NSMutableArray *goodArr,NSString*logo,NSError *error) {
        if (goodArr) {
         
            if (self.model.isHaveNomoreData) {
                [self.tableView.mj_footer  endRefreshing];
                [self.tableView.mj_footer  endRefreshingWithNoMoreData];
            }else{
                self.logo = logo;
                self.goodArr = goodArr;
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar navBarBackGroundColor:UIColor.whiteColor image:nil isOpaque:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBColor(38, 38, 38) ,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar navBarBackGroundColor:ThemeColor image:nil isOpaque:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor ,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
}

- (void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Home_Com_Group_Cell *cusCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    [cusCell setModel:info];
    return cusCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *imageV = self.bannerIma;
    [imageV setDefultPlaceholderWithFullPath:self.logo];
    return imageV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  (140.f/355 *(SCREEN_WIDTH - 30));
}

#pragma mark - private
- (void)handleTableView{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1f)];
    [self.tableView registerNib:[UINib nibWithNibName:@"Home_Com_Group_Cell" bundle:nil]  forCellReuseIdentifier:cellId];
    @weakify(self);
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        NSLog(@"加载更多数据");
        [self queryData];
    }];
    [footer setTitle:@"已经是最后一页了" forState:MJRefreshStateNoMoreData];
     self.tableView.mj_footer = footer;
}

#pragma mark - getter

- (Home_Com_Group_Model *)model{
    if (!_model) {
        _model  = [Home_Com_Group_Model new];
    }
    return _model;
}
- (UIImageView *)bannerIma{
    if (!_bannerIma) {
        _bannerIma = [[UIImageView alloc] init];
    }
    return _bannerIma;
}

@end
