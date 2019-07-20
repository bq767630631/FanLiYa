//
//  BillBoard_Model.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomePage_Model.h"

typedef void(^BillBoard_CatBloock)(NSMutableArray*infoArr, NSError*err);
@class BillBoard_CatInfo;

@interface BillBoard_Model : NSObject

@property (nonatomic, assign) BOOL isHaveNomoreData;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *goodArr;

//查询分类
+ (void)queryCateInfoWithBlock:(BillBoard_CatBloock)block;
//查询商品
+ (void)queryGoodRankType:(NSInteger)type cid:(NSInteger)cid WithBlock:(BillBoard_CatBloock)block;

- (void)queryGoodWithRankType:(NSInteger)type cid:(NSInteger)cid WithBlock:(BillBoard_CatBloock)block;
@end


@interface BillBoard_CatInfo : NSObject
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isSelected;
@end
