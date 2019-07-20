//
//  ForeGetPwdcontrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/2.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ForeGetPwdcontrl.h"
#import "CountDownTime.h"

#define Yellow_color RGBColor(255, 202, 9)
#define Gray_color   RGBColor(236, 236, 236)
@interface ForeGetPwdcontrl ()<CountDownTimeDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_Top;


@property (weak, nonatomic) IBOutlet UITextField *countTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *pwdTf;

@property (weak, nonatomic) IBOutlet UITextField *surepwdTf;

@property (weak, nonatomic) IBOutlet UIView *count_line;
@property (weak, nonatomic) IBOutlet UIView *code_line;
@property (weak, nonatomic) IBOutlet UIView *pwd_line;
@property (weak, nonatomic) IBOutlet UIView *surepwd_line;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, strong) CountDownTime * countDown;
@end

@implementation ForeGetPwdcontrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    [self setUp];
}

- (void)setUp {
    self.content_Top.constant = NavigationBarBottom(self.navigationController.navigationBar);
    ViewBorderRadius(self.getCodeBtn,5,UIColor.clearColor);
    ViewBorderRadius(self.nextBtn, self.nextBtn.height*0.5,UIColor.clearColor);
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_retBlack"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBColor(38, 38, 38) ,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
    self.countTf.delegate = self;
    self.codeTf.delegate = self;
    self.pwdTf.delegate = self;
    self.surepwdTf.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar navBarBackGroundColor:UIColor.whiteColor image:nil isOpaque:YES];
}

#pragma mark - popAction
- (void)leftBarButtonItemClick{
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
    }else if (textField == self.surepwdTf){
        self.surepwd_line.backgroundColor = Yellow_color;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.countTf) {
        self.count_line.backgroundColor = Gray_color;
    }else if (textField == self.pwdTf){
        self.pwd_line.backgroundColor = Gray_color;
    }else if (textField == self.codeTf){
        self.code_line.backgroundColor = Gray_color;
    }else if (textField == self.surepwdTf){
        self.surepwd_line.backgroundColor = Gray_color;
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
- (IBAction)getCodeAction:(UIButton *)sender {
    if (![self.countTf.text validateMobile]) {
        [YJProgressHUD showMsgWithoutView:@"手机号格式不对"];
        return ;
    }
    NSDictionary *dict = @{@"phone":self.countTf.text,@"token":ToKen};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/sendmsg") parameters:dict success:^(id responseObject) {
        NSLog(@"responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) {
            [self.countDown starCountDown];
            self.getCodeBtn.backgroundColor = RGBColor(247, 247, 247);
            ViewBorderRadius(self.getCodeBtn, 5, RGBColor(247, 247, 247));
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}


- (IBAction)completeAction:(UIButton *)sender {
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
    if (self.pwdTf.text.length == 0) {
        [YJProgressHUD showMsgWithoutView:@"密码不能为空"];
        return;
    }
    if (self.surepwdTf.text.length == 0) {
        [YJProgressHUD showMsgWithoutView:@"确认密码不能为空"];
        return;
    }
    if (![self.pwdTf.text isEqualToString:self.surepwdTf.text]) {
        [YJProgressHUD showMsgWithoutView:@"两次输入的密码不一样"];
        return;
    }
    NSDictionary *dict = @{@"phone":self.countTf.text,@"password":self.pwdTf.text,@"code":self.codeTf.text,@"token":ToKen};
    NSLog(@"dict =%@",dict);
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/resetpassword") parameters:dict success:^(id responseObject) {
          NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) {
             [YJProgressHUD showMsgWithoutView:@"找回密码成功"];
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
