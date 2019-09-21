//
//  PingDuoduoHomeModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomePage_Model.h"



@interface PingDuoduoHomeModel : NSObject

//查询banner
+ (void)queryBannerWithpt:(FLYPT_Type)pt  Block:(PPHttpRequestCallBack)callBack;

//查询分类
+ (void)queryCateInfoWithpt:(FLYPT_Type)pt Block:(HomePage_ModelBlock)block;
@end


