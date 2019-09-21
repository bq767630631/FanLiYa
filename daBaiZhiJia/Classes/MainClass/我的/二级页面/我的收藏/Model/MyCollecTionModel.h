//
//  MyCollecTionModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/15.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyCollecTionGoodInfo;
@protocol MyCollecTionModelDelegate;


NS_ASSUME_NONNULL_BEGIN
@interface MyCollecTionModel : NSObject

@property (nonatomic, weak) id <MyCollecTionModelDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *goodArray;
- (void)queryData;


- (void)deleteAction;
@end

@protocol MyCollecTionModelDelegate <NSObject>
@optional
- (void)model:(MyCollecTionModel *)model querySucWithGood_Artic:(NSArray*)dataSoure ;

- (void)model:(MyCollecTionModel *)model deleteSuc:(id)res;

- (void)noticeNomoreDataWithHomeModel:(MyCollecTionModel *)model;

- (void)noticeBlankViewWithModel:(MyCollecTionModel *)model;

//网络错误
- (void)model:(MyCollecTionModel *)model noticeErrorNet:(NSError*)error;
@end


@interface MyCollecTionGoodInfo : NSObject
/**原价*/
@property (nonatomic,copy ) NSString * _Nullable market_price;
/**现价*/
@property (nonatomic,copy) NSString * _Nullable price;
/**优惠券价*/
@property (nonatomic,copy) NSString * _Nonnull discount;
/**图片地址*/
@property (nonatomic,copy) NSString * _Nullable pic;

/**标题*/
@property (nonatomic,copy) NSString * _Nullable title;
/**商品ID*/
@property (nonatomic,copy) NSString *sku;

/**佣金*/
@property (nonatomic,copy) NSString * _Nullable commission_money;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) NSInteger imageLeadCons;//商品图片距左边的距离 默认11 编辑状态43

@property (nonatomic, assign) NSInteger  pingtai;

@property (nonatomic, assign) BOOL isSelected;
@end


NS_ASSUME_NONNULL_END
