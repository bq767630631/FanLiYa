//
//  Goto_LoginContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/24.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"
typedef void(^loginSucBlock)(void);//登录成功


@interface Goto_LoginContrl : MPZG_BaseContrl

@property (nonatomic, copy) loginSucBlock block;

@end


