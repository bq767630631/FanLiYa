//
//  ZhuanQianYaFirstV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ZhuanQianYaFirstV.h"
#import "DBZJ_IncomeModel.h"
#import "DBZJ_Income_ProView.h"
#import "NewPeople_EnjoyContrl.h"
#import "DetailWebContrl.h"
#import "HandelTaoBaoTradeManager.h"
@interface ZhuanQianYaFirstV ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *lev_V;
@property (weak, nonatomic) IBOutlet UILabel *levLb;
@property (weak, nonatomic) IBOutlet UILabel *a1;
@property (weak, nonatomic) IBOutlet UILabel *a2;
@property (weak, nonatomic) IBOutlet UILabel *b1;
@property (weak, nonatomic) IBOutlet UILabel *b2;
@property (weak, nonatomic) IBOutlet UILabel *c1;
@property (weak, nonatomic) IBOutlet UILabel *c2;
@property (weak, nonatomic) IBOutlet UILabel *d1;

@property (weak, nonatomic) IBOutlet UILabel *d2;
@property (weak, nonatomic) IBOutlet UILabel *e1;
@property (weak, nonatomic) IBOutlet UILabel *e2;
@property (weak, nonatomic) IBOutlet UILabel *f1;
@property (weak, nonatomic) IBOutlet UILabel *f2;

@property (weak, nonatomic) IBOutlet UIView *lead_V;
//pro
@property (weak, nonatomic) IBOutlet UIView *proContentV1;
@property (weak, nonatomic) IBOutlet UIView *proContentV2;
@property (weak, nonatomic) IBOutlet UIView *proContentV3;
@property (nonatomic, strong) DBZJ_Income_ProView *pro1;
@property (nonatomic, strong) DBZJ_Income_ProView *pro2;
@property (nonatomic, strong) DBZJ_Income_ProView *pro3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proConLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proConTrain;

@property (weak, nonatomic) IBOutlet UIView *connectLeadV;
@property (weak, nonatomic) IBOutlet UIImageView *leadImage;
@property (weak, nonatomic) IBOutlet UILabel *leadName;
@property (weak, nonatomic) IBOutlet UILabel *wechat;
@property (weak, nonatomic) IBOutlet UIButton *ziXunBtn;

@property (nonatomic, strong)  DBZJ_Zqy_Info *info;

@end
@implementation ZhuanQianYaFirstV

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.headImageV, self.headImageV.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.lev_V, self.lev_V.height*0.5, UIColor.clearColor);
    
    ViewBorderRadius(self.lead_V, 17, RGBColor(245, 245, 245));
    ViewBorderRadius(self.ziXunBtn, self.ziXunBtn.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.leadImage, self.leadImage.height*0.5, UIColor.clearColor);
    if (IS_iPhone5SE) {
        self.proConTrain.constant = self.proConLead.constant = 22;
    }
}

