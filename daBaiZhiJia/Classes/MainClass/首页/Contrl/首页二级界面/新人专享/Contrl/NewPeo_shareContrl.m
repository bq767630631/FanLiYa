//
//  NewPeo_shareContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_shareContrl.h"
#import "NewPeo_shareContentV.h"
#import "NewPeo_shareModel.h"
#import "NewPeople_EnjoyContrl.h"
#import "JSHAREService.h"
#import "LoginContrl.h"
#import "UIImageView+WebCache.h"
#import "NewPeo_VipShareV.h"

@interface NewPeo_shareContrl ()
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) NewPeo_shareContentV *contentV;
@property (nonatomic, strong) NewPeo_shareRuleInfo *ruleInfo;
@end

@implementation NewPeo_shareContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新人专享";
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_retBlack"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.leftBarButtonItem = leftBar;

    [self.view addSubview:self.scroView];
    [self queryData];
    [self initRightBarButtonWithImage:@"image_newpeo_share"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(countDownEnd) name:NewPeo_CountdownNotifation object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBColor(38, 38, 38) ,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
    [self.navigationController.navigationBar navBarBackGroundColor:UIColor.whiteColor image:nil isOpaque:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor ,NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
//    [self.contentV.timeV.timer invalidate];
//    self.contentV.timeV.timer = nil;
}

- (void)dealloc{
    NSLog(@"");
}

- (void)countDownEnd{
    [self queryData];
}

- (void)onTapRightBarButton{
    if (![self judgeisLogin]) {
        return;
    }
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
        message.title = self.ruleInfo.title;
        message.text = self.ruleInfo.content;
        message.url = self.ruleInfo.url;
        
        UIImage *temp = [UIImage imageWithData:self.ruleInfo.imageData];
        NSData *tempData = UIImageJPEGRepresentation(temp, 0.1);
        message.thumbnail = tempData;
        [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
            NSLog(@"分享回调 state= %lu error =%@",(unsigned long)state, error);
        }];
    };
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

- (void)queryData{
    [NewPeo_shareModel queryNewPeoGoodWithBlock:^(NSMutableArray *goodArr, NSInteger time, NewPeo_shareRuleInfo *rule,NSMutableArray *tlj_list ,NSError *error) {
        if (goodArr) {
            self.ruleInfo = rule;
            [self.contentV setInfoWith:goodArr time:time rule:rule tljList:tlj_list];
            self.scroView.contentSize = CGSizeMake(0, self.contentV.height + 20);
         self.ruleInfo.imageData =  [NSData dataWithContentsOfURL:[NSURL URLWithString:rule.logo]];
        }
    }];
}


- (void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat height = SCREEN_HEIGHT ;
        if (IS_X_Xr_Xs_XsMax) {
            height -= Bottom_Safe_AreaH ;
        }
        _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [_scroView addSubview:self.contentV];
        _scroView.contentSize = CGSizeMake(0,2000);
        _scroView.showsVerticalScrollIndicator = NO;
        _scroView.backgroundColor = RGBColor(235, 24, 42);
    }
    return _scroView;
}

- (NewPeo_shareContentV *)contentV{
    if (!_contentV) {
        _contentV = [NewPeo_shareContentV viewFromXib];
        _contentV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 896);
    }
    return _contentV;
}

@end
