//
//  ContactKefuContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/29.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ContactKefuContrl.h"
#import "DBZJ_IncomeModel.h"
@interface ContactKefuContrl ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *weixin;
@property (weak, nonatomic) IBOutlet UIButton *cpyBtn;
@property (nonatomic, copy) NSString *wxstr;
@end

@implementation ContactKefuContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专属客服";
    [self setUp];
    [self queryData];
}

- (void)setUp{
     ViewBorderRadius(self.view1, 7, UIColor.clearColor);
     ViewBorderRadius(self.view2, 7, UIColor.clearColor);
     ViewBorderRadius(self.cpyBtn, self.cpyBtn.height*0.5,RGBColor(51, 51, 51));
}

- (void)queryData{
    [DBZJ_IncomeModel queryZqyDataWickBlock:^(DBZJ_Zqy_Info *info, NSError *error, NSInteger code) {
        if (info) {
            self.weixin.text =  [NSString stringWithFormat:@"微信: %@",info.kefu_wechat_account];
            self.wxstr = info.kefu_wechat_account;
        }
    }];
}

- (IBAction)cpyActipn:(UIButton *)sender {
    if (self.wxstr.length ==0) {
        return;
    }
    [UIPasteboard generalPasteboard].string = self.wxstr;
    [YJProgressHUD showMsgWithoutView:@"微信号复制成功"];
}

@end
