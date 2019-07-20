//
//  ZbySec_Model.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ZbySec_Model.h"
@interface ZbySec_Model ()

@end
@implementation ZbySec_Model
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}


- (void)queryDataWithBlock:(ZbySec_GoodBlock)block{
    if (self.isHaveNomoreData) {
        block(self.goodArr,nil);
        return;
    }
    NSDictionary *para = @{@"page":@(self.page), @"cid":@(self.cid),@"token":ToKen};
    NSLog(@"para %@",para);
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/zhiboList") parameters:para success:^(id responseObject) {
        NSLog(@"zby :%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
             NSArray *listArray = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            for (SearchResulGoodInfo *info in listArray) {
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
                info.isZby = YES;
                info.sold_num =  info.sold_num.doubleValue ==0?@"20000": info.sold_num;
                float num = info.sold_num.doubleValue /10000;
                info.playNum = [NSString stringWithFormat:@"%.2f万",num];
                
            }
            if (listArray.count ||self.page != 1) {
                NSInteger totalPage = [responseObject[@"data"][@"totalpage"] integerValue];
                NSInteger currPage = [responseObject[@"data"][@"page"] integerValue];
            
                if (currPage >= totalPage) { // 当前页数大于等于最大页数 提示没有更多数据
                    self.isHaveNomoreData = YES;
                }else{
                    self.isHaveNomoreData = NO;
                }
                if (listArray.count) { //通知有数据。
                    if (self.page == 1) {
                        self.goodArr = listArray.mutableCopy;
                    }else{
                        [self.goodArr addObjectsFromArray:listArray];
                    }
                }
                block(self.goodArr,nil);
                self.page = currPage;
            }else{ //没数据 空白页
                self.isHaveNomoreData = YES;
                block(@[].mutableCopy,nil);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error =%@",error);
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