- (void)setModel:(id)model{
    self.info = model;
    DBZJ_Zqy_Info *info = model;
    if ([NSString stringIsNullOrEmptry:info.wechat_image].length!=0) {
        [self.headImageV setPlaceholderImageWithFullPath:info.wechat_image placeholderImage:@"img_head_moren"];
    }
    self.name.text = info.wechat_name;
    self.levLb.text = info.level_name;
    
    self.a1.text = [NSString stringWithFormat:@"收益高达 %@",info.show.a.a];
    self.a2.text = [NSString stringWithFormat:@"购物与分享的%@佣金+%@额外奖励",info.show.a.b,info.show.a.c];
    self.b1.text = [NSString stringWithFormat:@"收益高达 %@",info.show.b.a];
    self.b2.text = [NSString stringWithFormat:@"得到直属团队的%@+团长的%@",info.show.b.b,info.show.b.c];
    self.c1.text = [NSString stringWithFormat:@"收益比例 %@",info.show.c.a];
    self.c2.text = [NSString stringWithFormat:@"得到关联团队的%@+团长的%@",info.show.c.b,info.show.c.c];
    self.d1.text = [NSString stringWithFormat:@"收益比例 %@",info.show.d.a];
    self.d2.text = [NSString stringWithFormat:@"其他团队出单平台额外补贴奖励%@",info.show.d.b];
    self.e1.text = [NSString stringWithFormat:@"收益比例 %@",info.show.e.a];
    self.e2.text = [NSString stringWithFormat:@"培养直属团长获得团队收益%@奖励",info.show.e.b];
    self.f1.text = [NSString stringWithFormat:@"收益比例 %@",info.show.f.a];
    self.f2.text = [NSString stringWithFormat:@"培养关联团长获得团队收益%@奖励",info.show.f.b];

    info.curStr = @"直属用户";
    info.totalStr = [NSString stringWithFormat:@"(邀请目标%@人)",info.next_share_number];
    info.strokeColor = RGBColor(246, 38, 137);
    info.lbStr = [NSString stringWithFormat:@"完成%@人",info.share_number];
    info.progress = info.share_number.doubleValue /info.next_share_number.doubleValue ;
    [self.pro1 setInfo:info];
    
    
    info.curStr = @"关联用户";
    info.totalStr = [NSString stringWithFormat:@"(邀请目标%@人)",info.next_relation_number];
    info.strokeColor = RGBColor(99, 91, 237);
    info.lbStr = [NSString stringWithFormat:@"完成%@人",info.relation_number];
  
     info.progress = info.relation_number.doubleValue /info.next_relation_number.doubleValue ;
    [self.pro2 setInfo:info];
    
    
    info.curStr = @"有效订单";
    info.totalStr = [NSString stringWithFormat:@"(30天订单大于%@笔)",info.next_order_number];
    info.strokeColor = RGBColor(245, 154, 74);
    info.lbStr = [NSString stringWithFormat:@"完成%@单",info.order_number];
    info.progress = info.order_number.doubleValue /info.next_order_number.doubleValue ;
    [self.pro3 setInfo:info];
    
    [self.leadImage setPlaceholderImageWithFullPath:info.share_wechat_image placeholderImage:@"img_head_moren"];
    self.leadName.text = info.share_wechat_name;
    self.wechat.text = [NSString stringWithFormat:@"微信号: %@",info.share_wechat_account];
}

#pragma mark - actions
- (IBAction)yaoQingAction:(UIButton *)sender {
//    [HandelTaoBaoTradeManager openCartWithNavi:self.viewController.navigationController];
//    return;
     [self.viewController.navigationController pushViewController:[NewPeople_EnjoyContrl new] animated:YES];
}

- (IBAction)lingQuanYi:(UIButton *)sender {
    if ([self.info.level isEqualToString:@"3"]) {
        [YJProgressHUD showMsgWithoutView:@"您已是团长"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/pay.html?token=%@",BASE_WEB_URL,ToKen];
    DetailWebContrl *vc = [[DetailWebContrl alloc] initWithUrl:url title:@"" para:nil];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ziXunAction:(UIButton *)sender {
    if (self.info.share_wechat_account.length) {
        [UIPasteboard generalPasteboard].string = self.info.share_wechat_account;
        [YJProgressHUD showMsgWithoutView:@"微信号复制成功"];
    }
}


#pragma mark - getter
- (DBZJ_Income_ProView *)pro1{
    if (!_pro1) {
        _pro1 = [DBZJ_Income_ProView viewFromXib];
        _pro1.frame = self.proContentV1.bounds;
        [self.proContentV1 addSubview:_pro1];
    }
    return _pro1;
}

- (DBZJ_Income_ProView *)pro2{
    if (!_pro2) {
        _pro2 = [DBZJ_Income_ProView viewFromXib];
        _pro2.frame = self.proContentV2.bounds;
        [self.proContentV2 addSubview:_pro2];
    }
    return _pro2;
}

- (DBZJ_Income_ProView *)pro3{
    if (!_pro3) {
        _pro3 = [DBZJ_Income_ProView viewFromXib];
        _pro3.frame = self.proContentV3.bounds;
        [self.proContentV3 addSubview:_pro3];
    }
    return _pro3;
}
@end
