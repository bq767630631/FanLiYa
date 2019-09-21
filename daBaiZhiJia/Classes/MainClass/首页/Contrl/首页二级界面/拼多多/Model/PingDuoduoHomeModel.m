//
//  PingDuoduoHomeModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PingDuoduoHomeModel.h"

@implementation PingDuoduoHomeModel
+ (void)queryBannerWithpt:(FLYPT_Type)pt Block:(PPHttpRequestCallBack)callBack{
    NSString *url = pt == FLYPT_Type_Pdd ?@"/v.php/goods.pdd/getAppBanner":@"/v.php/goods.jd/getAppBanner";
    [PPNetworkHelper GET:URL_Add(url) parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
          NSLog(@"banner %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *InfoArr = [HomePage_bg_bannernfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            callBack(InfoArr,nil);
        }
    } failure:^(NSError *error) {
          callBack(nil,error);
    }];
}

+ (void)queryCateInfoWithpt:(FLYPT_Type)pt Block:(HomePage_ModelBlock)block{
     NSString *url = pt == FLYPT_Type_Pdd ?@"/v.php/goods.pdd/getCateList":@"/v.php/goods.jd/getCateList";
    
    [PPNetworkHelper GET:URL_Add(url) parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
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
                        block(nil,nil,responseObject[@"msg"]);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"查询分类error %@",error);
        NSString *errorMsg = [NSString urlErrorMsgWithError:error];
        block(nil,nil,errorMsg);
    }];
}
@end
