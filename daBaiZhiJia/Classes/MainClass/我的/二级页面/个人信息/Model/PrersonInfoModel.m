//
//  PrersonInfoModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PrersonInfoModel.h"

@implementation PrersonInfoModel
+ (void)queryPersonWithBlock:(prersonInfoBlock)block{
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/getuserinfo") parameters:@{@"token":ToKen} success:^(id responseObject) {
        //NSLog(@"responseObject  %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            PrersonInfoMsg *info = [PrersonInfoMsg mj_objectWithKeyValues:responseObject[@"data"]];
            if (block) {
                block(info);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [YJProgressHUD showAlertTipsWithError:error ];
        if (block) {
            block(nil);
        }
        
    }];
}

+ (void)modifyHeadImageWithimage:(UIImage *)image {
   
     NSData *imgData = UIImageJPEGRepresentation(image, 0.1f);
     NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *para = @{@"token":ToKen,@"wechat_image":encodedImageStr};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/updUserImg") parameters:para success:^(id responseObject) {
        NSLog(@"responseObject  %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeHeadImageSucNotiFi object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [YJProgressHUD showMsgWithoutView:@"修改成功"];
            });
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
       
         [YJProgressHUD showAlertTipsWithError:error];
          NSLog(@"%@",error);
    }];
}

+ (void)taobaoAuthBindWithOpenId:(NSString *)openId callBack:(void (^)(BOOL))block{
    NSDictionary *para = @{@"token":ToKen, @"openId":openId};
    [PPNetworkHelper GET:URL_Add(@"/v.php/user.user/bindtaoopenid") parameters:para success:^(id responseObject) {
        NSLog(@"responseObject  %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (block) {
                    block(YES);
                }
                 [YJProgressHUD showMsgWithoutView:@"授权成功"];
            });
        }else{
            if (block) {
                block(NO);
            }
             [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        if (block) {
            block(NO);
        }
        [YJProgressHUD showAlertTipsWithError:error];
        NSLog(@"%@",error);
    }];
}

+ (void)queryTaboBaoAuthUrlWithCallBack:(void (^)(NSString * ))block{
    
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getAuthUrl") parameters:@{@"token":ToKen} success:^(id responseObject) {
          NSLog(@"获取 淘宝授权URL res =%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSString *url = responseObject[@"data"];
            block(url);
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
         block(nil);
        NSLog(@"获取 淘宝授权URL%@",error);
    }];
}
+ (void)queryPersonRevenueWithBlcok:(prersonRevenueBlock)block{
    NSLog(@"ToKen = %@",ToKen);
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.profit/usercentprofit") parameters:@{@"token":ToKen} success:^(id responseObject) {
        NSLog(@"个人收益 responseObject  %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            PersonRevenue *info = [PersonRevenue mj_objectWithKeyValues:responseObject[@"data"]];
            
            [[NSUserDefaults standardUserDefaults] setInteger:info.level_ forKey:@"level"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (block) {
                block(info,code);
            }
            
        }else{
             block(nil,code);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        [YJProgressHUD showAlertTipsWithError:error ];
        if (block) {
            block(nil,0);
        }
        
    }];
}
@end


@implementation PrersonInfoMsg

@end

@implementation PersonRevenue



@end
