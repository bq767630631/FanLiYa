//
//  Brand_ShowModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Brand_ShowModel.h"
@interface Brand_ShowModel ()
@property (nonatomic, strong) NSMutableArray *goodArr;
@end
@implementation Brand_ShowModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}

- (void)queryDataWithBlcok:(Brand_ShowModel_block)block{
    
    if (self.isHaveNomoreData) {
        block(self.goodArr,nil);
        return;
    }
    NSDictionary *para = @{@"page":@(self.page),@"pagesize":@(10),@"brandcat":self.brandcat,@"token":ToKen};
    NSLog(@"para %@",para);
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/brand") parameters:para success:^(id responseObject) {
        NSLog(@"xianshilist :%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSArray *listArray = [BrandCat_info mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
           
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
                  
                    block(self.goodArr,nil);
                    self.page = currPage;
                }
            }else{ //没数据 空白页
                self.isHaveNomoreData = YES;
                block(@[].mutableCopy,nil);
            }
        }else{
            block(@[].mutableCopy,nil);
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    
    } failure:^(NSError *error) {
        NSLog(@"error =%@",error);
    }];
}

+ (void)quedyBrandDetailBrandId:(NSString*)brandId WickBloc:(Brand_Detailblock)block{
    NSDictionary *para = @{@"id":brandId,@"token":ToKen};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/branddetail") parameters:para success:^(id responseObject) {
        //NSLog(@"branddetail :%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            BrandCat_info *info = [BrandCat_info mj_objectWithKeyValues:responseObject[@"data"]];
            NSMutableArray *list = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            block(info,list,nil);
        }
    } failure:^(NSError *error) {
        block(nil,nil,error);
        NSLog(@"%@",error);
    }];
}

#pragma getter -
- (NSMutableArray *)goodArr{
    if (!_goodArr) {
        _goodArr = [NSMutableArray array];
    }
    return _goodArr;
}
@end
