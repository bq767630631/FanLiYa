//
//  CreateShareContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"
#import "GoodDetailModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface CreateShareContrl : MPZG_BaseContrl

- (instancetype)initWithSku:(NSString *)sku;

@property (nonatomic, assign) FLYPT_Type  pt;
@end

NS_ASSUME_NONNULL_END
