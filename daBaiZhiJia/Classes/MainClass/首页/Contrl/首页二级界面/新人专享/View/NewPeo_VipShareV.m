//
//  NewPeo_VipShareV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_VipShareV.h"

@implementation NewPeo_VipShareV
- (void)awakeFromNib{
    [super awakeFromNib];
    self.maskV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}

- (IBAction)action:(UIButton *)sender {
    [self hideView];
    if (self.callBack) {
        self.callBack(sender.tag);
    }
}

- (IBAction)closeAction:(UIButton *)sender {
      [self hideView];
}

@end
