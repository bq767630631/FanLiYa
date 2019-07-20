//
//  Brand_ShowDetail.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Brand_ShowDetail.h"
#import "Brand_ShowModel.h"
#import "Brand_ShowDetailHead.h"
#import "Brand_ShowDetailCell.h"
#import "GoodDetailContrl.h"
@interface Brand_ShowDetail ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic,strong)  UITableView *tableV;
@property (nonatomic, strong) Brand_ShowDetailHead *head;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) BrandCat_info *brandInfo;

@end
static NSString *cellId = @"cellId";
@implementation Brand_ShowDetail
- (instancetype)initWithId:(NSString *)brandId{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.brandId = brandId;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scroView];
    [Brand_ShowModel quedyBrandDetailBrandId:self.brandId WickBloc:^(BrandCat_info *info, NSMutableArray *goodArr, NSError *error) {
        if (!error) {
            NSLog(@"goodArr.count =%zd",goodArr.count);
            [self.head setInfoWithModel:info];
            self.dataSource = goodArr;
            [self.tableV reloadData];
            self.tableV.top = self.head.bottom + 10;
            CGFloat tbH = goodArr.count *self.tableV.rowHeight + 50;
            if (IS_X_Xr_Xs_XsMax) {
                tbH += Bottom_Safe_AreaH;
            }
            self.tableV.height = tbH;
            self.scroView.contentSize = CGSizeMake(0, self.head.height + tbH);
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:ZDBImage(@"img_brandDetail1") forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.clearColor] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Brand_ShowDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    SearchResulGoodInfo *info = self.dataSource[indexPath.row];
    [cell setInfoWithModel:info];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.dataSource[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - getter
- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat height = SCREEN_HEIGHT - NavigationBarBottom(self.navigationController.navigationBar);
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH;
        }
        _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBarBottom(self.navigationController.navigationBar), SCREEN_WIDTH, height)];
        _scroView.showsVerticalScrollIndicator = NO;
        _scroView.backgroundColor = RGBColor(245, 245, 245);
        [_scroView addSubview:self.head];
        [_scroView addSubview:self.tableV];
    }
    return _scroView;
}

- (UITableView *)tableV{
    if (!_tableV) {
        CGFloat height = SCREEN_HEIGHT - NavigationBarBottom(self.navigationController.navigationBar);
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH;
        }
        CGRect frame = CGRectMake(15, self.head.bottom + 10,SCREEN_WIDTH - 15*2, height);
        NSLog(@"_tableV.frame =%@", NSStringFromCGRect(frame));
        _tableV = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableV.backgroundColor =RGBColor(245, 245, 245);
        _tableV.delegate  = self;
        _tableV.dataSource = self;
        _tableV.rowHeight = 96.f;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.showsVerticalScrollIndicator = NO;
        _tableV.scrollEnabled = NO;
        UIView *uiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1f)];
        _tableV.tableHeaderView = uiv;
        [_tableV registerNib:[UINib nibWithNibName:NSStringFromClass([Brand_ShowDetailCell class]) bundle:nil] forCellReuseIdentifier:cellId];
      
    }
    return _tableV;
}

- (Brand_ShowDetailHead *)head{
    if (!_head) {
        _head = [Brand_ShowDetailHead viewFromXib];
        _head.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    }
    return _head;
}
@end
