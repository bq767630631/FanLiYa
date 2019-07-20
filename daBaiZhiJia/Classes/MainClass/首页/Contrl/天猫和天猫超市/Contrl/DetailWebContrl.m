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

#define naviToGoodDetail @"navigationToGoodDetail"
#define naviToToShare @"navigationToShare"
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
    self.url = url;
    self.title = title;
    self.para = para;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [SVProgressHUD show];
    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItem1Click:)];
    //间隙
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 10;
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_tm_close"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonIte2Click:)];
    self.navigationItem.leftBarButtonItems = @[barButtonItem1,fixedSpaceBarButtonItem,barButtonItem2];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = rightBar;
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
    self.title = webView.title;
    
    if ([urlStr containsString:@"item.htm"]) {
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
        NSString *sku = message.body ;
        GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:sku];
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

#pragma mark - getter
- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        //实例化对象
        configuration.userContentController = [WKUserContentController new];
        //调用JS方法
        [configuration.userContentController addScriptMessageHandler:self name:naviToGoodDetail];//
        [configuration.userContentController addScriptMessageHandler:self name:naviToToShare];//
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
