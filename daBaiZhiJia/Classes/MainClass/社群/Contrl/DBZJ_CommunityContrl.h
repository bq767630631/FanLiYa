//
//  DBZJ_CommunityContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBZJ_CommunityContrl : MPZG_BaseContrl

@property (nonatomic, assign) BOOL  jumpToSucai;//跳转至素材专区
//设置 菜单的选项
- (void)setMenuSelected:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
