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

@interface NewPeo_ShareGoodCell ()
@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *buTie;
@property (weak, nonatomic) IBOutlet UIButton *qiangGouBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buTieWd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qiangGouTrail;

@property (nonatomic, strong) SearchResulGoodInfo *info;
@end
@implementation NewPeo_ShareGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.contentV, 5, UIColor.whiteColor);
    self.goodImage.layer.cornerRadius =  3.f;
    self.goodImage.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    self.goodImage.layer.borderWidth = 2.f;//宽度
    self.goodImage.layer.borderColor = RGBColor(246, 189, 57).CGColor;//颜色
    
    ViewBorderRadius(self.buTie, self.buTie.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.qiangGouBtn, self.qiangGouBtn.height*0.5, UIColor.clearColor);
    if (IS_iPhone5SE) {
        self.qiangGouTrail.constant = 5;
    }
    
}


- (void)setModel:(id)model{
    self.info = model;
    [self.goodImage setDefultPlaceholderWithFullPath:self.info.pic];
    self.title.text  = self.info.title;
    self.price.text  = self.info.price;
    if (self.info.countTime == 0) {
        self.qiangGouBtn.userInteractionEnabled = NO;
        self.qiangGouBtn.backgroundColor = UIColor.grayColor;
    }
    self.buTie.text = [NSString stringWithFormat:@"平台补贴¥ %@",self.info.price];
  CGFloat  wd = [self.buTie.text textWidthWithFont:self.buTie.font maxHeight:22];
    self.buTieWd.constant =  wd + 18 ;
}


- (IBAction)qiangGouAction:(UIButton *)sender {
    if ([self judgeisLogin]) {
        NSDictionary *dict = @{@"sku":self.info.sku,@"token":ToKen};
        @weakify(self);
        [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getCouponFree") parameters:dict success:^(id responseObject) {
            @strongify(self);
            NSLog(@"领取优惠券responseObject  %@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == SucCode) {
                NSString *url = responseObject[@"data"];
                [self openTbWithUrl:url];
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
        }];
    }
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
@end
