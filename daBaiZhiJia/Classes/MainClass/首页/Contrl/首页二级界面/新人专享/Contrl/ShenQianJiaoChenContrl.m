//
//  ShenQianJiaoChenContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ShenQianJiaoChenContrl.h"

@interface ShenQianJiaoChenContrl ()
@property (nonatomic, strong) UIScrollView *scroView;
@end

@implementation ShenQianJiaoChenContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"省钱教程";
    [self.view addSubview:self.scroView];
}

#pragma mark - getter
- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat orgy = NavigationBarBottom(self.navigationController.navigationBar);
        _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, orgy, SCREEN_WIDTH, SCREEN_HEIGHT - orgy)];
        _scroView.showsVerticalScrollIndicator = NO;
        UIImage *image = ZDBImage(@"jiaocheng_pic");
        UIImageView *tempImgeV = [[UIImageView alloc] initWithImage:image];
        tempImgeV.frame = CGRectMake(0, 0, SCREEN_WIDTH, image.size.height);
        [_scroView addSubview:tempImgeV];
        _scroView.contentSize = CGSizeMake(0, image.size.height);
    }
    return _scroView;
}

@end
