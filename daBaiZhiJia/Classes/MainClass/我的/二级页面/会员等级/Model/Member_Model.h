//
//  Member_Model.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/1.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Member_LeverSetInfo, Member_CurLeverInfo;

typedef void(^leverSetBlock)(NSMutableArray<Member_LeverSetInfo* >* _Nullable arr, NSError* _Nullable err);
typedef void(^curMemInfoBlock)(Member_CurLeverInfo* _Nullable curInfo, NSError* _Nullable err);

NS_ASSUME_NONNULL_BEGIN
@interface Member_Model : NSObject


+ (void)queryMemSetInfoWithBlock:(leverSetBlock)block;

+ (void)queryMemCurInfoWithBlock:(curMemInfoBlock)block;
@end

/**
 用户等级配置信息
 */
@interface Member_LeverSetInfo : NSObject
@property (nonatomic, assign) NSInteger  level;
@property (nonatomic, copy) NSString *name; //等级名
@property (nonatomic, copy) NSString *share_number;//需要邀请直属人数
@property (nonatomic, copy) NSString *relation_number; //需要邀请关联人数
@property (nonatomic, copy) NSString *order_number;//需要自购有效单数
@property (nonatomic, copy) NSString *percent;// 自购分享返佣百分比
@property (nonatomic, copy) NSString *share_percent; //直属购返佣百分比
@property (nonatomic, copy) NSString *relation_percent; //团队购返佣百分比


@property (nonatomic, copy) NSString *image; //中间的图
@property (nonatomic, assign) BOOL  isCurent;
@end


/**
 当前用户等级和达到参数
 */
@interface Member_CurLeverInfo : NSObject
@property (nonatomic, assign) NSInteger  level; //单前用户的等级标识1普通2中级3高级
@property (nonatomic, copy) NSString *share_number; //邀请直属人数
@property (nonatomic, copy) NSString *relation_number;//邀请关联人数
@property (nonatomic, copy) NSString *order_number; //自购有效单数

@end



NS_ASSUME_NONNULL_END
