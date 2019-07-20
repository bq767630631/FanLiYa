//
//  MyCombat_Model.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyCombat_Info;
typedef void(^MyCombat_Block)(MyCombat_Info*info, NSError *error);

@interface MyCombat_Model : NSObject
+ (void)queryDataWithBlock:(MyCombat_Block)bock;
@end


@interface MyCombat_Info : NSObject

@property (nonatomic, copy) NSString *wechat_name;
@property (nonatomic, copy) NSString *wechat_image;
@property (nonatomic, copy) NSString *code; //邀请码
@property (nonatomic, assign)  NSString * level; //会员等级1白银2黄金3合伙人
@property (nonatomic, assign)  NSString * url; //二维码地址
@property (nonatomic, copy) NSString* today; //上月结算
@property (nonatomic, copy) NSString *todayorder; //昨日收益
@property (nonatomic, copy) NSString *profit; //累积收益
@property (nonatomic, copy) NSString *month; //本月预估
@property (nonatomic, copy) NSString *monthorder; //今日预估


@end


