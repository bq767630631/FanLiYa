//
//  NewNoviceGuideContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewNoviceGuideContrl.h"
#import "NewNoviceGuideFirst.h"
#import "NewNoviceGuideSec.h"
@interface NewNoviceGuideContrl ()
@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) NewNoviceGuideFirst *first;
@property (nonatomic, strong) NewNoviceGuideSec *sec;
@end

@implementation NewNoviceGuideContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scroView];
    self.title = @"双十一攻略";
    [self queryData];
}

- (void)queryData{
    [PPNetworkHelper GET:URL_Add(@"/v.php/index.index/getEleven") parameters:@{@"token":ToKen} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            self.first.url = responseObject[@"data"][@"url"];
            self.sec.content = responseObject[@"data"][@"content"];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}

#pragma mark - getter
- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat orgy = NavigationBarBottom(self.navigationController.navigationBar);
        _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, orgy, SCREEN_WIDTH, SCREEN_HEIGHT - orgy)];
        _scroView.showsVerticalScrollIndicator = NO;
        [_scroView addSubview:self.first];
        [_scroView addSubview:self.sec];
        _scroView.contentSize = CGSizeMake(0, self.sec.bottom);
    }
    return _scroView;
}


- (NewNoviceGuideFirst *)first{
    if (!_first) {
        _first = [NewNoviceGuideFirst viewFromXib];
         UIImage *image = ZDBImage(@"doubleele_001");
        _first.frame = CGRectMake(0, 0, SCREEN_WIDTH, image.size.height);
    }
    return _first;
}

- (NewNoviceGuideSec *)sec{
    if (!_sec) {
        _sec = [NewNoviceGuideSec viewFromXib];
        UIImage *image = ZDBImage(@"doubleele_002");
        _sec.frame = CGRectMake(0, _first.bottom,SCREEN_WIDTH ,image.size.height);
    }
    return _sec;
}

@end
