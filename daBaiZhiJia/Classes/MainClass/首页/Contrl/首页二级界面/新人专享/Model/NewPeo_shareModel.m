//
//  NewPeo_shareModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_shareModel.h"

@implementation NewPeo_shareModel
+ (void)queryNewPeoGoodWithBlock:(NewPeo_shareBlock)block{
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.share/getFreeList") parameters:@{@"token":ToKen} success:^(id responseObject) {
      //  NSLog(@"%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSInteger time = [responseObject[@"data"][@"time"]integerValue];
            
            NSMutableArray *list = [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            NewPeo_shareRuleInfo *rule = [NewPeo_shareRuleInfo mj_objectWithKeyValues:responseObject[@"data"][@"show"]];
            block(list,time,rule,nil);
        }else{
            
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        block(nil,0,nil,error);
    }];
}
@end


@implementation NewPeo_shareRuleInfo



@end
