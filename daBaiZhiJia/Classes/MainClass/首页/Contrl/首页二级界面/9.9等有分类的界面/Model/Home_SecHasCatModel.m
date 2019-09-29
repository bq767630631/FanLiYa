//
//  Home_SecHasCatModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_SecHasCatModel.h"
#import "NSString+URLErrorString.h"

@implementation Home_SecHasCatModel

+ (instancetype)shareInstance{
   static Home_SecHasCatModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [self allocWithZone:NULL];
    });
    
    return model;
}
+ (void)querySecCateWithType:(SecHasCatType)type Block:(HomePage_ModelBlock)block {
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getListCate") parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
        //NSLog(@"二级分类responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSString *cateStr = [self cateStrWithType:type];
            NSMutableArray *cateArr = [HomePage_CateInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][cateStr]];
            NSMutableArray *titleArr = [NSMutableArray array];
            NSMutableArray *idArrar = [NSMutableArray array];
            for (HomePage_CateInfo *info in cateArr) {
                [titleArr addObject:info.title];
                [idArrar addObject:info.cid];
            }
            block(titleArr,idArrar,nil);
        }else{
            block(nil,nil,nil);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"查询分类error %@",error);
          NSString *errorMsg = [NSString urlErrorMsgWithError:error];
        block(nil,nil,errorMsg);
    }];
}

+ (void)querySecGoodwithType:(SecHasCatType)type page:(NSInteger)page cid:(NSInteger)cid sort:(NSString *)sort block:(Home_SecHaBlock)block{
    NSLog(@"isHaveNomoreData =%d",[Home_SecHasCatModel shareInstance].isHaveNomoreData);
    if ([Home_SecHasCatModel shareInstance].isHaveNomoreData) {
        block([Home_SecHasCatModel shareInstance].goodArr,nil);
        return;
    }
    NSDictionary *dic = @{@"page":@(page),@"cid":@(cid),@"sort":sort, @"token":ToKen,@"v":APP_Version};
    if (type==SecHasCatType_GaoYong||type==SecHasCatType_MuYing ) { //高佣和母婴没有筛选
       dic = @{@"page":@(page),@"cid":@(cid), @"token":ToKen,@"v":APP_Version};
    }else if (type == SecHasCatType_Tehui){ //特惠专区
         dic = @{@"page":@(page), @"token":ToKen,@"v":APP_Version};
    }
    NSLog(@"para =%@",dic);
    NSString *url = [self goodUrlWithType:type];
    
    [PPNetworkHelper POST:URL_Add(url) parameters:dic success:^(id responseObject) {
        NSLog(@"SecGood url=%@ responseObject =%@",url,responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
             NSArray *listArray = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            for (SearchResulGoodInfo *info in listArray) {
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
            }
            if (listArray.count ||page != 1) {
                NSInteger totalPage = 0;
                 totalPage = [responseObject[@"data"][@"totalpage"] integerValue];
                if (type == SecHasCatType_Tehui|| type == SecHasCatType_MuYing||type == SecHasCatType_GaoYong) {
                     totalPage = [responseObject[@"data"][@"totalPage"] integerValue];
                }
                NSInteger currPage = [responseObject[@"data"][@"page"] integerValue];
              
                if (currPage >= totalPage) { // 当前页数大于等于最大页数 提示没有更多数据
                    [Home_SecHasCatModel shareInstance].isHaveNomoreData = YES;
                }else{
                     [Home_SecHasCatModel shareInstance].isHaveNomoreData = NO;
                }
                if (listArray.count) { //通知有数据。
                    if (page == 1) {
                        [Home_SecHasCatModel shareInstance].goodArr = listArray.mutableCopy;
        
                    }else{
                        [[Home_SecHasCatModel shareInstance].goodArr addObjectsFromArray:listArray];
                    }
                    
                      block([Home_SecHasCatModel shareInstance].goodArr,nil);
                      [Home_SecHasCatModel shareInstance].page = currPage;
                }
            }else{ //没数据 空白页
                  [Home_SecHasCatModel shareInstance].isHaveNomoreData = YES;
                  block(@[].mutableCopy,nil);
            }
        }
        
        if (code == NoDataCode) { //暂无数据
            
            block(@[].mutableCopy,nil);
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
         block(@[].mutableCopy,error);
    }];
}

#pragma mark - private
+ (NSString*)cateStrWithType:(SecHasCatType)type{
    NSString *cateStr = @"";
    switch (type) {
        case SecHasCatType_Nine:
            cateStr = @"nine";
            break;
        case SecHasCatType_Brand:
            cateStr = @"brand";
            break;
        case SecHasCatType_BigQuan:
            cateStr = @"big";
            break;
        case SecHasCatType_Zby:
            cateStr = @"live";
            break;
        case SecHasCatType_JHS:
            cateStr = @"juhuasuan";
            break;
        case SecHasCatType_HTG:
            cateStr = @"haitaogou";
            break;
        case SecHasCatType_BrandShow:
            cateStr = @"brandcat";
            break;
        case SecHasCatType_GaoYong:
            cateStr = @"gaoyong";
            break;
        case SecHasCatType_MuYing:
            cateStr = @"muying";
            break;
        default:
            break;
    }
    return cateStr;
}

+ (NSString*)goodUrlWithType:(SecHasCatType)type{
    NSString *url = @"";
    switch (type) {
        case SecHasCatType_Nine:
            url = @"/v.php/goods.goods/getNine";
            break;
        case SecHasCatType_Brand:
            url = @"/v.php/goods.goods/getBrand";
            break;
        case SecHasCatType_BigQuan:
            url = @"/v.php/goods.goods/getDeqList";
            break;
        case SecHasCatType_Zby:
            url = @"live";
            break;
        case SecHasCatType_JHS:
            url = @"/v.php/goods.goods/getJhsList";
            break;
        case SecHasCatType_HTG:
            url = @"/v.php/goods.goods/getTqgList";
            break;
        case SecHasCatType_GaoYong:
            url = @"/v.php/goods.goods/gaoyong";
            break;
        case SecHasCatType_MuYing:
            url = @"/v.php/goods.goods/muying";
            break;
        case SecHasCatType_Tehui:
            url = @"/v.php/goods.goods/tehui";
            break;
        default:
            break;
    }
    return url;
}

- (NSMutableArray *)goodArr{
    if (!_goodArr) {
        _goodArr = [NSMutableArray array];
    }
    return _goodArr;
}

@end
