//
//  LoginContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/2.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"


typedef void(^loginSucBlock)(void);//登录成功
typedef void(^closeBlock)(void); //关闭按钮
@interface LoginContrl : MPZG_BaseContrl


@property (nonatomic, assign) BOOL  isFrom_homePage;//是否来自首页
@property (nonatomic, copy) loginSucBlock block;;

@property (nonatomic, copy) closeBlock closeblock;;
@end


