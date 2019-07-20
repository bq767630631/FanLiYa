//
//  Home_zbyView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_zbyView.h"
#import "Home_zbyCell.h"
#import "HomePage_Model.h"
#import "ZbySecContrl.h"
#import "PageViewController.h"
#import "PlayVideoContrl.h"
#import "ZF_PlayVideoContrl.h"
@interface Home_zbyView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collecTionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *singleLayout;//一排-个视图
@property (weak, nonatomic) IBOutlet UIView *line;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end
static NSString *cellId = @"cellId";
@implementation Home_zbyView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.collecTionView.dataSource = self;
    self.collecTionView.delegate = self;
    self.collecTionView.collectionViewLayout = self.singleLayout;
    self.collecTionView.showsHorizontalScrollIndicator = NO;
    [self.collecTionView registerNib:[UINib nibWithNibName:NSStringFromClass([Home_zbyCell class]) bundle:nil] forCellWithReuseIdentifier:cellId];
}

- (void)setInfoWithModel:(id)model{
    self.dataSource = model;
    [self.collecTionView reloadData];
    [self layoutIfNeeded];
    if (self.dataSource.count ==0) {
        self.height = 0;
        self.hidden = YES;
    }else{
        self.hidden = NO;
        self.height = self.line.bottom;
    }
    NSLog(@"Home_zbyView.h =%.f", self.height);
}

- (void)layoutSubviews{
    [super layoutSubviews];
   
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Home_zbyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    SearchResulGoodInfo *info = self.dataSource[indexPath.row];
    [cell setInfoWithModel:info];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      SearchResulGoodInfo *info = self.dataSource[indexPath.row];
    //  PlayVideoContrl *play  = [[PlayVideoContrl alloc]initWithInfo:info];
      PageViewController *page  = (PageViewController *)self.viewController;
    ZF_PlayVideoContrl *zfplay = [[ZF_PlayVideoContrl alloc] initWithInfo:info];
    [page.naviContrl pushViewController:zfplay animated:YES];
}


- (IBAction)moreAction:(UIButton *)sender {
    NSLog(@"");
    ZbySecContrl *zbySec = [ZbySecContrl new];
    PageViewController *page = (PageViewController *)self.viewController;
    [page.naviContrl pushViewController:zbySec animated:YES];
}

#pragma mark - private
- (UICollectionViewFlowLayout *)singleLayout{
    if (!_singleLayout) {
        _singleLayout = [[UICollectionViewFlowLayout alloc] init];
        _singleLayout.minimumInteritemSpacing = 10;
        _singleLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _singleLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _singleLayout.itemSize = CGSizeMake(135, 191);
    }
    return _singleLayout;
}
@end
