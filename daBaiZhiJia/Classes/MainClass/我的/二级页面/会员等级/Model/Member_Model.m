//
//  Member_Model.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/1.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Member_Model.h"

@implementation Member_Model

+ (void)queryMemSetInfoWithBlock:(leverSetBlock)block{
    NSDictionary *dic = @{@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/getLevel") parameters:dic success:^(id responseObject) {
          NSLog(@"MemSetInfo %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSMutableArray *arr = [Member_LeverSetInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            for (Member_LeverSetInfo *info in arr) {
                if (info.level == 1) {
                    info.image  = @"img_vip01";
                }else if (info.level ==2 ){
                     info.image  = @"img_vip02";
                }else if (info.level==3){
                      info.image  = @"img_vip03";
                }
            }
            if (block) {
                block(arr,nil);
            }
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        block(nil,error);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}

+ (void)queryMemCurInfoWithBlock:(curMemInfoBlock)block{
    NSDictionary *dic = @{@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/getUserLevel") parameters:dic success:^(id responseObject) {
        NSLog(@"MemCurInfo %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            if (block) {
                Member_CurLeverInfo *curinfo = [Member_CurLeverInfo mj_objectWithKeyValues:responseObject[@"data"]];
//                curinfo.level = 2;
                block(curinfo,nil);
            }
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        block(nil,error);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}
@end



@implementation Member_LeverSetInfo



@end


@implementation Member_CurLeverInfo



@end
