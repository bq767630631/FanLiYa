//
//  Brand_ShowModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//


#import "HomePage_Model.h"

typedef void(^Brand_ShowModel_block)(NSMutableArray *goodArr, NSError *error);
typedef void(^Brand_Detailblock)(BrandCat_info *info,NSMutableArray *goodArr, NSError *error);
@interface Brand_ShowModel : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *brandcat;
@property (nonatomic, assign) BOOL isHaveNomoreData;

//查询品牌列表
- (void)queryDataWithBlcok:(Brand_ShowModel_block)block;

//查询品牌详情
+ (void)quedyBrandDetailBrandId:(NSString*)brandId WickBloc:(Brand_Detailblock)block;
@end


