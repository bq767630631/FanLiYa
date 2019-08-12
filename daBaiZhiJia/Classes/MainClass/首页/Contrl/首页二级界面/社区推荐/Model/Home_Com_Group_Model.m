//
//  Home_Com_Group_Model.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/24.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_Com_Group_Model.h"
@interface Home_Com_Group_Model ()
@property (nonatomic, strong) NSMutableArray *goodArr;
@property (nonatomic, copy) NSString *imageStr;
@end
@implementation Home_Com_Group_Model
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}

- (void)queryDataWithBlock:(Home_Com_Group_block)block{
    if (self.isHaveNomoreData) {
        block(self.goodArr,self.imageStr,nil);
        return;
    }
    NSDictionary *para = @{@"page":@(self.page), @"token":ToKen,@"v":APP_Version};
  //  NSLog(@"para %@",para);
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.share/getShequList") parameters:para success:^(id responseObject) {
        //NSLog(@"社群推荐 :%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            self.imageStr = responseObject[@"data"][@"logo"];
            NSArray *listArray = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            CGFloat wd = 90;
            CGFloat gap = 5;
            for (SearchResulGoodInfo *info in listArray) {
                info.shengji_str = (info.profit == info.profit_up)?@"自购省":@"升级赚";
                info.pic = info.pics.firstObject;
                info.collection_width = wd*3 + gap*2;
                if (info.pics.count ==0) {
                    info.collection_height = 0;
                }else if (info.pics.count <=3){//0 ~ 3
                    info.collection_height = wd;
                }else if (info.pics.count <=6){//4 ~ 6
                    info.collection_height = wd*2 + gap;
                }else if (info.pics.count <=9){// 9~
                    info.collection_height = wd*3 + gap*2;
                }
                if (info.pics.count ==4) {
                    info.collection_width = wd*2 + gap;
                    info.collection_height = wd*2 + gap;
                }
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
                    self.page = currPage;
                    block(self.goodArr, self.imageStr, nil);
                    if (currPage >= totalPage) { // 当前页数大于等于最大页数 提示没有更多数据
                        self.isHaveNomoreData = YES;
                        
                    }else{
                        self.isHaveNomoreData = NO;
                    }
                }
            }else{ //没数据 空白页
                self.isHaveNomoreData = YES;
                block(@[].mutableCopy, self.imageStr,nil);
            }
        }else{
            block(@[].mutableCopy,  self.imageStr,nil);
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
        
        
    } failure:^(NSError *error) {
        block(nil,nil,error);
        NSLog(@"error =%@",error);
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
