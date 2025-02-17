//
//  HomePage_Model.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/12.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomePage_Model.h"

@implementation HomePage_Model
+ (void)queryVerson:(void (^)(void))callBlock{
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getAppShow") parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
         //NSLog(@"responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *cur_ver = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
       // NSLog(@"app_Version =%@",cur_ver);
        if (code == SucCode) {
            NSMutableArray *arr = [Version_info mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            BOOL isShow = YES;
            for (Version_info *info in arr) {
                if ([info.version isEqualToString:cur_ver] ) {//正在审核的版本
                    isShow = [info.show isEqualToString:@"1"]?YES:NO;
//                    NSLog(@"正在审核的版本");
                }
            }
           
            [[NSUserDefaults standardUserDefaults] setBool:isShow forKey:IsShow_InfoKey];
            
            BOOL is_update= [responseObject[@"data"][@"is_update"] boolValue];
            NSLog(@"is_update %d", is_update);
            [[NSUserDefaults standardUserDefaults] setBool:is_update forKey:is_Force_UpdateKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            callBlock();
        }
       
    } failure:^(NSError *error) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsShow_InfoKey];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:is_Force_UpdateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
          callBlock();
        NSLog(@"%@",error);
    }];
}

+ (void)queryBrandinfoArrWithBlock:(zbyGoods_Block)block{
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/brand") parameters:@{@"pagesize":@(3),@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
         // NSLog(@"Brandinfo responseObject =%@",responseObject);
          NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *list = [BrandCat_info mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            block(list,nil);
        }
    } failure:^(NSError *error) {
        block(nil,error);
        NSLog(@"%@",error);
    }];
}

+ (void)queryCateInfoWithBlock:(HomePage_ModelBlock)block{
    
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getCateList") parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
       // NSLog(@"分类 %@",responseObject);
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
          NSMutableArray *cateArr = [HomePage_CateInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSMutableArray *titleArr = [NSMutableArray array];
             NSMutableArray *idArrar = [NSMutableArray array];
            for (HomePage_CateInfo *info in cateArr) {
                [titleArr addObject:info.title];
                [idArrar addObject:info.cid];
            }
            if (!Is_Show_Info) {
                titleArr = @[@"精选"].mutableCopy;
                idArrar = @[@(1)].mutableCopy;
            }
            block(titleArr,idArrar,nil);
        }else{
//            block(nil,nil,responseObject[@"msg"]);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"查询分类error %@",error);
         NSString *errorMsg = [NSString urlErrorMsgWithError:error];
        block(nil,nil,errorMsg);
    }];
}

+ (void)queryHomeBannerImagesBlcok:(hm_bg_bannerBlock)block{

    NSDictionary *dict = @{@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getAppBanner") parameters:dict success:^(id responseObject) {
        NSLog(@"queryHomeBanner");
        //NSLog(@"queryHomeBanner %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *bannerInfoArr = [HomePage_bg_bannernfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
               NSMutableArray *bg_bannerArr = [NSMutableArray array];
            for (HomePage_bg_bannernfo*info in bannerInfoArr) {
                [bg_bannerArr addObject:info.color];
            }
            block(bg_bannerArr,bannerInfoArr,nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
        block(nil,nil,error);
    }];
}

+ (void)queryBroadCastWithBlock:(broadCast_Block)block{
      NSDictionary *dict = @{@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/index.index/bobao") parameters:dict success:^(id responseObject) {
        NSLog(@"queryBroadCast");
       // NSLog(@"BroadCast responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            BOOL  is_show = [responseObject[@"data"][@"is_show"] boolValue];

            NSMutableArray *arr = [HomePage_BroadCastInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"bobao"]];
            block(is_show,arr,nil);
        }
    } failure:^(NSError *error) {
         NSLog(@"error =%@",error);
         block(NO,nil,error);
    }];
}


+ (void)queryMiddleAdverseWithBlock:(midadver_Block)block{
      NSDictionary *dict = @{@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getAppBannerSide") parameters:dict success:^(id responseObject) {
//        NSLog(@"queryMiddleAdverse");
         //NSLog(@"MiddleAdverse responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
             NSMutableArray *InfoArr = [HomePage_bg_bannernfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            block(InfoArr,nil);
        }
    } failure:^(NSError *error) {
         NSLog(@"error =%@",error);
        block(nil,error);
    }];
    
}

