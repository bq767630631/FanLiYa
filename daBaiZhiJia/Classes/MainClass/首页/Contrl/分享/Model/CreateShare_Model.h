//
//  CreateShare_Model.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/3.
//  Copyright © 2019 包强. All rights reserved.
//


#import "GoodDetailModel.h"

typedef void(^detailInfo_Block)(GoodDetailInfo *info, NSError *error);
typedef void(^tklBlock)(NSString*tkl, NSString*code,NSString*shorturl);

@interface CreateShare_Model : NSObject

//查询商品详情(有的地方没有商品详情)
+ (void)queryDetailInfoWithSku:(NSString *)sku  pt:(FLYPT_Type)pt Blcok:(detailInfo_Block)block;

+ (NSString*)geneRateWenanWithDetail:(GoodDetailInfo*)info isAdd:(BOOL)isAdd isDown:(BOOL)isDown isRegisCode:(BOOL)isRegisCode isTkl:(BOOL)isTkl pt:(FLYPT_Type)pt;
//生成淘口令
+ (void)geneRateTaoKlWithSku:(NSString*)sku  vc:(UIViewController*)curVc navi_vc:(UINavigationController*)navi_vc  block:(tklBlock)block;

//查询d拼多多京东优惠券
+(void)pddAndJdGetYouhuiQuanWithsku:(NSString*)sku pt:(FLYPT_Type)pt  couponUrl:(NSString*)couponUrl CallBack:(VEBlock)callBack;
@end


@interface CreateShare_CellInfo : NSObject
@property (nonatomic, copy) NSString *imageStr; // 图片url
@property (nonatomic, assign) BOOL  isSelected; //是否选中
@property (nonatomic, assign) BOOL  isPoster; //是否是海报
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray *pics; //图片数组
@end
