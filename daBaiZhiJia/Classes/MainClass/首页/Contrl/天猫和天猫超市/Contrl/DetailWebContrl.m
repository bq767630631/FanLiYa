//
//  DetailWebContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DetailWebContrl.h"
#import <WebKit/WebKit.h>
#import "GoodDetailContrl.h"
#import "TMcxAndTMgj_GoodBottomV.h"
#import "CreateShareContrl.h"
#import "CreateShare_Model.h"
#import "LoginContrl.h"
#import <AlipaySDK/AlipaySDK.h>
#import <JDSDK/KeplerApiManager.h>
#import "WXApi.h"
#import "NewPeo_VipShareV.h"
#import "NewPeople_EnjoyContrl.h"
#import "JSHAREService.h"


#define naviToGoodDetail @"navigationToGoodDetail"
#define naviToToShare @"navigationToShare"
#define AlyPayMethod @"alyPayMethod"
#define JumpToPtMethod @"jumpToPtMethod"
#define Jumpapplet @"jumpapplet"   //
#define jumToOnePointPurchaseShare @"jumpToOnePointPurchaseShare"

@interface DetailWebContrl ()<WKScriptMessageHandler,WKNavigationDelegate>
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSDictionary *para;

@property (nonatomic, strong) UILabel *topLb;

@property (nonatomic, strong) TMcxAndTMgj_GoodBottomV *bottomV;

@end

@implementation DetailWebContrl
- (instancetype)initWithUrl:(NSString *)url title:(nonnull NSString *)title para:(NSDictionary *)para{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.url = url;// @"http://app.dabaihong.com/app2019/demo.html";
    self.title = title;
    self.para = para;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [SVProgressHUD show];
    
    if (!self.isFromhomeTab) {
        [self setUpNaviGaItem];
    }
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)setUpNaviGaItem{
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItem1Click:)];
    //间隙
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 10;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_tm_close"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonIte2Click:)];
    self.navigationItem.leftBarButtonItems = @[barButtonItem1,fixedSpaceBarButtonItem,barButtonItem2];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar navBarBackGroundColor:RGBColor(33, 33, 33) image:nil isOpaque:NO];
}

#pragma mark -action
- (void)leftBarButtonItem1Click:(UIBarButtonItem *)barButtonItem {
    if (self.webView.canGoBack) {
          [self.webView goBack];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)leftBarButtonIte2Click:(UIBarButtonItem *)barButtonItem{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonItemClick:(UIBarButtonItem *)barButtonItem {
    [self.webView reload];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [SVProgressHUD popActivity];
    NSLog(@"absoluteString= %@",webView.URL.absoluteString);
    NSString *urlStr = webView.URL.absoluteString;
    NSLog(@"title =%@",webView.title);
    self.navigationItem.title = webView.title;
    if ([urlStr containsString:@"item.htm"] && self.isFromTaoBao) {
        self.topLb.hidden = NO;
        self.bottomV.hidden = NO;
        NSLog(@"详情");
        NSString *sku = @"";
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];

        // url中参数的key value
        for (NSURLQueryItem *item in urlComponents.queryItems) {
            if ([item.name isEqualToString:@"id"]) {
                sku = item.value;
                break;
            }
        }
        NSLog(@"sku= %@",sku);
        self.bottomV.sku  = sku;
        self.bottomV.checkBtn.hidden = NO;
    }else{
        self.topLb.hidden = YES;
        self.bottomV.hidden = YES;
    }

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [SVProgressHUD popActivity];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [SVProgressHUD popActivity];
}

#pragma mark -WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message.body %@",message.body);
    NSLog(@"message.name %@",message.name);
    if ([message.name isEqualToString:naviToGoodDetail]) {
        NSString *body = message.body;
        NSString *sku = @"";
        FLYPT_Type pt = FLYPT_Type_TM;
        if ([body containsString:@"&"]) {//sku=123&pt=1
            NSMutableDictionary *dict = [self dictParaWithMessage:message];
            sku = dict[@"sku"];
            pt = [dict[@"pt"] integerValue];
        }else{
             sku = message.body;
        }
        GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:sku];
        detail.pt = pt;
        [self.navigationController pushViewController:detail animated:YES];
    }
    if ([message.name isEqualToString:naviToToShare]) {
           NSString *sku = message.body ;
        if ([self judgeisLogin]) {
            [CreateShare_Model geneRateTaoKlWithSku:sku vc:self  navi_vc:self.navigationController  block:^(NSString *tkl, NSString *code, NSString *shorturl) {
                if (tkl) {
                    CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:sku];
                    [self.navigationController pushViewController:share animated:YES];
                }
            }];
        }
    }
    if ([message.name isEqualToString:AlyPayMethod]) {//阿里支付
        [self handleAlyPayWithMessage:message];
    }
    if ([message.name isEqualToString:JumpToPtMethod]) {//平台
        NSMutableDictionary *dict = [self dictParaWithMessage:message];
        NSString *pt = dict[@"pt"];
        NSString *url = dict[@"url"];
        [self handleJumptWith:pt.integerValue url:url];
    }
    if ([message.name isEqualToString:Jumpapplet]) {//小程序
        [self handleMiniProgramWithMessage:message];
    }
    if ([message.name isEqualToString:jumToOnePointPurchaseShare]) {
        [self handleOnePointPurChaseWithMessage:message];
    }
    
}
#pragma mark - private
- (NSMutableDictionary*)dictParaWithMessage:(WKScriptMessage *)message{
    NSString *bodys = message.body;
    NSArray *temp = [bodys componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *subStr in temp) {
        NSArray *temp2 = [subStr componentsSeparatedByString:@"="];
        [dict setObject:temp2.lastObject forKey:temp2.firstObject];
    }
    return dict;
}

- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0 &&token.length > 0) {
        return YES;
    }else{
        [self.navigationController pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
}

- (void)handleAlyPayWithMessage:(WKScriptMessage *)message {
    NSMutableDictionary *dict = [self dictParaWithMessage:message];
    NSString *body = dict[@"body"];
    NSString *total_amount = dict[@"total_amount"];
    NSString *subject = dict[@"subject"];
    NSString *pay_type = dict[@"pay_type"];
    NSString *out_trade_no = dict[@"out_trade_no"];
    NSDictionary *para = @{@"token":ToKen,@"body":body,@"total_amount":total_amount,@"subject":subject,@"pay_type":pay_type,@"out_trade_no":out_trade_no};
    NSLog(@"para %@",para);
    
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.pay/index") parameters:para success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code ==SucCode) {
            [self alipayWithOrderStr:responseObject[@"data"]];
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showAlertTipsWithError:error];
        NSLog(@"%@",error);
    }];
}

- (void)alipayWithOrderStr:(NSString *)orderStr {
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"aliPaySDK" callback:^(NSDictionary *resultDic) {//resultStatus = 6001; memo = 用户中途取消;
        NSLog(@"reslut = %@",resultDic);
        NSString *msg = @"";
        if ([resultDic[@"resultStatus"] isEqual:@"9000"]) {
            msg = @"支付成功";//支付成功推出当前界面
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        else if ([resultDic[@"resultStatus"] isEqual:@"8000"]) {
            msg = @"正在处理中";
        }
        else if ([resultDic[@"resultStatus"] isEqual:@"4000"]) {
            msg = @"订单支付失败";
        }
        else if ([resultDic[@"resultStatus"] isEqual:@"6001"]) {
            msg = @"您已中途取消支付";
        }
        else if ([resultDic[@"resultStatus"] isEqual:@"6002"]) {
            msg = @"您的网络连接出错";
        }
        else {
            msg = @"支付失败";
        }
        [YJProgressHUD showMsgWithoutView:msg];
        [self.webView reload];
        NSLog(@"currentThread =%@  %@",[NSThread currentThread], msg);
        
    }];
}

//处理跳转的平台
- (void)handleJumptWith:(NSInteger)pt url:(NSString*)url{//1、天猫 2、京东 3、拼多多 4、淘宝
    if (pt==FLYPT_Type_TM ||pt==FLYPT_Type_TB) {//tb
         [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:url navi:self.navigationController];
    }else if (pt==FLYPT_Type_Pdd){ //pdd
        BOOL can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"pinduoduo://"]];
        if (can) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }else{
            DetailWebContrl *web = [[DetailWebContrl alloc] initWithUrl:url title:nil para:nil];
            [self.navigationController pushViewController:web animated:YES];
        }
    }else if (pt==FLYPT_Type_JD){
        [[KeplerApiManager sharedKPService] openKeplerPageWithURL:url userInfo:nil failedCallback:^(NSInteger code, NSString *url) {
            //422:没有安装jd
            if (code==422) {
                DetailWebContrl *web = [[DetailWebContrl alloc] initWithUrl:url title:nil para:nil];
                [self.navigationController pushViewController:web animated:YES];
            }
        }];
    }
}

