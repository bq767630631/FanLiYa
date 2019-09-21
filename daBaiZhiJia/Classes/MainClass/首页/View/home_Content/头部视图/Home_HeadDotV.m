//
//  Home_HeadDotV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_HeadDotV.h"
@interface Home_HeadDotV ()


@end
@implementation Home_HeadDotV

-(void)awakeFromNib{
    [super awakeFromNib];
    // rgb(255,208,153) rgb(51,51,51)
    ViewBorderRadius(self.leftDot, 3, UIColor.clearColor);
    ViewBorderRadius(self.rightDot, 3, UIColor.clearColor);
}


- (void)setDotColorWithLeft:(UIColor*)leftcolor right:(UIColor*)rightColor{
    [UIView animateWithDuration:0.1 animations:^{
        self.leftDot.backgroundColor = leftcolor;
        self.rightDot.backgroundColor = rightColor;
    }];
}
@end
