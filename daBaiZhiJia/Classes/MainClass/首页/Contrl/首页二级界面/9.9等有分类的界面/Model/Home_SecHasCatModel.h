//
//  Home_SecHasCatModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomePage_Model.h"

typedef NS_ENUM(NSInteger, SecHasCatType) {
    SecHasCatType_Nine = 0, //9块9类目
    SecHasCatType_Brand ,  //品牌类目
    SecHasCatType_BigQuan , //大额券类目
    SecHasCatType_Zby ,   //直播鸭类目
    SecHasCatType_JHS , //聚划算类目
    SecHasCatType_HTG ,  //海淘购类目
    SecHasCatType_BrandShow ,  //品牌展示
    SecHasCatType_GaoYong,   //高佣推荐
    SecHasCatType_MuYing,  //母婴类目
    SecHasCatType_Tehui,  //特惠专区
};

typedef void(^Home_SecHaBlock)(NSMutableArray *goodArr,NSError *error);
@interface Home_SecHasCatModel : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) NSMutableArray *goodArr;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL isHaveNomoreData;

//查询二级分类
+ (void)querySecCateWithType:(SecHasCatType)type Block:(HomePage_ModelBlock)block ;

+ (void)querySecGoodwithType:(SecHasCatType)type page:(NSInteger)page cid:(NSInteger)cid sort:(NSString*)sort block:(Home_SecHaBlock)block;


@end


