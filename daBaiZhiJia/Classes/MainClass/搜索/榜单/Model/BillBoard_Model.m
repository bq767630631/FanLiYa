//
//  BillBoard_Model.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "BillBoard_Model.h"

@implementation BillBoard_Model
- (instancetype)init{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}


+ (void)queryCateInfoWithBlock:(BillBoard_CatBloock)block{
    [PPNetworkHelper GET:URL_Add(@"/v.php/goods.goods/getRankCate") parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
       // NSLog(@"分类responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *cateArr = [BillBoard_CatInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            BillBoard_CatInfo *info = [BillBoard_CatInfo new];
            info.cid = 0;
            info.title = @"全部";
            info.isSelected = YES;
            [cateArr insertObject:info atIndex:0];
            block(cateArr,nil);
        }else{
            block(nil,nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"查询分类error %@",error);
        block(nil,nil);
    }];
}

+ (void)queryGoodRankType:(NSInteger)type cid:(NSInteger)cid WithBlock:(BillBoard_CatBloock)block{
    NSDictionary *dic = @{@"rankType":@(type),@"cid":@(cid),@"token":ToKen,@"v":APP_Version};
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getRankList") parameters:dic success:^(id responseObject) {
        // NSLog(@"getRankListresponseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
             NSMutableArray *goodArr = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            for (SearchResulGoodInfo *info in goodArr) {
                info.rankType = type;
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
            }
            
            block(goodArr,nil);
        }
    } failure:^(NSError *error) {
         block(nil,error);
    }];
}

- (void)queryGoodWithRankType:(NSInteger)type cid:(NSInteger)cid WithBlock:(BillBoard_CatBloock)block{
    if (self.isHaveNomoreData) {
        block(self.goodArr,nil);
        return;
    }
       NSDictionary *dic = @{@"rankType":@(type),@"cid":@(cid),@"page":@(self.page), @"token":ToKen,@"v":APP_Version};
    NSLog(@"dict =%@",dic);
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getRankListNew") parameters:dic success:^(id responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *listArray = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
             NSLog(@"getRankListNew =%@",responseObject);
            for (SearchResulGoodInfo *info in listArray) {
                info.rankType = type;
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
            }
            
            if (listArray.count ||self.page != 1) {
                NSInteger totalPage = [responseObject[@"data"][@"totalpage"] integerValue];
                NSInteger currPage = [responseObject[@"data"][@"page"] integerValue];
                
                if (listArray.count) { //通知有数据。
                    if (self.page == 1) {
                        self.goodArr = listArray.mutableCopy;
                    }else{
                        [self.goodArr addObjectsFromArray:listArray];
                    }
                }
                block(self.goodArr,nil);
                self.page = currPage;
                if (currPage >= totalPage) { // 当前页数大于等于最大页数 提示没有更多数据
                    self.isHaveNomoreData = YES;
                }else{
                    self.isHaveNomoreData = NO;
                }
            }else{
                
                self.isHaveNomoreData = YES;
                block(@[].mutableCopy,nil);
            }

        }
    } failure:^(NSError *error) {
        block(nil,error);
    }];
}

#pragma getter - getter
- (NSMutableArray *)goodArr{
    if (!_goodArr) {
        _goodArr = [NSMutableArray array];
    }
    return _goodArr;
}

@end


@implementation BillBoard_CatInfo



@end
