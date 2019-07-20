//
//  DBZJ_IncomeModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBZJ_Zqy_Info;
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
@property (nonatomic, copy) NSString *kefu_wechat_account; //客服微信号
@property (nonatomic, copy) NSString *next_share_number; //下一级需达到邀请直属人数
@property (nonatomic, copy) NSString *next_relation_number; //下一级需达到邀请关联人数
@property (nonatomic, copy) NSString *next_order_number; //下一级需达到单数
@property (nonatomic, copy) NSString *percent;
//@property (nonatomic, copy) NSString *level; //单前用户的等级

@property (nonatomic, copy) NSString *curStr;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, copy) NSString *totalStr;
@end
