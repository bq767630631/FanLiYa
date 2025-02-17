//
//  SearchResulModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/4.
//  Copyright © 2019 包强. All rights reserved.
//


////1、天猫 2、京东 3、拼多多 4、淘宝 5、其他
typedef NS_ENUM(NSInteger, FLYPT_Type) {
    FLYPT_Type_TM = 1,
    FLYPT_Type_JD  ,
    FLYPT_Type_Pdd ,
    FLYPT_Type_TB  ,
};


NS_ASSUME_NONNULL_BEGIN

@interface SearchResulModel : NSObject

@end

NS_ASSUME_NONNULL_END


@interface SearchResulGoodInfo : NSObject
/**原价*/
@property (nonatomic,copy) NSString *market_price;
/**现价*/
@property (nonatomic,copy) NSString *price;
/**优惠券价*/
@property (nonatomic,copy) NSString *discount;
/**图片地址*/
@property (nonatomic,copy) NSString *pic;

@property (nonatomic,strong) NSMutableArray *pics;
/**图片地址*/
@property (nonatomic,copy) NSString *img;

@property (nonatomic,assign) BOOL isTuiJianGood;//是否是推荐商品
/**标题*/
@property (nonatomic,copy) NSString *title;
/**商品ID*/
@property (nonatomic,copy) NSString *sku;
/**销量*/
@property (nonatomic,copy) NSString *sold_num;

/**收益*/
@property (nonatomic,copy) NSString *profit;

@property (nonatomic,copy) NSString *profit_up; //升级收益

@property (nonatomic,copy) NSString *shengji_str; //是升级赚还是自购省

@property (nonatomic, assign) NSInteger  pt;//1、天猫 2、京东 3、拼多多 4、淘宝 5、其他

@property (nonatomic,copy) NSString *video; //视频地址 为空时没视频

@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, assign) NSInteger  rankType;//榜单查询排行 1.实时销量榜 2.全天销量榜 3.热推榜

//淘礼金相关
@property (nonatomic,copy) NSString *tlj; //淘礼金金额不等于0.00的时候为存在
@property (nonatomic,copy) NSString *url; //点击立即购买需要打开的手淘地址
@property (nonatomic,copy) NSString *tlj_number; //淘礼金数量

@property (nonatomic, assign) BOOL isZby; //是否是直播鸭  只有直播鸭才显示播放量

@property (nonatomic, copy) NSString *playNum;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL  playBtn_ishidden;

@property (nonatomic, copy) NSString *des;//推荐文案
@property (nonatomic, copy) NSString *content;//文案内容 -首页社区推荐
@property (nonatomic, copy) NSString *time;//时间 -首页社区推荐

@property (nonatomic, assign) BOOL  is_From_page;//是否是来自pagevc
@property (nonatomic, assign) BOOL  is_From_cate; //是否是来自分类
@property (nonatomic, assign) BOOL  is_Cate_Sec;//是否是分类的二级界面
@property (nonatomic, assign) BOOL  is_From_PddOrJd; //拼多多和京东的首页界面
@property (nonatomic, assign) NSInteger countTime;//新手活动倒计时时间

//社群推荐
@property (nonatomic, assign) CGFloat collection_height;
@property (nonatomic, assign) CGFloat collection_width;
@end