+ (void)queryZbyGoodWithBlock:(zbyGoods_Block)block{
    NSDictionary *dict = @{@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/zhiboList") parameters:dict success:^(id responseObject) {
        NSLog(@"queryZbyGood");
       // NSLog(@"ZbyGood responseObject =%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *goodArr = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            for (SearchResulGoodInfo *info in goodArr) {
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
                info.sold_num =  info.sold_num.doubleValue ==0?@"20000": info.sold_num;
                float num = info.sold_num.doubleValue /10000;
                info.playNum = [NSString stringWithFormat:@"%.2f万",num];
            }
            
            block(goodArr,nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"error =%@",error);
         block(nil,error);
    }];
}


+ (void)queryFlashSaleWithBlock:(flashSale_Block)block{
       NSDictionary *dict = @{@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/index.index/xianshi") parameters:dict success:^(id responseObject) {
       
        // NSLog(@"FlashSale responseObject =%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *timeArr = [HomePage_FlashSaleInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"time"]];
             NSMutableArray *goodArr = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            for (SearchResulGoodInfo *info in goodArr) {
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
            }
            NSInteger timedif = [responseObject[@"data"][@"end"] integerValue];
            block(timeArr,goodArr,timedif,nil);
        }
    } failure:^(NSError *error) {
          block(nil,nil,0,error);
    }];
}

+ (void)queryTianMaoUrlWithBlock:(tmUrl_Block)block{
  
    [PPNetworkHelper POST:URL_Add(@"/v.php/index.index/getTMurl") parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
//          NSLog(@"queryTianMaoUrl");
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
             NSString *str1 = responseObject[@"data"][@"tiaomaochaoshi"];
             NSString *str2 = responseObject[@"data"][@"tiaomaoguoji"];
            block(str1,str2);
        }
    } failure:^(NSError *error) {
        block(nil,nil);
    }];
}

+ (void)queryAppTopSideWithBlock:(PPHttpRequestCallBack)block{
    NSDictionary *dict = @{@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getAppTopSide") parameters:dict success:^(id responseObject) {
        //NSLog(@"getAppTopSide responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *InfoArr = [HomePage_bg_bannernfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            block(InfoArr.firstObject,nil);
        }else{
            block(nil,nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"error =%@",error);
        block(nil,error);
    }];
}

+ (void)queryAppSoreInfoWithCallBack:(VEBlockInteger)callBack{
  //  NSString *url = @"http://itunes.apple.com/cn/lookup?id=1459203610";
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getAppVersion") parameters:@{@"token":ToKen,@"v":APP_Version,@"type":@"ios"} success:^(id responseObject) {
      //  NSLog(@"getAppVersion %@",responseObject);
        NSString *cur_v = [UIApplication sharedApplication].appVersion;
           NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
              NSString *storeVerson = responseObject[@"data"][@"note"];
            NSLog(@"storeVerson %@",storeVerson);
            NSLog(@"cur_v %@",cur_v);
            NSInteger isShowUpDate = 0;
            if (Is_Show_Info && ![cur_v isEqualToString:storeVerson]) {//非审核状态并且当地版本和线上版本不一样
                isShowUpDate = 1;
            }
            NSLog(@"isShowUpDate %zd",isShowUpDate);
            callBack(isShowUpDate);
        }else{
            callBack(0);
        }
       
    } failure:^(NSError *error) {
        callBack(0);
        NSLog(@"%@",error);
    }];
}

+ (void)queryMenuSceneWithBlock:(menuSceneceCallBack)callBack{
    
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getMenuScene") parameters:nil success:^(id responseObject) {
       // NSLog(@"getMenuScene %@",responseObject);
          NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSString *pic = responseObject[@"data"][@"picurl"];
            NSMutableArray *list = [MenuSceneceInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
           CGFloat scale = [UIScreen mainScreen].scale;
            
            for (MenuSceneceInfo *info in list) {
                info.imageUrl = [NSString stringWithFormat:@"%@%@_ios@%.fx.png",pic,info.id_,scale];
            }
             callBack(list,nil);
        }else{
            callBack(nil,nil);
        }
    } failure:^(NSError *error) {
        callBack(nil,error);
    }];
}

#pragma mark - private

+ (NSMutableAttributedString*)broadCast_AttrStrWithStr1:(NSString*)str1 str2:(NSString*)str2 str3:(NSString*)str3{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",str1,str2,str3]];
    [str setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12.f], NSForegroundColorAttributeName:RGBColor(175, 134, 72)} range:NSMakeRange(str1.length + str2.length, str3.length)];
    
    return str;
}
@end

@implementation HomePage_CateInfo
@end

@implementation HomePage_bg_bannernfo
@end

@implementation HomePage_BroadCastInfo
@end

@implementation HomePage_FlashSaleInfo
@end

@implementation Version_info
@end


@implementation BrandCat_info
@end

@implementation MenuSceneceInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"id_":@"id"};
}
@end
