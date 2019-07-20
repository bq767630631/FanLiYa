//
//  GoodDetail_Barrage.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/15.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetail_Barrage.h"
@interface GoodDetail_Barrage ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWd;


@property (nonatomic, copy) NSString *str;
@end
@implementation GoodDetail_Barrage
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self, self.height*0.5, UIColor.clearColor);
}

- (void)setModel:(id)model{
    self.title.text = model;
    self.str = model;
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat wd = [self.str textWidthWithFont:self.title.font maxHeight:  self.title.height];
    self.width = wd + self.title.left*2;
    self.titleWd.constant = wd + 5;
//    NSLog(@"str =%@",self.str);
//    NSLog(@"wd =%.f",wd);
//    NSLog(@"self.width =%.f", self.width);
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
