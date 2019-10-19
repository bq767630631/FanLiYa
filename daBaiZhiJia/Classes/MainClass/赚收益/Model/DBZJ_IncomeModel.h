//
//  DBZJ_IncomeModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBZJ_Zqy_Info,DBZJ_RateInfo,DBZJ_Show_Info;
typedef void(^DBZJ_IncomBlock)(DBZJ_Zqy_Info *info, NSError *error, NSInteger code);

@interface DBZJ_IncomeModel : NSObject

+ (void)queryZqyDataWickBlock:(DBZJ_IncomBlock)block;
@end




@interface DBZJ_Zqy_Info : NSObject
@property (nonatomic, copy) NSString *level; //单前用户的等级
@property (nonatomic, copy) NSString *level_name; //单前用户的等级
@property (nonatomic, copy) NSString *wechat_image; //单前用户的头像
@property (nonatomic, copy) NSString *wechat_name; //单前用户的昵称
@property (nonatomic, copy) NSString *share_number; //邀请直属人数
@property (nonatomic, copy) NSString *relation_number; //邀请关联人数
@property (nonatomic, copy) NSString *order_number; //邀请单数
@property (nonatomic, copy) NSString *share_wechat_name; //团长昵称
@property (nonatomic, copy) NSString *share_wechat_account; //团长微信号
@property (nonatomic, copy) NSString *share_wechat_image; //团长头像
@property (nonatomic, copy) NSString *shangji_wechat_name; //上级昵称
@property (nonatomic, copy) NSString *shangji_wechat_account; //上级微信号
@property (nonatomic, copy) NSString *shangji_wechat_image; //上级头像
@property (nonatomic, copy) NSString *kefu_wechat_account; //客服微信号
@property (nonatomic, copy) NSString *next_share_number; //下一级需达到邀请直属人数
@property (nonatomic, copy) NSString *next_relation_number; //下一级需达到邀请关联人数
@property (nonatomic, copy) NSString *next_order_number; //下一级需达到单数
@property (nonatomic, copy) NSString *percent;

@property (nonatomic, strong) DBZJ_Show_Info *show;

@property (nonatomic, copy) NSString *yaoqing;
@property (nonatomic, copy) NSString *tequan;
@property (nonatomic, copy) NSString *moshi;
//@property (nonatomic, copy) NSString *level; //单前用户的等级

@property (nonatomic, copy) NSString *curStr;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, copy) NSString *totalStr;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, copy) NSString *lbStr;
@end

//
@interface DBZJ_Show_Info : NSObject
@property (nonatomic, strong) DBZJ_RateInfo *a;
@property (nonatomic, strong) DBZJ_RateInfo *b;
@property (nonatomic, strong) DBZJ_RateInfo *c;
@property (nonatomic, strong) DBZJ_RateInfo *d;
@property (nonatomic, strong) DBZJ_RateInfo *e;
@property (nonatomic, strong) DBZJ_RateInfo *f;
@end

//收益比例
@interface DBZJ_RateInfo : NSObject
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *c;
@end
