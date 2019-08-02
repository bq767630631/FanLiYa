//
//  PrersonInfoModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PrersonInfoMsg,PersonRevenue;
typedef void(^prersonInfoBlock)(PrersonInfoMsg* info);

typedef void(^prersonRevenueBlock)(PersonRevenue*  reve, NSInteger code);


@interface PrersonInfoModel : NSObject

//查询个人信息
+(void)queryPersonWithBlock:(prersonInfoBlock)block;
//修改图片
+ (void)modifyHeadImageWithimage:(UIImage *)image;
//淘宝用户授权绑定 (void (^)(void))
+ (void)taobaoAuthBindWithOpenId:(NSString*)openId callBack:(void (^)(BOOL))block;

+ (void)queryTaboBaoAuthUrlWithCallBack:(void (^)(NSString*url))block;
//查询个人收益
+ (void)queryPersonRevenueWithBlcok:(prersonRevenueBlock)block;
/**
 个人中心-中间广告位
 */
+ (void)queryMyMidddleWithblock:(PPHttpRequestCallBack)callBack;
@end

@interface PrersonInfoMsg : NSObject
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *wechat_name;
@property (nonatomic, copy) NSString *wechat_account;
@property (nonatomic, copy) NSString *wechat_image;
@property (nonatomic, copy) NSString *code; //邀请码
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger level; //会员等级1白银2黄金3合伙人
@property (nonatomic, assign) NSInteger relation_id; //是否授权绑定过淘宝账号0否 不为0绑定过
@end

//个人收益
@interface PersonRevenue : NSObject

@property (nonatomic, copy) NSString *wechat_name;
@property (nonatomic, copy) NSString *wechat_image;
@property (nonatomic, copy) NSString *openid;//是否绑定过微信不为空绑定过，为空的时候没绑定过
@property (nonatomic, copy) NSString *code; //邀请码
@property (nonatomic, copy)  NSString * level; //会员等级1白银2黄金3合伙人
@property (nonatomic, assign)  NSInteger level_;
@property (nonatomic, copy) NSString* lastmonth_profit; //上月结算
@property (nonatomic, copy) NSString *yesterday_profit; //昨日收益
@property (nonatomic, copy) NSString *lastmonth_profit_yugu; //上月预估
@property (nonatomic, copy) NSString *month_profit; //本月预估
@property (nonatomic, copy) NSString *today_profit; //今日预估
@property (nonatomic, copy) NSString *drawcash; //累积提现金额
@end

@interface PersonMiddAdvInfo : NSObject
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *url;
@end

