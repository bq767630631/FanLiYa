//
//  DBZJ_CommunityModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/16.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CommunityRecommendInfo;
@protocol DBZJ_CommunityModelDelegate;
@interface DBZJ_CommunityModel : NSObject
@property (nonatomic, weak) id<DBZJ_CommunityModelDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *RecomArr;

@property (nonatomic, strong) NSMutableArray *MarketArr;

@property (nonatomic, strong) NSMutableArray *NewHandArr;//新手必备

@property (nonatomic, copy) NSString *logo1;
@property (nonatomic, copy) NSString *logo2;
@property (nonatomic, copy) NSString *logo3;
@property (nonatomic, assign) NSInteger pageNum_Rec;
@property (nonatomic, assign) NSInteger pageNum_Marketing;//营销素材
@property (nonatomic, assign) NSInteger pageNum_NewHand;

@property (nonatomic, assign) BOOL haveNoMoreData_Rec;
@property (nonatomic, assign) BOOL haveNoMoreData_Marketing;
@property (nonatomic, assign) BOOL haveNoMoreData_NewHand;

- (void)queryRecommendWithType:(NSInteger)type;

//是否显示空白页
- (BOOL)showblankViewWithType:(NSInteger)type;
@end


@protocol DBZJ_CommunityModelDelegate <NSObject>
@optional
- (void)communityModel:(DBZJ_CommunityModel*)model dataSouse:(NSArray*)dataArr type:(NSInteger)type logo:(NSString*)logo;

- (void)noticeNomoreDataWithCommunityModel:(DBZJ_CommunityModel *)model type:(NSInteger)type;

- (void)noticeBlankViewWithModel:(DBZJ_CommunityModel *)model type:(NSInteger)type;
@end


@interface  CommunityRecommendInfo : NSObject
@property (nonatomic, assign) NSInteger pt;
@property (nonatomic, copy) NSString *itemtitle;
@property (nonatomic, copy) NSString *sku;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *number; //分享次数
@property (nonatomic, copy) NSString *profit;
@property (nonatomic, strong) NSArray *pics;  //图片地址 数组
@property (nonatomic, copy) NSString *live_url; //视频地址
@property (nonatomic, copy) NSString *live_pic; //视频默认图片


@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGFloat collection_height;
@property (nonatomic, assign) CGFloat collection_width;
@property (nonatomic, assign) CGFloat item_height;
@property (nonatomic, assign) CGFloat item_width;
@property (nonatomic, assign) NSInteger type; //1新品推荐 2营销素材
@end


NS_ASSUME_NONNULL_END
