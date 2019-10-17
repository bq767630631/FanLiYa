//
//  AppGuideV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/15.
//  Copyright © 2019 包强. All rights reserved.
//

#import "AppGuideV.h"
#import "AppGuidePlayV.h"
@interface AppGuideV ()
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *goToHome;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSec_Top;
@end
@implementation AppGuideV
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(_videoBtn, 20, UIColor.clearColor);
    ViewBorderRadius(_goToHome, 20, UIColor.clearColor);
    if (IS_iPhone5SE) {
        self.imageSec_Top.constant = 30;
    }
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self checkvideoBtn:nil];
    }];
    [self addGestureRecognizer:tap];
}

- (IBAction)checkvideoBtn:(UIButton *)sender {
    NSLog(@"");
     [self removeFromSuperview];
    UIWindow *win = [UIApplication sharedApplication].windows.lastObject;
    AppGuidePlayV *playV = [AppGuidePlayV viewFromXib];
    playV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [win addSubview:playV];
    [playV setUpAudioPlayer];
}

- (IBAction)goToHome:(UIButton *)sender {
    NSLog(@"");
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:GuideViewLoadFinishNotification object:nil];
}


@end
