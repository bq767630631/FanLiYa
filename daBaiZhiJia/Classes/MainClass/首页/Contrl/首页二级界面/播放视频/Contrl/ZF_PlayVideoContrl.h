//
//  ZF_PlayVideoContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/1.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"
#import "SearchResulModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZF_PlayVideoContrl : MPZG_BaseContrl
- (instancetype)initWithInfo:(SearchResulGoodInfo *)info;
- (void)playTheIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
