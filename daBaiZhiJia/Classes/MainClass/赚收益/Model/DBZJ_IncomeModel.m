//
//  DBZJ_IncomeModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_IncomeModel.h"


@implementation DBZJ_IncomeModel


+ (void)queryZqyDataWickBlock:(DBZJ_IncomBlock)block{
    NSDictionary *dick = @{@"token":ToKen};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/getUserLevel") parameters:dick success:^(id responseObject) {
        NSLog(@"queryZqyData =%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
           DBZJ_Zqy_Info *info = [DBZJ_Zqy_Info mj_objectWithKeyValues:responseObject[@"data"]];
            block(info,nil ,code);
        }else{
             block(nil,nil ,code);
           // [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        block(nil,error,0);
        NSLog(@"error %@",error);
    }];
}
@end


@implementation DBZJ_Zqy_Info



@end
