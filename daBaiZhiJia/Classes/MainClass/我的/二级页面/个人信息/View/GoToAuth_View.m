//
//  GoToAuth_View.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/29.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoToAuth_View.h"
#import <AlibabaAuthSDK/albbsdk.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "PrersonInfoModel.h"

@interface GoToAuth_View ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;

@end
@implementation GoToAuth_View
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self, 7, UIColor.clearColor);
}

- (void)setAuthInfo{
    self.imageV.image = ZDBImage(@"img_authtaobao");
    self.title.text = @"请完成淘宝授权";
    self.content.text = @"淘宝授权后下单或者分享产品可以获得收益";
    [self.handleBtn setTitle:@"去授权" forState:UIControlStateNormal];
}

- (void)setFailInfo{
    self.imageV.image = ZDBImage(@"img_authtaobao");
    self.title.text = @"淘宝授权失败";
    self.content.text = @"淘宝授权失败将无法通过下单或分享产品获得收益";
    [self.handleBtn setTitle:@"重新授权" forState:UIControlStateNormal];
}

#pragma mark - action
- (IBAction)close:(UIButton *)sender {
    [self hideView];
}


- (IBAction)handleAction:(UIButton *)sender {
    [PrersonInfoModel queryTaboBaoAuthUrlWithCallBack:^(NSString *url) {
        [self authWithUrl:url];
    }];
}


#pragma mark - private
- (void)authWithUrl:(NSString *)url{
    self.superview.hidden = YES;
    NSLog(@"isLogin =%d", [ALBBSession sharedInstance].isLogin);
    if ([ALBBSession sharedInstance].isLogin) {
           [self openTbWithUrl:url];
    }else{
        [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
        [[ALBBSDK sharedInstance] auth:self.cur_vc successCallback:^(ALBBSession *session) {
            [self openTbWithUrl:url];
        } failureCallback:^(ALBBSession *session, NSError *error) {
            self.superview.hidden = NO;
            [self setFailInfo];
            NSLog(@"auth error =%@",error);
        }];
    }
   
}

- (void)openTbWithUrl:(NSString *)url{
    id<AlibcTradePage> page = [AlibcTradePageFactory page:url];
    
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeH5; //强制h5不能用淘宝打开
    showParam.backUrl = @"tbopen27546131://"; //tbopen27546131
    [[AlibcTradeSDK sharedInstance].tradeService show:self.navi_vc page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        [self hideView];
        NSLog(@"result %@",result);
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        //查询授权的状态 再判断
        [self queryPersonInfo];
        NSLog(@"error %@", error);
    }];
}

- (void)queryPersonInfo{
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/getuserinfo") parameters:@{@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
        NSLog(@"responseObject  %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSInteger  relation_id = [responseObject[@"data"][@"relation_id"] integerValue];
            //是否授权绑定过淘宝账号0否 不为0绑定过
            if (relation_id == 0) {
                self.superview.hidden = NO;
                [self setFailInfo];
            }else{
                [self hideView];
                [YJProgressHUD showMsgWithoutView:@"应用授权成功"];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [YJProgressHUD showAlertTipsWithError:error ];
    }];
}

@end
