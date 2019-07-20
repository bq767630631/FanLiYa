//
//  PlayVideo_Model.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PlayVideo_Model.h"
#import "UIImage+MZImagepProcessing.h"
@interface PlayVideo_Model ()

@end

@implementation PlayVideo_Model

- (instancetype)init{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}


- (void)queryZBYInfoCallBack:(goodInfoBlock)block{
    if (self.isHaveNomoreData) {
        block(self.goodArr,nil);
        return;
    }
 
    NSDictionary *para = @{@"page":@(self.page),@"token":ToKen};
    NSLog(@"para %@",para);
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/zhiboList") parameters:para success:^(id responseObject) {
          NSLog(@"zby res:%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *listArray = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
           
            NSMutableArray *tempUrlArr = [NSMutableArray array];
            for (SearchResulGoodInfo *info in listArray) {
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
                info.isZby = YES;
                info.sold_num =  info.sold_num.doubleValue ==0?@"20000": info.sold_num;
                float num = info.sold_num.doubleValue /10000;
                info.playNum = [NSString stringWithFormat:@"%.2f万",num];
                [tempUrlArr addObject:[NSURL URLWithString:info.video]];
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
                       
                        //处理第一个商品
                        NSMutableArray *temp  = [NSMutableArray arrayWithArray: self.goodArr];
                        for (SearchResulGoodInfo *info in  self.goodArr) {
                            if ([info.sku isEqualToString:self.firstInfo.sku]) {
//                                NSLog(@"title =%@",info.title);
                                [temp removeObject:info];
                            }
                        }
                        self.goodArr = temp.mutableCopy;
                        [self.goodArr insertObject:self.firstInfo atIndex:0];
                        //处理视频
                        NSMutableArray *tempUrl  = [NSMutableArray array];
                        for (SearchResulGoodInfo *info in  self.goodArr) {
//                            NSLog(@"video =%@",info.video);
                            [tempUrl addObject:[NSURL URLWithString:info.video]];
                        }

                         self.urls = tempUrl;
                    }else{
                        [self.goodArr addObjectsFromArray:listArray];
                        [self.urls addObjectsFromArray:tempUrlArr];
                    }
                    
                    block(listArray,nil);//只返回当前页的数据
                    self.page = currPage;
                }
            }else{ //没数据 空白页
                self.isHaveNomoreData = YES;
                block(@[].mutableCopy,nil);
            }
        }else{
            self.isHaveNomoreData = YES;
            block(@[].mutableCopy,nil);
        }
    } failure:^(NSError *error) {
           block(@[].mutableCopy,error);
        NSLog(@"error =%@",error);
    }];
    
}

+ (void)queryBarragewithsku:(NSString *)sku callBack:(barrageInfoBlock)block{
    NSDictionary *para = @{@"sku":sku, @"token":ToKen};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getGoodsShow") parameters:para success:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
       // NSLog(@"弹幕 %@",responseObject);
        if (code == SucCode) {
            NSMutableArray *list =   [GoodDetailViewInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            block(list,nil);
        }
    } failure:^(NSError *error) {
        block(nil,error);
        NSLog(@"error %@",error);
    }];
}

#pragma getter - getter
- (NSMutableArray *)goodArr{
    if (!_goodArr) {
        _goodArr = [NSMutableArray array];
    }
    return _goodArr;
}

- (NSMutableArray *)urls{
    if (!_urls) {
        _urls = [NSMutableArray array];
    }
    return _urls;
}
@end
