//
//  GoodDetailModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "SearchResulModel.h"

@protocol GoodDetailModelDelegate;
@class GoodDetailInfo,GoodDetailBannerInfo;
@interface GoodDetailModel : NSObject

- (instancetype)initWithSku:(NSString* )sku;
@property (nonatomic, assign) FLYPT_Type  pt;

@property (nonatomic, weak) id<GoodDetailModelDelegate> delegate;

@property (nonatomic, strong) GoodDetailInfo *detailinfo;

- (void)queryData;
//查询是否收藏
//- (void)queryIsCollection;

- (void)queryViewPeople;

//保存视频和图片到本地相册
+ (void)handleDownloadActionWith:(GoodDetailBannerInfo*)info;

//拼多多优惠券
+ (void)pddGetYouhuiQuanWithsku:(NSString*)sku CallBack:(VEBlock)callBack;

//京东优惠券
+ (void)jdGetYouhuiQuanWithsku:(NSString*)sku couponUrl:(NSString*)couponUrl CallBack:(VEBlock)callBack;
@end


@protocol GoodDetailModelDelegate <NSObject>

- (void)detailModel:(GoodDetailModel*)model querySucWithDetailInfo:(GoodDetailInfo*)info tuiJianArr:(NSMutableArray*)arr;

- (void)detailModel:(GoodDetailModel*)model queryFail:(id)res;


//在购买或者浏览的人数
- (void)detailModel:(GoodDetailModel*)model viewPeople:(NSMutableArray*)arr;

- (void)detailModel:(GoodDetailModel*)model noticeError:(NSError*)error;

- (void)detailModel:(GoodDetailModel*)model  isCollection:(BOOL)isCollection;

@end

@interface GoodDetailInfo : NSObject

@property (nonatomic, copy) NSString *sku;//id
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *detail;//商品详情url
@property (nonatomic, strong) NSArray *content;//商品详情url
@property (nonatomic, copy) NSString *pic;//
@property (nonatomic, copy) NSArray *pics;//多张大图
@property (nonatomic, copy) NSString *market_price;//原价
@property (nonatomic, copy) NSString *price;//折后价
@property (nonatomic, copy) NSString *profit;//购买获得金币
@property (nonatomic, copy) NSString *share_profit;//分享获得金币
@property (nonatomic, copy) NSString *profit_up; //升级赚
@property (nonatomic, copy) NSString *coupon_amount;//优惠券价格
@property (nonatomic, copy) NSString *coupon_start_time;//优惠券开始时间
@property (nonatomic, copy) NSString *coupon_end_time;//优惠券有限期
@property (nonatomic, copy) NSString *coupon_total_count;//优惠券数量
@property (nonatomic, copy) NSString *commission_money;//
@property (nonatomic, copy) NSString *couponUrl;//优惠券链接
@property (nonatomic, copy) NSString *cateid;// 类别ID用于推荐接口的参数
@property (nonatomic, copy) NSString *one_profit; //预估赚
@property (nonatomic, copy) NSString *two_profit; //补贴

@property (nonatomic, copy) NSString *video; //视频地址 为空标识没有视频
@property (nonatomic, assign) NSInteger  is_favorite;
@property (nonatomic, strong) NSMutableArray<SearchResulGoodInfo*> *recommendlist;

@property (nonatomic, copy) NSString *shengji_str;

@property (nonatomic,copy) NSString *sold_num;
@property (nonatomic, copy) NSString *tkl;//淘口令
@property (nonatomic, copy) NSString *code;//邀请码
@property (nonatomic, copy) NSString *shorturl;//下单地址
@property (nonatomic, copy) NSString *downurl;//返利鸭APP下载地址
@property (nonatomic, copy) NSString *shop_title; //店铺标题
@property (nonatomic, copy) NSString *short_title; //短标题
@property (nonatomic, copy) NSString *descScore; //描述分
@property (nonatomic, copy) NSString *shipScore; //服务态度
@property (nonatomic, copy) NSString *serviceScore; //物流服务
@property (nonatomic, copy) NSString *desc; //推荐理由推广文案 //pt
@property (nonatomic, assign) NSInteger  pt;//1天猫4淘宝

@property (nonatomic, copy) NSString *wenAnStr;

@property (nonatomic, assign) CGFloat shareContent_H;//分享内容的高度
@end


@interface GoodDetailBannerInfo : NSObject
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger  url_type;
@property (nonatomic, assign) NSInteger  pt;
@end

@interface GoodDetailViewInfo : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@end
