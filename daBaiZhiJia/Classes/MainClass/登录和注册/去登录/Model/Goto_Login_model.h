//
//  Goto_Login_model.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/24.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

typedef void(^postCode_block)(id res, NSError*error);
typedef void(^wxLogin_Block)(NSInteger code); //1004:下一步 2000:登陆成功，跳转到个人中心 2068:你的微信号已经绑定过其他手机
@interface Goto_Login_model : NSObject
//获取验证码
+ (void)postValiteCodeWithStr:(NSString*)str block:(postCode_block)block;

//验证码登录
+ (void)codeloginWithPhone:(NSString*)phone code:(NSString*)code block:(postCode_block)block;


+ (void)getWx_TokenWithUrl:(NSString *)urlStr callBack:(wxLogin_Block)block;
@end

