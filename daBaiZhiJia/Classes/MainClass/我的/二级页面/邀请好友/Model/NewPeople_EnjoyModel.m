//
//  NewPeople_EnjoyModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeople_EnjoyModel.h"

@implementation NewPeople_EnjoyModel
+ (void)queryHaiBaoWitkBlcok:(NewPeople_Block)block{
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.share/getShare") parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
        NSLog(@"responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSString *code = responseObject[@"data"][@"code"];
            NSString *url = responseObject[@"data"][@"url"];
            NSMutableArray*list = responseObject[@"data"][@"list"];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary*pic in list) {
                NewPeople_EnjoyInfo *info = [NewPeople_EnjoyInfo new];
                info.code = code;
                info.url = url;
                info.pic = pic[@"pic"];
                [temp addObject:info];
            }
            block(temp);
        }else{
            //[YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        block(nil);
        NSLog(@"%@",error);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}
@end

@implementation NewPeople_EnjoyInfo



@end
