//
//  GoodDetailModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailModel.h"

@interface GoodDetailModel ()
@property (nonatomic, copy) NSString *sku;

@property (nonatomic, strong) NSMutableArray *tuiJianArr;

@property (nonatomic, copy) NSString *videoUrl;
@end
@implementation GoodDetailModel

- (instancetype)initWithSku:(NSString*)sku{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.sku = sku;
    return self;
}


- (void)queryData{
      
    NSDictionary *dic = @{@"sku":self.sku, @"token":ToKen};
    NSLog(@"para:%@",dic);
       //商品详情
     @weakify(self);
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getGoodsDetailNew") parameters:dic success:^(id responseObject) {
         @strongify(self);
//       NSLog(@"详情responseObject  %@",responseObject);
        NSLog(@"详情请求完毕");
         NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {  //
           GoodDetailInfo *info = [GoodDetailInfo mj_objectWithKeyValues:responseObject[@"data"]];
            info.price = [NSString stringRoundingTwoDigitWithNumber:info.price.doubleValue];
            info.market_price = [NSString stringRoundingTwoDigitWithNumber:info.market_price.doubleValue];
            info.profit = [NSString stringRoundingTwoDigitWithNumber:info.profit.doubleValue];
            info.share_profit = [NSString stringRoundingTwoDigitWithNumber:info.share_profit.doubleValue];

//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
//            NSDate *startDate =  [dateFormatter dateFromString:info.coupon_start_time];
//            info.coupon_start_time = [dateFormatter stringFromDate:startDate];
//            NSDate *endDate =  [dateFormatter dateFromString:info.coupon_end_time];
//            info.coupon_end_time = [dateFormatter stringFromDate:endDate];
           
             self.detailinfo = info;
            [self queryTuiJianGood];
        }

    } failure:^(NSError *error) {
        NSLog(@"error  %@",error);
        if ([self.delegate respondsToSelector:@selector(detailModel:noticeError:)]) {
            [self.delegate detailModel:self noticeError:error];
        }
    }];
    
}

- (void)queryTuiJianGood{
    NSDictionary *dic = @{@"cateid":self.detailinfo.cateid, @"token":ToKen};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getGoodsTuijianNew") parameters:dic success:^(id responseObject) {
        
        // NSLog(@"推荐商品responseObject  %@",responseObject);
         NSLog(@"推荐商品请求完毕");
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            self.tuiJianArr =  [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            if ([self.delegate respondsToSelector:@selector(detailModel:querySucWithDetailInfo:tuiJianArr:)]) {
                [self.delegate detailModel:self querySucWithDetailInfo:self.detailinfo tuiJianArr: self.tuiJianArr];
            }
        }
        
    } failure:^(NSError *error) {
        
        //NSLog(@"推荐商品 error  %@",error);
        if ([self.delegate respondsToSelector:@selector(detailModel:noticeError:)]) {
            [self.delegate detailModel:self noticeError:error];
        }
    }];
}


- (void)queryViewPeople{
    NSDictionary *para = @{@"sku":self.sku, @"token":ToKen};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getGoodsShow") parameters:para success:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
//        NSLog(@"弹幕 %@",responseObject);
        if (code == SucCode) {
            NSMutableArray *list =   [GoodDetailViewInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSMutableArray *temp = [NSMutableArray array];
            for (GoodDetailViewInfo *info in list) {
                NSString *str = [NSString stringWithFormat:@"%@  %@",info.name, info.title];
                [temp addObject:str];
            }
            [self.delegate detailModel:self viewPeople:temp];
        }
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}


@end


@implementation GoodDetailInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"recommendlist":[SearchResulGoodInfo class]};
}

@end

@implementation GoodDetailBannerInfo


@end
@implementation GoodDetailViewInfo



@end
