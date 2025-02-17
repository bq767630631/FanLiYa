//
//  CreateShareContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "CreateShareContrl.h"
#import "CreateshareBottom.h"
#import "CreateshareContent.h"
#import "CreateShare_Model.h"
#import "PrersonInfoModel.h"
#define Bottom_H 130.f

#define  Post_Image_Key   @"postImage"
#define  DetailInfo_Key   @"detailinfo.shareContent_H"
@interface CreateShareContrl ()
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) CreateshareContent *contentView;
@property (nonatomic, strong) CreateshareBottom *bottom;
@property (nonatomic, copy) NSString *sku;
@property (nonatomic, strong) GoodDetailInfo *detailinfo;

@end

@implementation CreateShareContrl

- (instancetype)initWithSku:(NSString *)sku{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.sku = sku;
    return self;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建分享";
    self.view.backgroundColor= RGBColor(245, 245, 245);
    
    [self.view addSubview:self.scroView];
    [self.view addSubview:self.bottom];
    
    [CreateShare_Model queryDetailInfoWithSku:self.sku pt:self.pt  Blcok:^(GoodDetailInfo *info, NSError *error) {
        if (info) {
            self.detailinfo = info;
            if (self.pt == FLYPT_Type_TB || self.pt == FLYPT_Type_TM) {
                 [self queryTkl];
            }else  {
                [self queryPddAndJd];
            }
        }
    }];
    
    [self.contentView addObserver:self forKeyPath:Post_Image_Key options:NSKeyValueObservingOptionNew context:nil];
   [self addObserver:self forKeyPath:DetailInfo_Key options:NSKeyValueObservingOptionNew context:nil];
}

- (void)queryTkl{
    [CreateShare_Model geneRateTaoKlWithSku:self.sku vc:self navi_vc:self.navigationController  block:^(NSString *tkl, NSString*code,NSString*shorturl) {
        self.detailinfo.tkl = tkl;
        self.detailinfo.code = code;
        self.detailinfo.shorturl = shorturl;
        [CreateShare_Model geneRateWenanWithDetail:self.detailinfo isAdd:YES isDown:NO isRegisCode:YES isTkl:NO pt:self.pt];
        [self.contentView setInfoWithModel:self.detailinfo];
    }];
}

- (void)queryPddAndJd{
    [CreateShare_Model pddAndJdGetYouhuiQuanWithsku:self.sku pt:self.pt couponUrl:self.detailinfo.couponUrl  CallBack:^(NSDictionary *dict) {
        if (dict) {
            self.detailinfo.shorturl = dict[@"url"];
            self.detailinfo.downurl = dict[@"downurl"];
            self.detailinfo.code     = dict[@"code"];
            [CreateShare_Model geneRateWenanWithDetail:self.detailinfo isAdd:YES isDown:NO isRegisCode:YES isTkl:NO pt:self.pt];
            [self.contentView setInfoWithModel:self.detailinfo];
        }
    }];
}

- (void)dealloc{
    [self.contentView removeObserver:self forKeyPath:Post_Image_Key];
    [self removeObserver:self forKeyPath:DetailInfo_Key];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:Post_Image_Key]) {
        UIImage *image = change[@"new"];
        self.bottom.postImage = image;
    }
    
    if ([keyPath isEqualToString:DetailInfo_Key]) {
        CGFloat het = [change[@"new"] floatValue];
        self.scroView.contentSize = CGSizeMake(0, het);
        self.contentView.height = het;
    }
}

#pragma mark - getter
- (UIScrollView *)scroView{
    if (!_scroView) {
        
         CGFloat orgy = NavigationBarBottom(self.navigationController.navigationBar);
         CGFloat height = SCREEN_HEIGHT - orgy - Bottom_H ;
        _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, orgy, SCREEN_WIDTH,height)];
        [_scroView addSubview:self.contentView];
        _scroView.showsVerticalScrollIndicator = NO;
        NSLog(@"_scroView.frame =%@", NSStringFromCGRect(_scroView.frame));
    }
    return  _scroView;
}

- (CreateshareContent *)contentView{
    if (!_contentView) {
        _contentView = [CreateshareContent viewFromXib];
        CGFloat height = SCREEN_HEIGHT - NavigationBarBottom(self.navigationController.navigationBar) - Bottom_H;
       
        if (IS_X_Xr_Xs_XsMax) {
            height -=  Bottom_Safe_AreaH ;
        }
        _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        _contentView.pt = self.pt;
    }
    return _contentView;
}

- (CreateshareBottom *)bottom{
    if (!_bottom) {
        CGFloat orgy = 0;
        if (IS_X_Xr_Xs_XsMax) {
            orgy = SCREEN_HEIGHT - Bottom_H - Bottom_Safe_AreaH;
        }else{
            orgy = SCREEN_HEIGHT - Bottom_H;
        }
        _bottom = [CreateshareBottom viewFromXib];
        _bottom.frame = CGRectMake(0, orgy, SCREEN_WIDTH, Bottom_H);
        _bottom.contentV = self.contentView;
    }
    return _bottom;
}

@end
