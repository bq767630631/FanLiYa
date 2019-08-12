//
//  DBZJ_Income_First.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_Income_First.h"
#import "DBZJ_IncomeModel.h"
#import "DBZJ_Income_ProView.h"
#import "NewPeople_EnjoyContrl.h"
#import "UIButton+WebCache.h"

@interface DBZJ_Income_First ()
@property (weak, nonatomic) IBOutlet UIImageView *personImag;
@property (weak, nonatomic) IBOutlet UILabel *perName;
@property (weak, nonatomic) IBOutlet UILabel *cur_lev;
@property (weak, nonatomic) IBOutlet UILabel *curLable;

@property (weak, nonatomic) IBOutlet UIView *leadProV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadH;

@property (weak, nonatomic) IBOutlet UIButton *ziXunBtn;
@property (weak, nonatomic) IBOutlet UIButton *addHaoyouBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ziXunImagLead;

@property (weak, nonatomic) IBOutlet UILabel *retPro;

@property (weak, nonatomic) IBOutlet UIImageView *leadImage;

@property (weak, nonatomic) IBOutlet UILabel *leadName;
@property (weak, nonatomic) IBOutlet UILabel *leadCode;

@property (weak, nonatomic) IBOutlet UILabel *codNum;

@property (weak, nonatomic) IBOutlet UILabel *tuanZhangPro;

@property (weak, nonatomic) IBOutlet UIButton *shenQingAction;

@property (nonatomic, strong)  DBZJ_Zqy_Info *info;

@property (weak, nonatomic) IBOutlet UIView *pro1;  //3ge

@property (weak, nonatomic) IBOutlet UIView *pro1_v1;

@property (weak, nonatomic) IBOutlet UIView *pro1_V2;

@property (weak, nonatomic) IBOutlet UIView *pro1_v3;


@property (weak, nonatomic) IBOutlet UIView *pro2; //2ge
@property (weak, nonatomic) IBOutlet UIView *pro2_v1;
@property (weak, nonatomic) IBOutlet UIView *pro2_v2;

@property (weak, nonatomic) IBOutlet UIButton *yaoQingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *moshiImageV;
@property (weak, nonatomic) IBOutlet UIImageView *teQuanImageV;

@property (nonatomic, strong) DBZJ_Income_ProView *firstPro;
@property (nonatomic, strong) DBZJ_Income_ProView *secPro;
@property (nonatomic, strong) DBZJ_Income_ProView *thirdPro;

@property (weak, nonatomic) IBOutlet UIImageView *tuanznhangImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moshi_aspec;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tequan_aspec;
@property (weak, nonatomic) IBOutlet UIView *contantTuanV;

@end
@implementation DBZJ_Income_First

- (void)awakeFromNib{
    [super awakeFromNib];
    self.personImag.layer.cornerRadius = self.personImag.frame.size.width/2;//裁成圆角
    self.personImag.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    self.personImag.layer.borderWidth = 3.f;//宽度
    self.personImag.layer.borderColor = RGBColor(215, 171, 58).CGColor;//颜色
    ViewBorderRadius(self.curLable, self.curLable.height*0.5, self.curLable.textColor);
    ViewBorderRadius(self.leadImage, self.leadImage.height*0.5, UIColor.clearColor);
    
    ViewBorderRadius(self.ziXunBtn, self.ziXunBtn.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.addHaoyouBtn, self.addHaoyouBtn.height*0.5, UIColor.clearColor);
      ViewBorderRadius(self.shenQingAction, self.shenQingAction.height*0.5, UIColor.clearColor);
    if (IS_iPhone5SE) {
        self.ziXunImagLead.constant = self.ziXunImagLead.constant*0.8;
    }
}



