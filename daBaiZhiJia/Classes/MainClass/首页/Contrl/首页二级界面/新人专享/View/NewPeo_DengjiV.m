//
//  NewPeo_DengjiV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/12.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_DengjiV.h"
@interface NewPeo_DengjiV ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
@implementation NewPeo_DengjiV


- (void)awakeFromNib{
    [super awakeFromNib];
     self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    ViewBorderRadius(self.sureBtn, self.sureBtn.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.contentV, 5, UIColor.clearColor);
    self.tf.delegate = self;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)show{
    UIWindow *keyW = [UIApplication sharedApplication].keyWindow;
    [keyW addSubview:self];
    self.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)disMiss{
    self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        self.sureBtn.userInteractionEnabled = YES;
        [self.sureBtn setTitleColor:RGBColor(51, 51, 51) forState:UIControlStateNormal];
        [self.sureBtn setBackgroundColor:RGBColor(255, 205, 0)];
    }else{
        self.sureBtn.userInteractionEnabled = NO;
        [self.sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.sureBtn setBackgroundColor:RGBColor(221, 221, 221)];
    }
}

- (IBAction)suReAction:(UIButton *)sender {
    if (self.tf.text.length==0) {
        [YJProgressHUD showMsgWithoutView:@"请输入订单号"];
        return;
    }
    NSDictionary *para = @{@"token":ToKen,@"order_sn":self.tf.text};
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/feedorder") parameters:para success:^(id responseObject) {
        NSLog(@"%@",responseObject);
           NSInteger code = [responseObject[@"code"] integerValue];
        if (code== SucCode) {
            [self disMiss];
        }
        [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}


- (IBAction)closeAction:(UIButton *)sender {
    [self disMiss];
}

@end
