//
//  Home_FlashSale.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_FlashSale.h"
#import "Home_FlashTimeStaCell.h"
#import "HomePage_Model.h"
#import "NSTimer+Extention.h"
#import "Home_FlashSaleGoodCell.h"
#import "LimitSale_SecContrl.h"
#import "GoodDetailContrl.h"
#import "PageViewController.h"
#import "MJProxy.h"

#define Cell_H 139
#define KTimeCell_W (70.f*SCALE_Normal)
@interface Home_FlashSale ()<UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collecTionView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排-个视图

@property (weak, nonatomic) IBOutlet UILabel *surplusTime;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHCons;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *timeArr;

@property (nonatomic, strong) NSMutableArray *goodArr;
@property (nonatomic, copy)  NSString *cur_time_;
@property (nonatomic, assign) NSInteger  cur_index;
@property (nonatomic, assign) NSInteger  timediff;
@end
static NSString *cellId = @"cellId";
static NSString *tableCellId = @"cellId";
@implementation Home_FlashSale

- (void)awakeFromNib{
    [super awakeFromNib];
    self.collecTionView.dataSource = self;
    self.collecTionView.delegate = self;
    self.collecTionView.collectionViewLayout = self.singleLayout;
    self.collecTionView.showsHorizontalScrollIndicator = NO;
    [self.collecTionView registerNib:[UINib nibWithNibName:NSStringFromClass([Home_FlashTimeStaCell class]) bundle:nil] forCellWithReuseIdentifier:cellId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = Cell_H;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Home_FlashSaleGoodCell class]) bundle:nil] forCellReuseIdentifier:tableCellId];
}

- (void)setInfoWith:(NSMutableArray *)timeArr goodArr:(NSMutableArray *)goodArr timeDif:(NSInteger)timeDif{
    self.timeArr = timeArr;
    self.goodArr = goodArr;
    [self.collecTionView reloadData];
    [self.tableView reloadData];
  
    for (int  i = 0; i < timeArr.count; i ++) {
        HomePage_FlashSaleInfo *info  = timeArr[i];
        if ([info.status isEqualToString:@"疯抢中"]) {
            self.cur_time_ = info.time_;
            self.cur_index = i;
            break;
        }
    }
   
    [self delayDoWork:0.2 WithBlock:^{
        CGFloat offsetX = self.cur_index*KTimeCell_W  - KTimeCell_W*1.5;
        NSLog(@"xx1 =%.f",offsetX);
        [self.collecTionView setContentOffset: CGPointMake(offsetX, 0) animated:YES];
    }];
   
    if (goodArr.count==0) {
        self.tableHCons.constant = 0;
    }else  if (goodArr.count <3 &&goodArr.count >0) {//1,2
         self.tableHCons.constant = goodArr.count *Cell_H;
    }else{
         self.tableHCons.constant = 3 *Cell_H;
    }
   
    self.timediff = timeDif;
    [self.timer fire];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.height = self.tableView.top +  self.tableHCons.constant;
   
}

- (void)timerAction{
    
    NSString *str_hour   = [NSString stringWithFormat:@"%02ld",  self.timediff / 3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", ( self.timediff % 3600) / 60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",  self.timediff % 60];
   // NSLog(@"%@ %@ %@",str_hour,str_minute,str_second);
     self.surplusTime.text = [NSString stringWithFormat:@"本场还剩 %@:%@:%@",str_hour,str_minute,str_second];
     self.timediff --;
    if (self.timediff ==0) {
        self.surplusTime.text  = @"";
        [self.timer invalidate] ;
        self.timer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:HomePageRefresh_NotiFacation object:nil];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.timeArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Home_FlashTimeStaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    HomePage_FlashSaleInfo *info = self.timeArr[indexPath.row];
    [cell setInfo:info];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomePage_FlashSaleInfo *info = self.timeArr[indexPath.row];
     PageViewController *page  = (PageViewController *)self.viewController;
    LimitSale_SecContrl *limit = [[LimitSale_SecContrl alloc] initWithTime_: info.time_ timeArr:self.timeArr index:indexPath.row];
    [page.naviContrl pushViewController:limit animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Home_FlashSaleGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellId];
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    info.indexPath = indexPath;
    [cell setModel:info];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      PageViewController *page  = (PageViewController *)self.viewController;
      SearchResulGoodInfo *info = self.goodArr[indexPath.row];
      GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
      [page.naviContrl pushViewController:detail animated:YES];
}

#pragma mark - action
- (IBAction)moreAction:(UIButton *)sender {
    PageViewController *page  = (PageViewController *)self.viewController;
    LimitSale_SecContrl *limit = [[LimitSale_SecContrl alloc] initWithTime_:self.cur_time_ timeArr:self.timeArr index:self.cur_index];
    [page.naviContrl pushViewController:limit animated:YES];
}

#pragma mark - private
- (UICollectionViewFlowLayout *)singleLayout{
    if (!_singleLayout) {
        _singleLayout = [[UICollectionViewFlowLayout alloc] init];
        _singleLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 0);
        _singleLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _singleLayout.itemSize = CGSizeMake(KTimeCell_W, 40);
    }
    return _singleLayout;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer =[NSTimer timerWithTimeInterval:1.0 target:[MJProxy proxyWithTarget:self] selector:@selector(timerAction) userInfo:nil repeats:YES] ;
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
@end
