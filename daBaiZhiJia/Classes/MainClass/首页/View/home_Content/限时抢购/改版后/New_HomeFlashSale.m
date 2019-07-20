//
//  New_HomeFlashSale.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "New_HomeFlashSale.h"
#import "New_HomeFlashSaleGoodCell.h"
#import "GoodDetailContrl.h"
#import "HomePage_Model.h"
#import "LimitSale_SecContrl.h"
#import "PageViewController.h"


@interface New_HomeFlashSale ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collecTionView;
@property (weak, nonatomic) IBOutlet UIView *lineV;

@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排-个视图
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, copy)  NSString *cur_time_;
@property (nonatomic, assign) NSInteger  cur_index;
@property (nonatomic, strong) NSArray *dataSouce;
@end
static NSString *cellId = @"cellId";
@implementation New_HomeFlashSale

-(void)awakeFromNib{
    [super awakeFromNib];
    self.collecTionView.dataSource = self;
    self.collecTionView.delegate = self;
    self.collecTionView.collectionViewLayout = self.singleLayout;
    self.collecTionView.showsHorizontalScrollIndicator = NO;
    [self.collecTionView registerNib:[UINib nibWithNibName:NSStringFromClass([New_HomeFlashSaleGoodCell class]) bundle:nil] forCellWithReuseIdentifier:cellId];
}

- (void)setInfoWith:(NSMutableArray *)timeArr goodArr:(NSMutableArray *)goodArr{
    self.timeArr = timeArr;
    NSString *cur_time = @"";
    for (int  i = 0; i < timeArr.count; i ++) {
        HomePage_FlashSaleInfo *info  = timeArr[i];
        if ([info.status isEqualToString:@"疯抢中"]) {
            self.cur_time_ = info.time_;
            self.cur_index = i;
            cur_time = info.time;
            break;
        }
    }
    NSString *title = @"";
    if (Is_Show_Info) {
        title = [NSString stringWithFormat:@"%@正在开抢>",cur_time];
        self.buyBtn.userInteractionEnabled = YES;
    }else{
        title = [NSString stringWithFormat:@"%@正在开抢",cur_time];
        self.buyBtn.userInteractionEnabled = NO;
    }
    [self.buyBtn setTitle:title forState:UIControlStateNormal];
    self.dataSouce = goodArr;
    [self.collecTionView reloadData];
    
    if (goodArr.count >0) {
        self.height = self.lineV.bottom;
    }else{
        self.height = 0.f;
    }
}

#pragma mark - UICollectionViewDataSource &UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSouce.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    New_HomeFlashSaleGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    SearchResulGoodInfo *info = self.dataSouce[indexPath.row];
    [cell setInfoModel:info];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      SearchResulGoodInfo *info = self.dataSouce[indexPath.row];
     PageViewController *page  = (PageViewController *)self.viewController;
     GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
     [page.naviContrl pushViewController:detail animated:YES];
}

- (IBAction)buyBtnAction:(UIButton *)sender {
    PageViewController *page  = (PageViewController *)self.viewController;
    LimitSale_SecContrl *limit = [[LimitSale_SecContrl alloc] initWithTime_:self.cur_time_ timeArr:self.timeArr index:self.cur_index];
    [page.naviContrl pushViewController:limit animated:YES];
}

#pragma mark - private
- (UICollectionViewFlowLayout *)singleLayout{
    if (!_singleLayout) {
        _singleLayout = [[UICollectionViewFlowLayout alloc] init];
        _singleLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _singleLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _singleLayout.minimumInteritemSpacing = 10.f;
        _singleLayout.itemSize = CGSizeMake(90, 138);
    }
    return _singleLayout;
}
@end
