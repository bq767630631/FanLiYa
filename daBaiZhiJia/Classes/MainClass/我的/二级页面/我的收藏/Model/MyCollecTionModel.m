//
//  MyCollecTionModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/15.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyCollecTionModel.h"
@interface MyCollecTionModel ()

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) BOOL haveNoMoreData;   //商品没有更多数据。默认是否
@end

@implementation MyCollecTionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNum = 1;
        self.goodArray = [NSMutableArray array];
    }
    return self;
}

- (void)queryData{
    if (self.haveNoMoreData) {
        [self noticeNoMoreData];
        return;
    }
    NSDictionary *para = @{@"token":ToKen,@"page":@(self.pageNum),@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/favoriteList") parameters:para success:^(id responseObject) {
        NSLog(@"我的收藏responseObject %@",responseObject);
           NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSArray *array = [MyCollecTionGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            for (MyCollecTionGoodInfo *info in array) {
                info.imageLeadCons = 11;
            }
            
              NSInteger totalPage = [responseObject[@"data"][@"totalPage"] integerValue];
            if (totalPage == self.pageNum||array.count < PageSize) {
                self.haveNoMoreData = YES;
                   [self noticeNoMoreData];
            }else{
                self.haveNoMoreData = NO;
            }
            
            if (array.count || self.pageNum != 1) { //第一页有数据或者第二页起进来
               
                [self.goodArray addObjectsFromArray:array];
                self.pageNum ++;
                [self noticeData];
            }else{//提示无数据
                [self noticeBlankView];
            }
            
        }else{//提示无数据
             [self noticeBlankView];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(model:noticeErrorNet:)]) {
            [self.delegate model:self noticeErrorNet:error ];
        }
    }];
}


- (void)deleteAction{
    NSString *skuStr= @"";
    NSMutableArray *skus = @[].mutableCopy;
    for (MyCollecTionGoodInfo *info in self.goodArray) {
        if (info.isSelected) {
            [skus addObject:info.sku];
        }
    }
    if (skus.count == 0) {
        [YJProgressHUD showMsgWithoutView:@"请选择商品"];
        return;
    }
    skuStr = [skus componentsJoinedByString:@","];
    NSDictionary *para = @{@"skus":skuStr,@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/updateFavorite") parameters:para success:^(id responseObject) {
          NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            
            NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.goodArray];
            for (MyCollecTionGoodInfo *info in self.goodArray) {
                if (info.isSelected) {
                    [muArr removeObject:info];
                }
            }
            self.goodArray = muArr;
            if ([self.delegate respondsToSelector:@selector(model:deleteSuc:)]) {
                [self.delegate model:self deleteSuc:responseObject];
            }
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showAlertTipsWithError:error];
        NSLog(@"error %@",error);
        
    }];
}
#pragma mark -  private
- (void)noticeNoMoreData {
    if ([self.delegate respondsToSelector:@selector(noticeNomoreDataWithHomeModel:)]) {
        [self.delegate noticeNomoreDataWithHomeModel:self];
    }
}

- (void)noticeData {
    if ([self.delegate respondsToSelector:@selector(model:querySucWithGood_Artic:)]) {
        [self.delegate model:self querySucWithGood_Artic:self.goodArray];
    }
}

- (void)noticeBlankView{
    if ([self.delegate respondsToSelector:@selector(noticeBlankViewWithModel:)]) {
        [self.delegate noticeBlankViewWithModel:self];
    }
}

@end


@implementation MyCollecTionGoodInfo


@end
