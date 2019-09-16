//
//  NewPeo_ShareGoodCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_ShareGoodCell.h"
#import "SearchResulModel.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "LoginContrl.h"
#import "GoToAuth_View.h"
#import "NewPeo_DengjiV.h"
@interface NewPeo_ShareGoodCell ()
@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *shengyu;


@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UIButton *qiangGouBtn;

@property (weak, nonatomic) IBOutlet UILabel *xiaDanPrice;
@property (weak, nonatomic) IBOutlet UIView *buTieV;
@property (weak, nonatomic) IBOutlet UILabel *buTieLb;


//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buTieWd;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qiangGouTrail;

@property (nonatomic, strong) SearchResulGoodInfo *info;
@end
@implementation NewPeo_ShareGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    ViewBorderRadius(self.contentV, 5, UIColor.whiteColor);
    self.goodImage.layer.cornerRadius =  3.f;
    self.goodImage.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    self.goodImage.layer.borderWidth = 2.f;//宽度
    self.goodImage.layer.borderColor = RGBColor(246, 189, 57).CGColor;//颜色
    ViewBorderRadius(self.buTieV, self.buTieV.height*0.5, RGBColor(240, 18, 81));
    ViewBorderRadius(self.qiangGouBtn, self.qiangGouBtn.height*0.5, UIColor.clearColor);
//
//    ViewBorderRadius(self.buTie, self.buTie.height*0.5, UIColor.clearColor);
//    ViewBorderRadius(self.qiangGouBtn, self.qiangGouBtn.height*0.5, UIColor.clearColor);
    if (IS_iPhone5SE) {
       // self.qiangGouTrail.constant = 5;
    }
    
}


- (void)setModel:(id)model{
    self.info = model;
    [self.goodImage setDefultPlaceholderWithFullPath:self.info.pic];
    self.title.text  = self.info.title;
    if (self.info.tlj_number.integerValue > 0) {
         self.shengyu.text = [NSString stringWithFormat:@"剩余%@件",self.info.tlj_number];
    }else{
        self.shengyu.text = @"已抢完";
    }
   
    self.price.text  = self.info.tlj;
    self.marketPrice.attributedText = [self marketPriceAttr:[NSString stringWithFormat:@" ￥%@",self.info.market_price]];
    self.xiaDanPrice.text = [NSString stringWithFormat:@"下单价 ￥%@",self.info.price];
    self.buTieLb.text = [NSString stringWithFormat:@"下单手动登记平台补贴￥%@",self.info.price];
    
    if (self.info.countTime==0) {
        self.qiangGouBtn.userInteractionEnabled =NO;
        [self.qiangGouBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [self.qiangGouBtn setBackgroundColor:RGBColor(204, 204, 204)];
        [self.qiangGouBtn setTitle:@"已经结束" forState:UIControlStateNormal];
    }else{
        self.qiangGouBtn.userInteractionEnabled =YES;
        [self.qiangGouBtn setBackgroundImage:ZDBImage(@"image_new_qianggou") forState:UIControlStateNormal];
        [self.qiangGouBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    }
    
}


- (IBAction)qiangGouAction:(UIButton *)sender {
    if ([self judgeisLogin]) {
        [self openTbWithUrl:self.info.url];
        return;
        
       /* NSDictionary *dict = @{@"sku":self.info.sku,@"token":ToKen,@"v":APP_Version};
        @weakify(self);
        [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getCouponFree") parameters:dict success:^(id responseObject) {
            @strongify(self);
            NSLog(@"领取优惠券responseObject  %@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == SucCode) {
                NSString *url = responseObject[@"data"];
                if ([url containsString:@"http"]) {
                    [self openTbWithUrl:url];
                }else{
                    [UIPasteboard generalPasteboard].string = url;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"taobao://m.taobao.com/"]];
                }
            }
            if (code == UnauthCode) {
                GoToAuth_View *auth = [GoToAuth_View viewFromXib];
                [auth setAuthInfo];
                auth.cur_vc = self.viewController;
                auth.navi_vc = self.viewController.navigationController;
                [auth showInWindowWithBackgoundTapDismissEnable:NO];
            }
        } failure:^(NSError *error) {
            [YJProgressHUD showAlertTipsWithError:error];
        }];*/
    }
}

- (IBAction)dengJiAction:(UIButton *)sender {
    NewPeo_DengjiV *dengji = [NewPeo_DengjiV viewFromXib];
    [dengji show];
}



#pragma mark - private
- (void)openTbWithUrl:(NSString *)url{
     [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:url navi:self.viewController.navigationController];
}

- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0 &&token.length > 0) {
        return YES;
    }else{
        [self.viewController.navigationController pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
}

- (NSMutableAttributedString*)marketPriceAttr:(NSString*)str1 {
    NSMutableAttributedString* mustr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str1]];
    [mustr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, str1.length)];
    [mustr addAttribute:NSStrikethroughColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(0, str1.length)];
    [mustr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, str1.length)];
    return mustr;
}
@end
