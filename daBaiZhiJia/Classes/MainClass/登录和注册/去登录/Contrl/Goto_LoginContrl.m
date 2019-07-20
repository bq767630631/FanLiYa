//
//  Goto_LoginContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/24.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Goto_LoginContrl.h"
#import "Goto_Login_model.h"
#import "CountDownTime.h"
#import "RegisterContrl.h"
#import "ForeGetPwdcontrl.h"
#import "WXApi.h"

@interface Goto_LoginContrl ()<CountDownTimeDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_h;

@property (weak, nonatomic) IBOutlet UIView *swip_Line;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *swipline_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *swipline_centX;

@property (weak, nonatomic) IBOutlet UIButton *pwdLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *icon_pwdCode;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retBtnTop;

@property (weak, nonatomic) IBOutlet UITextField *count_TF;
@property (weak, nonatomic) IBOutlet UIView *count_line;

@property (weak, nonatomic) IBOutlet UIView *pwd_codeLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwd_codeLineTrail;


@property (weak, nonatomic) IBOutlet UITextField *psd_codeTF;
@property (weak, nonatomic) IBOutlet UIButton *geteCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UILabel *otherLb;

@property (nonatomic, strong) CountDownTime * countDown;

@end

@implementation Goto_LoginContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}


- (void)setUp{
    self.psd_codeTF.secureTextEntry = YES;
    ViewBorderRadius(self.contentV, 5, UIColor.clearColor);
    ViewBorderRadius(self.geteCodeBtn, 5, UIColor.clearColor);
    ViewBorderRadius(self.loginBtn, self.loginBtn.height*0.5, UIColor.clearColor);
    _contentV.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    _contentV.layer.shadowOffset = CGSizeMake(0,0);
    _contentV.layer.shadowOpacity = 1;
    _contentV.layer.shadowRadius = 3;
    _contentV.clipsToBounds = NO;
    self.otherLb.attributedText = [self otherAttstrWithStr1:@"还没有账号, " str2:@"去注册"];
    self.geteCodeBtn.hidden = YES;
    self.retBtnTop.constant += Height_StatusBar;
    self.psd_codeTF.delegate = self;
    self.count_TF.delegate  = self;
    if (IS_iPhone5SE) {
        self.content_top.constant =  80;
        self.content_h.constant =  330;
    }
    
}

- (NSMutableAttributedString *)otherAttstrWithStr1:(NSString*)str1 str2:(NSString *)str2{
    NSMutableAttributedString *mmustr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mmustr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:RGBColor(153, 153, 153)} range:NSMakeRange(0, str1.length)];
    return mmustr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - CountDownTimeDelegate
- (void)countDownTimeWithCurrentCount:(NSInteger)count{
    [_geteCodeBtn setTitle:[NSString stringWithFormat:@"%ldS",count] forState:UIControlStateNormal];
    [_geteCodeBtn setTitleColor:RGBColor(153, 153, 153) forState:UIControlStateNormal];
    _geteCodeBtn.userInteractionEnabled = NO;
    if (count == 0) {
        _geteCodeBtn.userInteractionEnabled = YES;
        [_geteCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_geteCodeBtn setTitleColor:RGBColor(51, 51, 51) forState:UIControlStateNormal];
        _geteCodeBtn.backgroundColor = RGBColor(255, 215, 0);
        ViewBorderRadius(_geteCodeBtn, 5, RGBColor(255, 215, 0));
    }
}
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.count_TF) {
        self.count_line.backgroundColor = RGBColor(255, 202, 9);
    }else{
        self.pwd_codeLine.backgroundColor = RGBColor(255, 202, 9);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.count_TF) {
         self.count_line.backgroundColor = RGBColor(236, 236, 236);
    }else{
        self.pwd_codeLine.backgroundColor = RGBColor(236, 236, 236);
    }
}

