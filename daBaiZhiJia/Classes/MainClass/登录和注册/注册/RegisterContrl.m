//
//  RegisterContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/2.
//  Copyright © 2019 包强. All rights reserved.
//

#import "RegisterContrl.h"
#import "CountDownTime.h"
#import "Goto_LoginContrl.h"
#import "DetailWebContrl.h"

#define Yellow_color RGBColor(255, 202, 9)
#define Gray_color   RGBColor(236, 236, 236)
@interface RegisterContrl ()<CountDownTimeDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retuenBtnTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewTop;
@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UITextField *countTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *invatationCode;

@property (weak, nonatomic) IBOutlet UITextField *pwdTf;


@property (weak, nonatomic) IBOutlet UIView *count_line;
@property (weak, nonatomic) IBOutlet UIView *pwd_line;

@property (weak, nonatomic) IBOutlet UIView *code_line;
@property (weak, nonatomic) IBOutlet UIView *invite_line;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIButton *regis_btn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regsBtn_H;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentV_H;


@property (weak, nonatomic) IBOutlet UILabel *otherLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherV_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCodeBtn_W;

@property (nonatomic, strong) CountDownTime * countDown;
@end

@implementation RegisterContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.codeStr) {
        self.invatationCode.text = self.codeStr;
    }
    [self setUp];
}
- (void)setUp{
    self.retuenBtnTop.constant += Height_StatusBar;
    ViewBorderRadius(self.contentV, 5, UIColor.clearColor);
    _contentV.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    _contentV.layer.shadowOffset = CGSizeMake(0,0);
    _contentV.layer.shadowOpacity = 1;
    _contentV.layer.shadowRadius = 3;
    _contentV.clipsToBounds = NO;
   
    self.otherLb.attributedText = [self otherAttstrWithStr1:@"已经有账号, " str2:@"去登录"];
    self.pwdTf.secureTextEntry = YES;
    self.countTf.delegate = self;
    self.pwdTf.delegate = self;
    self.codeTf.delegate = self;
    self.invatationCode.delegate = self; //已经有账号, 去登录
    if (IS_iPhone5SE) {
        self.containViewTop.constant =  80;
        self.regsBtn_H.constant = 40;
        self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14*0.8];
        self.contentV_H.constant -= 15;
        self.otherV_Top.constant -= 10;
        self.getCodeBtn_W.constant *= 0.8;
    }
    ViewBorderRadius(self.getCodeBtn, 5, UIColor.clearColor);
    ViewBorderRadius(self.regis_btn, self.regis_btn.height*0.5, UIColor.clearColor);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSMutableAttributedString *)otherAttstrWithStr1:(NSString*)str1 str2:(NSString *)str2{
    NSMutableAttributedString *mmustr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mmustr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:RGBColor(153, 153, 153)} range:NSMakeRange(0, str1.length)];
    return mmustr;
}

#pragma mark - popAction
- (void)leftBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.countTf) {
        self.count_line.backgroundColor = Yellow_color;
    }else if (textField == self.pwdTf){
        self.pwd_line.backgroundColor = Yellow_color;
    }else if (textField == self.codeTf){
        self.code_line.backgroundColor = Yellow_color;
    }else if (textField == self.invatationCode){
        self.invite_line.backgroundColor = Yellow_color;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.countTf) {
        self.count_line.backgroundColor = Gray_color;
    }else if (textField == self.pwdTf){
        self.pwd_line.backgroundColor = Gray_color;
    }else if (textField == self.codeTf){
        self.code_line.backgroundColor = Gray_color;
    }else if (textField == self.invatationCode){
        self.invite_line.backgroundColor = Gray_color;
    }
}

#pragma mark - CountDownTimeDelegate
- (void)countDownTimeWithCurrentCount:(NSInteger)count{
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ldS",count] forState:UIControlStateNormal];
    [_getCodeBtn setTitleColor:RGBColor(153, 153, 153) forState:UIControlStateNormal];
    _getCodeBtn.userInteractionEnabled = NO;
    if (count == 0) {
        _getCodeBtn.userInteractionEnabled = YES;
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
         [_getCodeBtn setTitleColor:RGBColor(51, 51, 51) forState:UIControlStateNormal];
        _getCodeBtn.backgroundColor =  RGBColor(255, 215, 0);
        ViewBorderRadius(_getCodeBtn, 5, RGBColor(255, 215, 0));
    }
}

#pragma mark - IBAction

- (IBAction)retAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCodeAction:(UIButton *)sender {
    NSLog(@"获取验证码");
    if (![self.countTf.text validateMobile]) {
        [YJProgressHUD showMsgWithoutView:@"手机号格式不对"];
        return ;
    }
    NSDictionary *dict = @{@"phone":self.countTf.text,@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/sendmsg") parameters:dict success:^(id responseObject) {
        NSLog(@"responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) {
            [self.countDown starCountDown];
            self.getCodeBtn.backgroundColor =  RGBColor(247, 247, 247);
            ViewBorderRadius(self.getCodeBtn, 5, RGBColor(247, 247, 247));
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
         NSLog(@"error %@",error);
    }];
}

- (IBAction)selectBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)privaceAction:(UIButton *)sender {
    NSString *url = [NSString stringWithFormat:@"%@/userProtocol.html",BASE_WEB_URL];
    DetailWebContrl *detail  = [[DetailWebContrl alloc] initWithUrl:url title:@"" para:nil];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)goTo_login:(UIButton *)sender {
    [self.navigationController pushViewController:[Goto_LoginContrl new] animated:YES];
}

- (IBAction)sureAction:(UIButton *)sender {
     NSLog(@"sureAction");
    if (self.countTf.text.length == 0) {
          [YJProgressHUD showMsgWithoutView:@"手机号不能为空"];
        return;
    }
    if (![self.countTf.text validateMobile]) {
        [YJProgressHUD showMsgWithoutView:@"手机号格式不对"];
        return ;
    }
    if (self.codeTf.text.length == 0) {
        [YJProgressHUD showMsgWithoutView:@"手机验证码不能为空"];
        return;
    }
    if (self.invatationCode.text.length == 0) {
        [YJProgressHUD showMsgWithoutView:@"邀请码不能为空"];
        return;
    }
    if (self.pwdTf.text.length == 0) {
        [YJProgressHUD showMsgWithoutView:@"密码不能为空"];
        return;
    }
   
    if (!self.selectBtn.isSelected) {
         [YJProgressHUD showMsgWithoutView:@"请勾选用户协议"];
        return;
    }
    
    NSDictionary *dict = @{@"phone":self.countTf.text,@"password":self.pwdTf.text,@"code":self.codeTf.text,@"invite_sn":self.invatationCode.text,@"token":ToKen,@"v":APP_Version};
    NSLog(@"dict =%@",dict);
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/register") parameters:dict success:^(id responseObject) {
        NSLog(@"responseObject %@",responseObject);
         NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) {
            
            NSInteger user_id   = [responseObject[@"data"][@"uid"] integerValue];
            NSInteger level = [responseObject[@"data"][@"level"] integerValue];
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"level"];
            [[NSUserDefaults standardUserDefaults] synchronize];
             [YJProgressHUD showMsgWithoutView:@"注册成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
                self.navigationController.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
         NSLog(@"error %@",error);
    }];
    
}

#pragma mark - getter
- (CountDownTime *)countDown{
    if (!_countDown) {
        _countDown = [[CountDownTime alloc] init];
        _countDown.delegate = self;
    }
    return _countDown;
}
@end
