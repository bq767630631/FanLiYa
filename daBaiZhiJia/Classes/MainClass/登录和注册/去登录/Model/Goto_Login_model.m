//
//  Goto_Login_model.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/24.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Goto_Login_model.h"

@implementation Goto_Login_model
+ (void)postValiteCodeWithStr:(NSString*)str block:(postCode_block)block{
    NSDictionary *dict = @{@"phone":str,@"token":ToKen};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/sendmsg") parameters:dict success:^(id responseObject) {
        NSLog(@"responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) {
            [self delayDoWork:1.0 WithBlock:^{
                  [YJProgressHUD showMsgWithoutView:@"验证码获取成功"];
            }];
            block(responseObject,nil);
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
          [YJProgressHUD showAlertTipsWithError:error];
        NSLog(@"error %@",error);
    }];
}

+ (void)codeloginWithPhone:(NSString *)phone code:(NSString *)code block:(postCode_block)block{
     NSDictionary *para = @{@"phone":phone, @"code":code,@"uuid":DeviceToken,@"token":ToKen};
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/loginByCode") parameters:para success:^(id responseObject) {
        NSLog(@"responseObject =%@",responseObject);
        NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) {
            
            NSInteger user_id   = [responseObject[@"data"][@"uid"] integerValue];
            NSInteger level = [responseObject[@"data"][@"level"] integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"level"];
            [[NSUserDefaults standardUserDefaults] synchronize];//
            
            block(responseObject,nil);
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showAlertTipsWithError:error];
    }];
    
}

+ (void)getWx_TokenWithUrl:(NSString *)urlStr callBack:(wxLogin_Block)block{
    [PPNetworkHelper GET:urlStr parameters:nil success:^(id responseObject) {
        NSLog(@"请求access的response = %@", responseObject);
        NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *accessToken = [accessDict objectForKey:@"access_token"];
        NSString *openID = [accessDict objectForKey:@"openid"];
        NSString *unionid = [accessDict objectForKey:@"unionid"];
        NSString *refreshToken = [accessDict objectForKey:@"refresh_token"];
        // 本地持久化，以便access_token的使用、刷新或者持续
        if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"wx_access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:openID forKey:@"wx_openid"];
            [[NSUserDefaults standardUserDefaults] setObject:unionid forKey:@"wx_unionid"];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refresh_token"];
            [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
        }
        [self requestWxInfocallBack:block];
        
    } failure:^(NSError *error) {
        [[NSUserDefaults standardUserDefaults]  objectForKey:@"wx_access_token"];
        
    }];
}

#pragma mark - private
+ (void)requestWxInfocallBack:(wxLogin_Block)block{
    NSString *accessToken = WX_Accssen_Token;
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:@"wx_openid"];
    
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, accessToken, openID];
    
    [PPNetworkHelper GET:userUrlStr parameters:nil success:^(id responseObject) {
        
        NSLog(@"请求用户信息的response = %@", responseObject);
        NSString *nickname = responseObject[@"nickname"];
        NSString *headimgurl = responseObject[@"headimgurl"];
        NSInteger sex = [responseObject[@"sex"] integerValue];
        
        [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"wx_nickname"];
        [[NSUserDefaults standardUserDefaults] setObject:headimgurl forKey:@"wx_headimgurl"];
        [[NSUserDefaults standardUserDefaults] setInteger:sex forKey:@"wx_sex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //再微信登录
        [self wxLoginWithcallBack:block];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


+ (void)wxLoginWithcallBack:(wxLogin_Block)block{
    NSDictionary *dict = @{@"openid":WX_open_ID,@"unionid":WX_unionid,@"nickname":WX_nick_name, @"headimgurl":WX_headimg_url,@"token":ToKen,@"uuid":DeviceToken };
    NSLog(@"wxLogin dict =%@",dict);
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/wechat") parameters:dict success:^(id responseObject) {
        NSLog(@"wechat responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) {
            NSInteger user_id   = [responseObject[@"data"][@"uid"] integerValue];
            NSInteger level = [responseObject[@"data"][@"level"] integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"level"];
            [[NSUserDefaults standardUserDefaults] synchronize];//
              block (code);
        }else{
              block (code);
        }
      
    } failure:^(NSError *error) {
         NSLog(@"%@",error);
        block(0);
    }];
}
@end
