//
//  BrandSpecialArea.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "BrandSpecialArea.h"
#import "BrandSpecialAreaCell.h"
#import "PageViewController.h"
#import "HomePage_Model.h"
#import "Brand_Showcontrl.h"
#import "Brand_ShowDetail.h"
#define Gap 10.f
@interface BrandSpecialArea ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionV_H;

@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;
@property (nonatomic, strong) NSArray *dataSource;

@end
static NSString *cellId = @"cellId";
@implementation BrandSpecialArea

- (void)awakeFromNib{
    [super awakeFromNib];
    self.collectionV.dataSource = self;
    self.collectionV.delegate = self;
    self.collectionV.collectionViewLayout = self.singleLayout;
    self.collectionV.showsVerticalScrollIndicator = NO;
    [self.collectionV registerNib:[UINib nibWithNibName:NSStringFromClass([BrandSpecialAreaCell class]) bundle:nil] forCellWithReuseIdentifier:cellId];
    self.collectionV.scrollEnabled = NO;
}


- (void)setInfoWithModel:(id)model{
    self.dataSource = model;
    [self.collectionV reloadData];
    [self layoutIfNeeded];
    
    CGRect frame = self.collectionV.frame;
    CGFloat itemH = self.singleLayout.itemSize.height;
    frame.size.height = itemH * self.dataSource.count + Gap*2;
    self.collectionV_H.constant =  frame.size.height;
    self.collectionV.frame = frame;
    self.height = self.collectionV.bottom;
    NSLog(@"brandH =%.f",  self.height);
}

#pragma mark - UICollectionViewDataSource &UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandSpecialAreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    BrandCat_info *info = self.dataSource[indexPath.row];
    info.index = indexPath.row;
    [cell setInfoWithModel:info];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandCat_info *info = self.dataSource[indexPath.row];
     PageViewController *page = (PageViewController *)self.viewController;
    Brand_ShowDetail *detail = [[Brand_ShowDetail alloc] initWithId:info.brandid];
    [page.naviContrl pushViewController:detail animated:YES];
}


- (IBAction)moreAction:(UIButton *)sender {
    PageViewController *page = (PageViewController *)self.viewController;
    [page.naviContrl pushViewController:[Brand_Showcontrl new] animated:YES];
}

#pragma mark - private
- (UICollectionViewFlowLayout *)singleLayout{
    if (!_singleLayout) {
        _singleLayout = [[UICollectionViewFlowLayout alloc] init];
//        _singleLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _singleLayout.minimumLineSpacing = Gap;
        CGFloat ratio = 105.0f /347.0 ;
        CGFloat itemH = (SCREEN_WIDTH - 28.f)*ratio;
        NSLog(@"itemH =%.f",itemH);
        _singleLayout.itemSize = CGSizeMake(SCREEN_WIDTH , itemH);
    }
    return _singleLayout;
}

@end
