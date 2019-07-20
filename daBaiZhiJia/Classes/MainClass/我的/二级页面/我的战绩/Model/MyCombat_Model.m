//
//  MyCombat_Model.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyCombat_Model.h"

@implementation MyCombat_Model
+ (void)queryDataWithBlock:(MyCombat_Block)bock{
    
    NSDictionary *dict = @{@"token":ToKen};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.share/getTodayShare") parameters:dict success:^(id responseObject) {
        NSLog(@"今日战绩 responseObject  %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            MyCombat_Info *info = [MyCombat_Info mj_objectWithKeyValues:responseObject[@"data"]];
            bock(info,nil);
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end



@implementation MyCombat_Info


@end
