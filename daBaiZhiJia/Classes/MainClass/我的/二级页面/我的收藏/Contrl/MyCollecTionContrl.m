//
//  MyCollecTionContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyCollecTionContrl.h"
#import "MyCollecTionCell.h"
#import "MyCollecTionBottom.h"
#import "MyCollecTionModel.h"
#import "GoodDetailContrl.h"
static NSString *cellId = @"cellId";
@interface MyCollecTionContrl ()<UITableViewDelegate,UITableViewDataSource,MyCollecTionModelDelegate>
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MyCollecTionBottom *footView;

@property (nonatomic, strong) MyCollecTionModel *model;

@property (nonatomic, strong)  NSArray *dataSource;
@end

@implementation MyCollecTionContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self.model queryData];
}


#pragma mark - UITableViewDataSource &UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollecTionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    MyCollecTionGoodInfo *info = self.dataSource[indexPath.row];
    info.indexPath = indexPath;
    [cell setModel:info];
    @weakify(self);
    cell.selectBlock = ^(NSIndexPath * _Nullable indexPath, BOOL isSelected) {
        @strongify(self);
         MyCollecTionGoodInfo *info = self.dataSource[indexPath.row];
        info.isSelected = isSelected;
        [self.footView setModelWithArray:self.dataSource];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     MyCollecTionGoodInfo *info = self.dataSource[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - MyCollecTionModelDelegate
- (void)model:(MyCollecTionModel *)model querySucWithGood_Artic:(NSArray *)dataSoure{
    self.dataSource = dataSoure;
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)noticeNomoreDataWithHomeModel:(MyCollecTionModel *)model{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)model:(MyCollecTionModel *)model noticeErrorNet:(NSError *)error{
}

- (void)noticeBlankViewWithModel:(MyCollecTionModel *)model{
    UIImage *blankImage = ZDBImage(@"img_like01");
    UIImageView *blank = [[UIImageView alloc] initWithImage:blankImage];
    blank.center = self.view.center;
    [self.view addSubview:blank];
}

- (void)model:(nonnull MyCollecTionModel *)model deleteSuc:(nonnull id)res {
    self.dataSource = self.model.goodArray;
    [self.tableView reloadData];
    if (self.dataSource.count == 0) {
        [self noticeBlankViewWithModel:self.model];
        self.footView.hidden = YES;
        self.tableView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - rightBtnAction
- (void)clickrightBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.isSelected) {
        self.footView.hidden = NO;
        self.tableView.height-= 60;
        for (MyCollecTionGoodInfo *info in self.dataSource) {
            info.imageLeadCons = 43;
        }
    }else{
        self.footView.hidden = YES;
        self.tableView.height += 60;
        for (MyCollecTionGoodInfo *info in self.dataSource) {
            info.imageLeadCons = 11;
        }
    }
    [self.tableView reloadData];
}


#pragma mark - getter

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"管理" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(clickrightBtn:) forControlEvents:UIControlEventTouchUpInside
         ];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitleColor:RGBColor(255, 223, 223) forState:UIControlStateNormal];
        [_rightBtn sizeToFit];
    }
    return _rightBtn;
}


- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat orgy = NavigationBarBottom(self.navigationController.navigationBar);
        CGFloat height =IS_X_Xr_Xs_XsMax ? SCREEN_HEIGHT - orgy - Bottom_Safe_AreaH: SCREEN_HEIGHT - orgy;
        CGRect frame = CGRectMake(0, orgy + 5, self.view.width, height);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBColor(245, 245, 245);
        [_tableView registerNib:[UINib nibWithNibName:@"MyCollecTionCell" bundle:nil] forCellReuseIdentifier:cellId];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *headView=  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.1 )];
        _tableView.tableHeaderView = headView;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 137;
        @weakify(self);
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            NSLog(@" 加载更多数据");
            [self.model queryData];
            
        }];
        [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (MyCollecTionBottom *)footView{
    if (!_footView) {
        _footView = [MyCollecTionBottom viewFromXib];
        [self.view addSubview:_footView];
        CGFloat origy = 0;
        if (IS_X_Xr_Xs_XsMax) {//34 是安全区域的高度
            origy = SCREEN_HEIGHT - 60 - Bottom_Safe_AreaH;
        }else{
            origy = SCREEN_HEIGHT - 60;
        }
        
        CGRect frame = CGRectMake(0,origy, SCREEN_WIDTH, 60);
        _footView.frame = frame;
        _footView.hidden = YES;
        @weakify(self);
        _footView.block = ^(NSInteger type, BOOL isSelect) {
            @strongify(self);
            if (type == 1) {
                for (MyCollecTionGoodInfo *info in self.dataSource) {
                    info.isSelected = isSelect;
                }
                [self.tableView reloadData];
                
            }else{
                NSMutableArray *skus = @[].mutableCopy;
                for (MyCollecTionGoodInfo *info in self.dataSource) {
                    if (info.isSelected) {
                        [skus addObject:info.sku];
                    }
                }
                if (skus.count == 0) {
                    [YJProgressHUD showMsgWithoutView:@"请选择商品"];
                    return;
                }
                UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除该收藏?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }] ;
                
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    [self.model deleteAction];
                }] ;
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
            }
        };
    }
    return _footView;
}

- (MyCollecTionModel *)model{
    if (!_model) {
        _model = [[MyCollecTionModel alloc] init];
        _model.delegate = self;
    }
    return _model;
}






@end
