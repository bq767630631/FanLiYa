//
//  MyInvitation_CodeContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyInvitation_CodeContrl.h"
#define Yellow_color RGBColor(255, 202, 9)
#define Gray_color   RGBColor(236, 236, 236)

@interface MyInvitation_CodeContrl ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inva_codeTF;
@property (weak, nonatomic) IBOutlet UIView *inva_line;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation MyInvitation_CodeContrl

- (void)viewDidLoad {
    [super viewDidLoad];
       self.title = @"我的邀请码";
    [self setUp];
}

- (void)setUp {
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_retBlack"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBColor(38, 38, 38) ,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
    self.inva_codeTF.delegate  = self;
}

- (void)setCode:(NSString *)code{
    _code = code;
    if (code) {
        self.inva_codeTF.text = _code;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.inva_codeTF) {
        self.inva_line.backgroundColor = Yellow_color;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.inva_codeTF) {
        self.inva_line.backgroundColor = Gray_color;
    }
}

#pragma mark - popAction
- (void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - action

- (IBAction)sureAction:(UIButton *)sender {
    if (self.inva_codeTF.text.length!=6) {
        [YJProgressHUD showMsgWithoutView:@"请输入六位有效邀请码"];
        return;
    }
    
    NSDictionary *dict = @{@"openid":WX_open_ID,@"unionid":WX_unionid,@"nickname":WX_nick_name, @"headimgurl":WX_headimg_url,@"token":ToKen,@"uuid":DeviceToken, @"phone":self.phone,  @"invite_sn":self.inva_codeTF.text,@"v":APP_Version};
//    NSLog(@"dict %@",dict);
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.login/wechatPhoneTo") parameters:dict success:^(id responseObject) {
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
            
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}

@end