#pragma mark - action
- (IBAction)returnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)swip_pwd:(UIButton *)sender {
    sender.selected = YES;
    self.codeLoginBtn.selected = NO;

    [UIView animateWithDuration:0.2 animations:^{
        NSLog(@"centerX = %.f",sender.centerX);
        self.swip_Line.centerX = sender.centerX;
    }];
    NSLog(@"contentV %.f",self.contentV.width/4);
    
    NSLog(@"swip_pwdFrame%@", NSStringFromCGRect(sender.frame));
    self.geteCodeBtn.hidden = YES;
    self.icon_pwdCode.image = ZDBImage(@"icon_password");
    self.pwd_codeLineTrail.constant = 0;
    self.psd_codeTF.placeholder = @"请输入密码";
    self.psd_codeTF.secureTextEntry = YES;
    NSLog(@"");
}

- (IBAction)swip_codeLogin:(UIButton *)sender {
    sender.selected = YES;
    self.pwdLoginBtn.selected = NO;
 
    [UIView animateWithDuration:0.2 animations:^{
         self.swip_Line.centerX = sender.centerX;
    }];
    
    self.geteCodeBtn.hidden = NO;
     self.icon_pwdCode.image = ZDBImage(@"icon_checking");
    self.pwd_codeLineTrail.constant += (15 + 101);
    self.psd_codeTF.placeholder = @"请输入验证码";
    self.psd_codeTF.secureTextEntry = NO;
}

- (IBAction)getCodeAction:(UIButton *)sender {
      NSLog(@"");
    if (![self.count_TF.text validateMobile]) {
        [YJProgressHUD showMsgWithoutView:@"手机号格式不对"];
        return ;
    }
    
    [Goto_Login_model postValiteCodeWithStr:self.count_TF.text block:^(id res, NSError *error) {
        if (res) {
            [self.countDown starCountDown];
            self.geteCodeBtn.backgroundColor =  RGBColor(247, 247, 247);
            ViewBorderRadius(self.geteCodeBtn,5, RGBColor(247, 247, 247));
        }
    }];
}

- (IBAction)loginAction:(UIButton *)sender {
      NSLog(@"");
    if (self.count_TF.text.length == 0) {
        [YJProgressHUD showMsgWithoutView:@"手机号不能为空"];
        return;
    }
    if (self.psd_codeTF.text.length == 0) {
        if (self.pwdLoginBtn.isSelected) {
              [YJProgressHUD showMsgWithoutView:@"密码不能为空"];
        }else{
             [YJProgressHUD showMsgWithoutView:@"验证码不能为空"];
        }
        return;
    }
    if (![self.count_TF.text validateMobile]) {
        [YJProgressHUD showMsgWithoutView:@"手机号格式不对"];
        return ;
    }
    if (self.pwdLoginBtn.isSelected) { //密码登录
         [self handleLoginAction];
    }else{
        [Goto_Login_model codeloginWithPhone:self.count_TF.text code:self.psd_codeTF.text block:^(id res, NSError *error) {
            if (res) {
                [self delayDoWork:1.0 WithBlock:^{
                    [YJProgressHUD showMsgWithoutView:@"登录成功!"];
                }];
            self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
            self.navigationController.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
   
}

- (IBAction)forgetPwdBtn:(UIButton *)sender {
    [self.navigationController pushViewController:[ForeGetPwdcontrl new] animated:YES];
}

- (IBAction)gotoResis:(UIButton *)sender {
    [self.navigationController pushViewController:[RegisterContrl new] animated:YES];
}

#pragma mark
- (void)handleLoginAction{
    
    NSDictionary *para = @{@"phone":self.count_TF.text, @"password":self.psd_codeTF.text,@"uuid":DeviceToken,@"token":ToKen};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/login") parameters:para success:^(id responseObject) {
        NSLog(@"responseObject =%@",responseObject);
        NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) {
            
            NSInteger user_id   = [responseObject[@"data"][@"uid"] integerValue];
            NSInteger level = [responseObject[@"data"][@"level"] integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"level"];
            [[NSUserDefaults standardUserDefaults] synchronize];//
            
            [YJProgressHUD showMessage:@"登录成功!" inView:self.view afterDelayTime:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
                self.navigationController.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:YES];
               
                if (self.block) {
                    self.block();
                    }
                
            });
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error =%@",error);
    }];
}


- (CountDownTime *)countDown{
    if (!_countDown) {
        _countDown = [[CountDownTime alloc] init];
        _countDown.delegate = self;
    }
    return _countDown;
}


@end
