//
//  NewPeo_ShareGoodSecCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/12.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_ShareGoodSecCell.h"
#import "SearchResulModel.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "LoginContrl.h"
#import "GoToAuth_View.h"

@interface NewPeo_ShareGoodSecCell ()
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *markt_price;

@property (weak, nonatomic) IBOutlet UIView *butieV;

@property (weak, nonatomic) IBOutlet UILabel *buTieLb;

@property (weak, nonatomic) IBOutlet UIButton *qiangGouBtn;

@property (nonatomic, strong) SearchResulGoodInfo *info;
@end
@implementation NewPeo_ShareGoodSecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    ViewBorderRadius(self.contentV, 5, UIColor.whiteColor);
    self.imageV.layer.cornerRadius =  3.f;
    self.imageV.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    self.imageV.layer.borderWidth = 2.f;//宽度
    self.imageV.layer.borderColor = RGBColor(246, 189, 57).CGColor;//颜色
    ViewBorderRadius(self.butieV, self.butieV.height*0.5, RGBColor(240, 18, 81));
    ViewBorderRadius(self.qiangGouBtn, self.qiangGouBtn.height*0.5, UIColor.clearColor);
}

- (void)setModel:(id)model{
    self.info = model;
    [self.imageV setDefultPlaceholderWithFullPath:self.info.pic];
    self.name.text  = self.info.title;
    self.price.text = self.info.price;
    self.markt_price.attributedText = [self marketPriceAttr:[NSString stringWithFormat:@" ￥%@",self.info.market_price]];
    self.buTieLb.text = [NSString stringWithFormat:@"下单手自动登记平台补贴￥%@",self.info.price];
    
    if (self.info.countTime==0) {
        self.qiangGouBtn.userInteractionEnabled =NO;
        [self.qiangGouBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [self.qiangGouBtn setBackgroundColor:RGBColor(204, 204, 204)];
        [self.qiangGouBtn setTitle:@"已经结束" forState:UIControlStateNormal];
    }else{
        self.qiangGouBtn.userInteractionEnabled =YES;
        [self.qiangGouBtn setBackgroundImage:ZDBImage(@"image_new_dengji") forState:UIControlStateNormal];
        [self.qiangGouBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    }
}

- (IBAction)buyAction:(UIButton *)sender {
    if ([self judgeisLogin]) {
        NSDictionary *dict = @{@"sku":self.info.sku,@"token":ToKen,@"v":APP_Version};
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
             
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
         } failure:^(NSError *error) {
             [YJProgressHUD showAlertTipsWithError:error];
         }] ;
    }
}

#pragma mark - getter
- (NSMutableAttributedString*)marketPriceAttr:(NSString*)str1 {
    NSMutableAttributedString* mustr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str1]];
    [mustr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, str1.length)];
    [mustr addAttribute:NSStrikethroughColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(0, str1.length)];
    [mustr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, str1.length)];
    return mustr;
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

- (void)openTbWithUrl:(NSString *)url{
    [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:url navi:self.viewController.navigationController];
}

@end
