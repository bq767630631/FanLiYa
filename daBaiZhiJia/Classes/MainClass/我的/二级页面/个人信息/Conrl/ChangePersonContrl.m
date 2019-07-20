//
//  ChangePersonContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/11.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ChangePersonContrl.h"

@interface ChangePersonContrl ()
@property (nonatomic, assign) ChangeInfoType type;
@property (nonatomic, copy) NSString *text;
@property (weak, nonatomic) IBOutlet PersonTF *customTf;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation ChangePersonContrl

- (instancetype)initWithType:(ChangeInfoType)type text:(NSString*)text{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.type = type;
    self.text = text;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.type == ChangeInfoType_niChen ? @"修改昵称":@"修改微信号";
    self.customTf.text = self.text;
    self.customTf.placeholder = self.type == ChangeInfoType_niChen ?@"请输入昵称":@"请输入微信号";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)completeAction{
    if (self.customTf.text.length ==0) {
        [YJProgressHUD showMsgWithoutView:@"请输入内容"];
        return;
    }
    NSDictionary *para = self.type ==ChangeInfoType_niChen ? @{@"token":ToKen, @"wechat_name":self.customTf.text}: @{@"token":ToKen, @"wechat_account":self.customTf.text};
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/updUser")    parameters:para success:^(id responseObject) {
        NSLog(@"responseObject  %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [YJProgressHUD showMsgWithoutView:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.block) {
                    self.block(self.customTf.text);
                }
            });
        }
    } failure:^(NSError *error) {
           [YJProgressHUD showAlertTipsWithError:error];
    }];
    
}


- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightBtn.frame = CGRectMake(0, 0, 50, 25);
    }
    return _rightBtn;
}
@end



@implementation PersonTF

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    bounds.origin.x = 15.f;
    return bounds;
}


- (CGRect)editingRectForBounds:(CGRect)bounds{
    bounds.origin.x = 15.f;
    return bounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    bounds.origin.x = 15.f;
    return bounds;
}

//- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
//    //bounds.origin.x = SCREEN_WIDTH - 15 - 12;
//    NSLog(@" bounds.origin.x = %@", NSStringFromCGRect(bounds));
//    return bounds;
//}

@end
