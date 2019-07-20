//
//  PlayVideo_Model.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailModel.h"


typedef void(^goodInfoBlock)(NSMutableArray *goodArr, NSError *error); //goodArr:只是当前页的数据
typedef void(^barrageInfoBlock)(NSMutableArray *barArr, NSError *error);
@interface PlayVideo_Model : NSObject

@property (nonatomic, strong) SearchResulGoodInfo *firstInfo;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isHaveNomoreData;
@property (nonatomic, strong) NSMutableArray *goodArr;//总数据
@property (nonatomic, strong) NSMutableArray *urls;

- (void)queryZBYInfoCallBack:(goodInfoBlock)block;

+ (void)queryBarragewithsku:(NSString*)sku callBack:(barrageInfoBlock)block;
@end



