//
//  Home_EveeChoiView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_EveeChoiView.h"
#import "Home_EveeChoiCell.h"
#import "HomePage_Model.h"
#import "GoodDetailContrl.h"
#import "PageViewController.h"

@interface Home_EveeChoiView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *everyDayCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *everyCollecHCons;

@property (nonatomic, strong) UICollectionViewFlowLayout *doubleLayout;//一排两个视图
@property (nonatomic, strong) NSMutableArray *everyDayArry;
@end
static NSString *everyDaycellId = @"everyDaycellId";
@implementation Home_EveeChoiView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.everyDayCollection.dataSource = self;
    self.everyDayCollection.delegate = self;
    self.everyDayCollection.collectionViewLayout = self.doubleLayout;
   
    [self.everyDayCollection registerNib:[UINib nibWithNibName:NSStringFromClass([Home_EveeChoiCell class]) bundle:nil] forCellWithReuseIdentifier:everyDaycellId];
}

- (void)everyCollecNoticeDataWithArr:(NSMutableArray*)array{
//    NSLog(@"array.count =%zd",array.count);
//
//    NSLog(@"Item_Gap =%.f",Item_Gap);
    self.everyDayArry = array;
    [self.everyDayCollection reloadData];
    
        CGFloat contentH =  0;
        CGFloat wd = (SCREEN_WIDTH - Item_Gap*3 ) / 2;
        CGFloat item_H = wd + Margin;
        if (array.count %2 ==0) { //偶数
            contentH += item_H * array.count/2  + Item_Gap *array.count/2;
        }else{//奇数
            contentH += item_H * (array.count/2 + 1) + Item_Gap *(array.count/2+1);
        }

//    NSLog(@"contentH =%.f",contentH);
    self.everyCollecHCons.constant = contentH ;
    self.height = contentH + 44.5;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.everyDayArry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Home_EveeChoiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:everyDaycellId forIndexPath:indexPath];
    SearchResulGoodInfo *info = self.everyDayArry[indexPath.row];
    info.indexPath = indexPath;
    info.is_From_page = YES;
    [cell setModel:info];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat wd = (SCREEN_WIDTH - Item_Gap*3 ) / 2;
    CGFloat ht = wd + Margin;
    CGSize itemSize = CGSizeMake(wd,ht);
    return itemSize;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.everyDayArry[indexPath.row];
    PageViewController *page  = (PageViewController *)self.viewController;
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    [page.naviContrl pushViewController:detail animated:YES];
}

#pragma mark - private
- (UICollectionViewFlowLayout *)doubleLayout{
    if (!_doubleLayout) {
        _doubleLayout = [[UICollectionViewFlowLayout alloc] init];
        _doubleLayout.minimumLineSpacing = Item_Gap;
        _doubleLayout.minimumInteritemSpacing = Item_Gap;
        _doubleLayout.sectionInset = UIEdgeInsetsMake(Item_Gap, Item_Gap, 0, Item_Gap);
    }
    return _doubleLayout;
}

@end