- (void)setModel:(id)model{
    DBZJ_Zqy_Info *info = model;
    self.info = model;
    if ([NSString stringIsNullOrEmptry:info.wechat_image].length!=0) {
           [self.personImag setDefultPlaceholderWithFullPath:info.wechat_image];
    }
    self.perName.text = info.wechat_name;
    self.cur_lev.text = info.level_name;
    self.codNum.text =   [NSString stringWithFormat:@"微信号: %@",info.kefu_wechat_account] ; 
    
    self.retPro.text = info.percent;
    self.leadName.text =  info.share_wechat_name;
    self.leadCode.text =  [NSString stringWithFormat:@"微信号: %@",info.share_wechat_account];
    [self.leadImage setDefultPlaceholderWithFullPath:info.share_wechat_image];
    
    
    if ([info.level isEqualToString:@"1"]) { //白银 2个
        self.pro1.hidden = YES;
        self.tuanZhangPro.text = @"黄金会员进度";
        self.shenQingAction.hidden = YES;
        
        [self.pro2_v1 addSubview:self.firstPro];
        self.firstPro.frame = self.pro2_v1.bounds;
        [self.firstPro setInfo:[self  first_proInfo]];
        
        [self.pro2_v2 addSubview:self.secPro];
        self.secPro.frame = self.pro2_v2.bounds;
        [self.secPro setInfo:[self order_proInfo]];
          self.height = self.tuanznhangImage.bottom;
    }else if ([info.level isEqualToString:@"2"]){//黄金 3个
        self.pro2.hidden = YES;
        self.tuanZhangPro.text = @"团长";
        if ( [self isSatisfyCondition]) {
            self.shenQingAction.backgroundColor = RGBColor(248, 218, 85);
            [self.shenQingAction setTitleColor:RGBColor(51, 51, 51) forState:UIControlStateNormal];
        }else{
            self.shenQingAction.backgroundColor = RGBColor(236, 236, 236);
            [self.shenQingAction setTitleColor:RGBColor(102, 102, 102) forState:UIControlStateNormal];
        }
        
        [self.pro1_v1 addSubview:self.firstPro];
        self.firstPro.frame = self.pro1_v1.bounds;
        [self.firstPro setInfo: [self  first_proInfo]];
        
        [self.pro1_V2 addSubview:self.secPro];
        self.secPro.frame = self.pro1_V2.bounds;
        [self.secPro setInfo: [self  relation_proInfo]];
        
        [self.pro1_v3 addSubview:self.thirdPro];
        self.thirdPro.frame = self.pro1_v3.bounds;
        [self.thirdPro setInfo: [self  order_proInfo]];
    }else{//团长
        self.leadH.constant = 0;
        self.leadProV.hidden = YES;
    }
  
    [self.yaoQingBtn sd_setImageWithURL:[NSURL URLWithString:info.yaoqing] forState:UIControlStateNormal];
    [self.moshiImageV setDefultPlaceholderWithFullPath:info.moshi];
    [self.teQuanImageV setDefultPlaceholderWithFullPath:info.tequan];
    if (!info.moshi.length &&!info.tequan.length) {
        self.height = self.contantTuanV.bottom;
    }else{
        self.height = self.tuanznhangImage.bottom;
    }
    [self layoutIfNeeded];//必须调用
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - private
- (DBZJ_Zqy_Info *)first_proInfo{
    DBZJ_Zqy_Info *first = [DBZJ_Zqy_Info new];
    first.curStr = [NSString stringWithFormat:@"当前直属用户%@人",self.info.share_number];
    if ((self.info.next_share_number.integerValue - self.info.share_number.integerValue) <=0) {
        first.totalStr = @"已完成";
    }else{
        first.totalStr = [NSString stringWithFormat:@"升级还需%zd人",(self.info.next_share_number.integerValue - self.info.share_number.integerValue) ];
    }
    
    first.progress = self.info.share_number.doubleValue /self.info.next_share_number.doubleValue ;
    return first;
}

- (DBZJ_Zqy_Info *)order_proInfo{
    DBZJ_Zqy_Info *sec = [DBZJ_Zqy_Info new];
    sec.curStr = [NSString stringWithFormat:@"当前有效单数%@单",self.info.order_number];
    if ((self.info.next_order_number.integerValue - self.info.order_number.integerValue)<=0) {
        sec.totalStr =  @"已完成";
    }else{
        sec.totalStr = [NSString stringWithFormat:@"升级还需%zd单",(self.info.next_order_number.integerValue - self.info.order_number.integerValue)];
    }
   
    sec.progress = self.info.order_number.doubleValue /self.info.next_order_number.doubleValue ;
    return sec;
}

- (DBZJ_Zqy_Info *)relation_proInfo{
    DBZJ_Zqy_Info *relation = [DBZJ_Zqy_Info new];
    relation.curStr = [NSString stringWithFormat:@"当前关联人数%@人",self.info.relation_number];
    if ((self.info.next_relation_number.integerValue - self.info.relation_number.integerValue )<=0) {
         relation.totalStr =  @"已完成";
    }else{
        relation.totalStr = [NSString stringWithFormat:@"升级还需%zd人",(self.info.next_relation_number.integerValue - self.info.relation_number.integerValue )];
    }
  
    relation.progress = self.info.relation_number.doubleValue /self.info.next_relation_number.doubleValue ;
    return relation;
}





- (BOOL)isSatisfyCondition{
    return  [self.info.share_number isEqualToString:self.info.next_share_number] &&[self.info.relation_number isEqualToString:self.info.next_relation_number]&&[self.info.order_number isEqualToString:self.info.next_order_number];
}

#pragma mark - action

- (IBAction)shenQingTuanZhang:(UIButton *)sender {
    if ([self isSatisfyCondition]) {
        [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/setUserLevel") parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
            NSLog(@" shenQingTuanZhang responseObject =%@",responseObject);
//            NSInteger code = [responseObject[@"code"] integerValue];
//            if (code == SucCode) {
//
//            }else{
//
//            }
             [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [YJProgressHUD showAlertTipsWithError:error];
        }];
    }else{
         [YJProgressHUD showMsgWithoutView:@"申请条件暂不满足!"];
    }
    
}
- (IBAction)gotoYaoqing:(UIButton *)sender {
    [self.viewController.navigationController pushViewController:[NewPeople_EnjoyContrl new] animated:YES];
}

- (IBAction)ziXunAction:(UIButton *)sender {
    if (self.info.kefu_wechat_account.length) {
        [UIPasteboard generalPasteboard].string = self.info.kefu_wechat_account;
        [YJProgressHUD showMsgWithoutView:@"复制成功"];
    }
}

- (IBAction)addHaoyou:(UIButton *)sender {
      NSLog(@"");
    if (self.info.share_wechat_account.length) {
        [UIPasteboard generalPasteboard].string = self.info.share_wechat_account;
         [YJProgressHUD showMsgWithoutView:@"复制成功"];
    }
    
}

#pragma mark - getter
- (DBZJ_Income_ProView *)firstPro{
    if (!_firstPro) {
        _firstPro = [DBZJ_Income_ProView viewFromXib];
    }
    return _firstPro;
}

- (DBZJ_Income_ProView *)secPro{
    if (!_secPro) {
        _secPro = [DBZJ_Income_ProView viewFromXib];
    }
    return _secPro;
}

- (DBZJ_Income_ProView *)thirdPro{
    if (!_thirdPro) {
        _thirdPro = [DBZJ_Income_ProView viewFromXib];
    }
    return _thirdPro;
}



@end
