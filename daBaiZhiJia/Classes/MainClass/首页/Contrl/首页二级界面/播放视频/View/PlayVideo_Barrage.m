//
//  PlayVideo_Barrage.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/29.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PlayVideo_Barrage.h"
#import "GoodDetailModel.h"

@interface PlayVideo_Barrage ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *action;

@end
@implementation PlayVideo_Barrage
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.view1, self.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.view2, self.height*0.5, UIColor.clearColor);
}

- (void)setModel:(id)model{
    GoodDetailViewInfo *info = model;
    self.name.text = info.name;
    self.action.text = info.title;
    [self layoutSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.width = self.view2.right;
}

#pragma mark - public Method
- (void)startAnimation{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.centerY -= 12;
        self.alpha = 0.4;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)disMis{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.centerY += 12;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

@end
