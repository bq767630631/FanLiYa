//
//  Brand_ShowDetailCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Brand_ShowDetailCell.h"
#import "HomePage_Model.h"
#import "LoginContrl.h"
#import "GoToAuth_View.h"

@interface Brand_ShowDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UIButton *linQuanBtn;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic, strong) SearchResulGoodInfo *info;
@end
@implementation Brand_ShowDetailCell
-(void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.image, 3, UIColor.clearColor);
    ViewBorderRadius(self.linQuanBtn, self.linQuanBtn.height*0.5, UIColor.clearColor);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setInfoWithModel:(id)model{
    SearchResulGoodInfo *info = model;
    self.info = model;
    [self.image setDefultPlaceholderWithFullPath:info.pic];
    self.title.text = info.title;
    [self.quanBtn setTitle:[NSString stringWithFormat:@"¥%@",info.discount] forState:UIControlStateNormal];
    self.price.text = [NSString stringWithFormat:@"¥%@",info.price];
}

- (IBAction)action:(UIButton *)sender {
    if ([self judgeisLogin]) {
        NSDictionary *dict = @{@"sku":self.info.sku,@"token":ToKen,@"v":APP_Version};
        @weakify(self);
        [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getCoupon") parameters:dict success:^(id responseObject) {
            @strongify(self);
            NSLog(@"领取优惠券responseObject  %@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == SucCode) {
                NSString *url = responseObject[@"data"];
                if ([url containsString:@"http"]) {//url
                     [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:url navi:self.viewController.navigationController];
                }else{//tkl
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
        }];
    };
}

#pragma mark - private
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
