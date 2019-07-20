//
//  HomePage_Model.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/12.
//  Copyright © 2019 包强. All rights reserved.
//

#import "SearchResulModel.h"

@class HomePage_CateInfo,HomePage_bg_bannernfo,HomePage_BroadCastInfo;
@class HomePage_FlashSaleInfo,BrandCat_info;
typedef void(^HomePage_ModelBlock)(NSMutableArray*cateTitleArr, NSMutableArray*cateIdArr, NSString*msg);

typedef void(^hm_bg_bannerBlock)(NSMutableArray<NSString*>*bg_bannerArr,NSMutableArray<HomePage_bg_bannernfo*>*bannerArr ,NSError *error);

typedef void(^broadCast_Block)(BOOL is_showNew,NSMutableArray*broads,NSError *error);

typedef void(^midadver_Block)(NSMutableArray*adArr, NSError *error);

typedef void(^zbyGoods_Block)(NSMutableArray*goodArr,NSError *error);

typedef void(^flashSale_Block)(NSMutableArray*timeArr,NSMutableArray*goodArr,NSInteger timeDiff,NSError *error);

typedef void(^everyDayGood_Block)(NSMutableArray*goodArr,BOOL haveNomoreData, NSError *error);
typedef void(^tmUrl_Block)(NSString *tmCS,NSString *tmGJ);

@interface HomePage_Model : NSObject

//查询版本号
+ (void)queryVerson:(void (^)(void))callBlock;

//查询品牌类别
+ (void)queryBrandinfoArrWithBlock:(zbyGoods_Block)block;

//查询分类
 + (void)queryCateInfoWithBlock:(HomePage_ModelBlock)block;
//查询banner
+ (void)queryHomeBannerImagesBlcok:(hm_bg_bannerBlock)block;

//查询播报
+ (void)queryBroadCastWithBlock:(broadCast_Block)block;
//查询中间广告位
+ (void)queryMiddleAdverseWithBlock:(midadver_Block)block;
//查询直播鸭商品
+ (void)queryZbyGoodWithBlock:(zbyGoods_Block)block;
//查询限时购
+ (void)queryFlashSaleWithBlock:(flashSale_Block)block;

//查询天猫超市和天猫国际url
+ (void)queryTianMaoUrlWithBlock:(tmUrl_Block)block;
////查询每日精选
//+ (void)queryEveryGoodWithBlock:(everyDayGood_Block)block page:(NSInteger)page haveNoMoreData:(BOOL)haveNoMoreData ;
@end



@interface HomePage_CateInfo : NSObject
@property (nonatomic, copy) NSString *cid; //类别ID
@property (nonatomic, copy) NSString *title; //类别名
@end

@interface HomePage_bg_bannernfo : NSObject
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger  url_type;//1、单品详情；2、内部H5页面；3、淘宝H5页面；4、跳转打开手淘页
@property (nonatomic, copy) NSString *type;//广告位置：1上2中左3中右4下
@end

@interface HomePage_BroadCastInfo : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *price;

@property (nonatomic, strong) NSMutableAttributedString *attStr;
@end


@interface HomePage_FlashSaleInfo : NSObject
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *time_;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) BOOL  isSelected;
@end

@interface Version_info : NSObject
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *show;
@end

@interface BrandCat_info : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo; //图片
@property (nonatomic, copy) NSString *brandcat; //品牌分类
@property (nonatomic, copy) NSString *brandid; //品牌分类id
@property (nonatomic, copy) NSString *introduce; //品牌简介
@end
