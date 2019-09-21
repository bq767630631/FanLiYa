//
//  HomePage_UpdateV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomePage_UpdateV.h"
#define appStoreUrl @"https://apps.apple.com/cn/app/id1459203610"
@interface HomePage_UpdateV ()
@property (weak, nonatomic) IBOutlet UIButton *shaoHouBtn;
@property (weak, nonatomic) IBOutlet UIButton *gengXinBtn;

@end
@implementation HomePage_UpdateV

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    ViewBorderRadius(self.shaoHouBtn, 17, RGBColor(51, 51, 51));
    ViewBorderRadius(self.gengXinBtn, 17,UIColor.clearColor);
}

- (void)show{
    UIWindow *keyW = [UIApplication sharedApplication].keyWindow;
    [keyW addSubview:self];
    self.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)disMiss{
    self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (IBAction)shaoHouAction:(UIButton *)sender {
    [self disMiss];
}

- (IBAction)genXinAction:(UIButton *)sender {
    [self disMiss];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
}


@end
