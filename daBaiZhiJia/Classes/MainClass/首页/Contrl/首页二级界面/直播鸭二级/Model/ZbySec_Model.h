//
//  ZbySec_Model.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomePage_Model.h"
#import "GoodDetailModel.h"

typedef void(^ZbySec_GoodBlock)(NSMutableArray *goodArr, NSError *error);
typedef void(^detailInfoBlock)(SearchResulGoodInfo*info, NSError *error);
@interface ZbySec_Model : NSObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy)  NSString *sku;
@property (nonatomic, assign) BOOL isHaveNomoreData;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *goodArr;
//查询直播的商品
- (void)queryDataWithBlock:(ZbySec_GoodBlock)block;

@end