//处理小程序跳转
- (void)handleMiniProgramWithMessage:(WKScriptMessage *)message{
    NSMutableDictionary *dict = [self dictParaWithMessage:message];
    NSString *sku = dict[@"sku"];
    NSString *discount = dict[@"discount"];
    [PPNetworkHelper GET:URL_Add(@"/v.php/hd.jd/getCoupon") parameters:@{@"sku":sku,@"discount":discount,@"token":ToKen} success:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code ==SucCode) {
            NSDictionary *dictsec = responseObject[@"data"];
            NSString *userName = dictsec[@"username"];
            NSString *path = dictsec[@"url"];
            if (![WXApi isWXAppInstalled]) {
                return;
            }
            WXLaunchMiniProgramReq *launchMini = [WXLaunchMiniProgramReq object];
            launchMini.userName = userName;
            launchMini.path = path;
            launchMini.miniProgramType = WXMiniProgramTypeRelease;
            [WXApi sendReq:launchMini];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}

- (void)handleOnePointPurChaseWithMessage:(WKScriptMessage *)message{
    NSMutableDictionary *dict = [self dictParaWithMessage:message];
    NSString *urltype = dict[@"urltype"];
    [PPNetworkHelper GET:URL_Add(@"/v.php/hd.jd/getShareUrl") parameters:@{@"urltype":urltype,@"token":ToKen} success:^(id responseObject) {
          NSInteger code = [responseObject[@"code"] integerValue];
        if (code ==SucCode) {
            NSDictionary *dictSec = responseObject[@"data"];
            NSString *url = dictSec[@"url"];
            NSString *pic = dictSec[@"pic"];
            NSString *title = dictSec[@"title"];
            NSString *content = dictSec[@"content"];
            if (url.length==0||[url isEqualToString:@""]|| [url isKindOfClass:[NSNull class]]) {//进入邀请好友界面
                [self.navigationController pushViewController:[NewPeople_EnjoyContrl new] animated:YES];
            }else{
                NewPeo_VipShareV *shar = [NewPeo_VipShareV viewFromXib];
                shar.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                [shar showInWindowWithBackgoundTapDismissEnable:YES];
                shar.callBack = ^(NSUInteger x) {
                    JSHAREPlatform platform = JSHAREPlatformWechatSession;
                    if (x==1) {
                        platform = JSHAREPlatformWechatSession;
                    }else if (x==2){
                        platform = JSHAREPlatformWechatTimeLine;
                    }else if (x==3){
                        platform = JSHAREPlatformQQ;
                    }else if (x==4){
                        platform = JSHAREPlatformQzone;
                    }
                    JSHAREMessage *message = [JSHAREMessage message];
                    message.platform = platform;
                    message.mediaType = JSHARELink;
                    message.title = title;
                    message.text = content;
                    message.url = url;
                    
                    UIImage *temp = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pic]]];
                    NSData *tempData = UIImageJPEGRepresentation(temp, 0.1);
                    message.thumbnail = tempData;
                    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
                        NSLog(@"分享回调 state= %lu error =%@",(unsigned long)state, error);
                    }];
                };
                    
            }
        }
    } failure:^(NSError *error) {
         [YJProgressHUD showAlertTipsWithError:error];
    }];
    
}

#pragma mark - getter
- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        //实例化对象
        configuration.userContentController = [WKUserContentController new];
        //调用JS方法
        [configuration.userContentController addScriptMessageHandler:self name:naviToGoodDetail];//
        [configuration.userContentController addScriptMessageHandler:self name:naviToToShare];//
        [configuration.userContentController addScriptMessageHandler:self name:AlyPayMethod];//
        [configuration.userContentController addScriptMessageHandler:self name:JumpToPtMethod];//
        [configuration.userContentController addScriptMessageHandler:self name:Jumpapplet];//
        [configuration.userContentController addScriptMessageHandler:self name:jumToOnePointPurchaseShare];//
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
       
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [_webView loadRequest:req];
        _webView.scrollView.bounces = NO;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UILabel *)topLb{
    if (!_topLb) {
        _topLb = [[UILabel alloc] initWithFrame:CGRectMake(0, NavigationBarBottom(self.navigationController.navigationBar), SCREEN_WIDTH, 40)];
        _topLb.textAlignment = NSTextAlignmentCenter;
        _topLb.textColor = RGBColor(201, 83, 43);
        _topLb.backgroundColor =RGBColor(254, 251, 238);
        _topLb.font = [UIFont systemFontOfSize:14];
        _topLb.text = @"请点击页面底部 \"一键查询优惠券\" 按钮 ";
        [self.view addSubview:_topLb];
    }
    return _topLb;
}

- (TMcxAndTMgj_GoodBottomV *)bottomV{
    if (!_bottomV) {
        _bottomV = [TMcxAndTMgj_GoodBottomV viewFromXib];
        CGFloat heigt = 50;
        CGFloat orgy =  SCREEN_HEIGHT - heigt;
        if (IS_X_Xr_Xs_XsMax) {
            orgy -= Bottom_Safe_AreaH;
        }
        _bottomV.frame =CGRectMake(0, orgy, SCREEN_WIDTH, heigt);
        [self.view addSubview:_bottomV];
    }
    return _bottomV;
}

@end
