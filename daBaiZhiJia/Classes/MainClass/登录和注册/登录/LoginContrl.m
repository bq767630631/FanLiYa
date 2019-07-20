//
//  LoginContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/2.
//  Copyright © 2019 包强. All rights reserved.
//

#import "LoginContrl.h"
#import "RegisterContrl.h"
#import "ForeGetPwdcontrl.h"
#import "Goto_LoginContrl.h"
#import "RegisterContrl.h"
#import "WXApi.h"
#import "Goto_Login_model.h"
#import "Bind_PhoneContrl.h"

@interface LoginContrl ()<WXApiDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageItemTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnTop;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;
@property (weak, nonatomic) IBOutlet UIView *otherV;
@property (weak, nonatomic) IBOutlet UIButton *wx_btn;

@end

@implementation LoginContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_iPhone5SE) {
        self.imageItemTop.constant =  50;
        self.loginBtnTop.constant =  70;
    }
    ViewBorderRadius(self.loginBtn, self.loginBtn.height*0.5, UIColor.whiteColor);
    ViewBorderRadius(self.regisBtn, self.regisBtn.height*0.5, UIColor.whiteColor);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (![WXApi isWXAppInstalled]) {
        self.otherV.hidden = YES;
        self.wx_btn.hidden = YES;
    }else{
        self.otherV.hidden = NO;
        self.wx_btn.hidden = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - action

- (IBAction)closeAction:(UIButton *)sender {
    if (self.isFrom_homePage) {
        self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
        self.navigationController.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
   
    if (self.closeblock) {
        self.closeblock();
    }
}

- (IBAction)login_newAction:(UIButton *)sender {
    [self.navigationController pushViewController:[Goto_LoginContrl new] animated:YES];
}

- (IBAction)regis_newAction:(UIButton *)sender {
      [self.navigationController pushViewController:[RegisterContrl new] animated:YES];
}

- (IBAction)weXinLoginAction:(UIButton *)sender {

    SendAuthReq *request = [SendAuthReq new];
    request.state  =  [NSString getRandomStr];
    request.scope  = @"snsapi_userinfo";
    BOOL res  = [WXApi sendReq:request];
    NSLog(@"res %d",res);
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *temp = (SendAuthResp *)resp;
        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_BASE_URL , WXAPPID, WXAPPSECRET, temp.code];
        
        [Goto_Login_model getWx_TokenWithUrl:accessUrlStr callBack:^(NSInteger code) {
            if (code == 1004) { //下一步
                NSLog(@"currentThread2 =%@", [NSThread currentThread]);
                [self.navigationController pushViewController:[Bind_PhoneContrl new] animated:YES];
            }else if (code == SucCode){
                [self delayDoWork:0.5 WithBlock:^{
                    [YJProgressHUD showMsgWithoutView:@"登录成功!"];
                }];
                self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
                self.navigationController.tabBarController.selectedIndex = 4;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}



@end
