//
//  Bind_PhoneContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Bind_PhoneContrl.h"
#import "CountDownTime.h"
#import "MyInvitation_CodeContrl.h"

#define Yellow_color RGBColor(255, 202, 9)
#define Gray_color   RGBColor(236, 236, 236)
@interface Bind_PhoneContrl ()<CountDownTimeDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UIView *phone_line;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIView *code_Line;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, strong) CountDownTime * countDown;
@end

@implementation Bind_PhoneContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    [self setUp];
}

- (void)setUp{
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_retBlack"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBColor(38, 38, 38) ,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
    
    ViewBorderRadius(self.getCodeBn, 5, UIColor.clearColor);
    ViewBorderRadius(self.sureBtn, self.sureBtn.height*0.5, UIColor.clearColor);
    self.codeTF.delegate = self;
    self.phoneTf.delegate = self;
}

#pragma mark - popAction
- (void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.phoneTf) {
        self.phone_line.backgroundColor = Yellow_color;
    }else if (textField == self.codeTF){
        self.code_Line.backgroundColor = Yellow_color;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.phoneTf) {
        self.phone_line.backgroundColor = Gray_color;
    }else if (textField == self.codeTF){
        self.code_Line.backgroundColor = Gray_color;
    }
}

#pragma mark - CountDownTimeDelegate
- (void)countDownTimeWithCurrentCount:(NSInteger)count{
    [_getCodeBn setTitle:[NSString stringWithFormat:@"%ldS",count] forState:UIControlStateNormal];
    [_getCodeBn setTitleColor:RGBColor(153, 153, 153) forState:UIControlStateNormal];
    _getCodeBn.userInteractionEnabled = NO;
    if (count == 0) {
        _getCodeBn.userInteractionEnabled = YES;
        [_getCodeBn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBn setTitleColor:RGBColor(51, 51, 51) forState:UIControlStateNormal];
        _getCodeBn.backgroundColor =  RGBColor(255, 215, 0);
        ViewBorderRadius(_getCodeBn, 5, RGBColor(255, 215, 0));
    }
}

#pragma mark - action
- (IBAction)getCodeAction:(UIButton *)sender {
    if (![self.phoneTf.text validateMobile]) {
        [YJProgressHUD showMsgWithoutView:@"手机号格式不对"];
        return ;
    }
    NSDictionary *dict = @{@"phone":self.phoneTf.text,@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/sendmsg") parameters:dict success:^(id responseObject) {
        NSLog(@"responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) {
            [self.countDown starCountDown];
            self.getCodeBn.backgroundColor = RGBColor(247, 247, 247);
            ViewBorderRadius(self.getCodeBn, 5, RGBColor(247, 247, 247));
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}


- (IBAction)sureAction:(UIButton *)sender {
    if (self.phoneTf.text.length == 0) {
        [YJProgressHUD showMsgWithoutView:@"手机号不能为空"];
        return;
    }
    if (![self.phoneTf.text validateMobile]) {
        [YJProgressHUD showMsgWithoutView:@"手机号格式不对"];
        return ;
    }
    if (self.codeTF.text.length == 0) {
        [YJProgressHUD showMsgWithoutView:@"手机验证码不能为空"];
        return;
    }
    
    NSDictionary *dict = @{@"openid":WX_open_ID,@"unionid":WX_unionid,@"nickname":WX_nick_name, @"headimgurl":WX_headimg_url,@"token":ToKen,@"uuid":DeviceToken, @"phone":self.phoneTf.text,  @"code":self.codeTF.text,@"v":APP_Version};
    NSLog(@"dict %@",dict);
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/wechatPhone") parameters:dict success:^(id responseObject) {
        NSLog(@"responseObject %@",responseObject);
        NSInteger code = [responseObject[@"code"]integerValue];
        if (code == SucCode) { //绑定成功，跳转到个人中心
            NSInteger user_id   = [responseObject[@"data"][@"uid"] integerValue];
            NSInteger level = [responseObject[@"data"][@"level"] integerValue];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setInteger:user_id forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"level"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
            self.navigationController.tabBarController.selectedIndex = 4;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else if (code == 1006){ //未注册过的手机号可以下一步邀请码
            MyInvitation_CodeContrl *inva = [MyInvitation_CodeContrl new];
            inva.phone = self.phoneTf.text;
            [self.navigationController pushViewController:inva animated:YES];
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [YJProgressHUD showAlertTipsWithError:error];
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
