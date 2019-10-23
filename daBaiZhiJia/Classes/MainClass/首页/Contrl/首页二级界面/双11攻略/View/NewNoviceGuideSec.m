//
//  NewNoviceGuideSec.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewNoviceGuideSec.h"

@implementation NewNoviceGuideSec


- (IBAction)action:(UIButton *)sender {
    NSLog(@"");
    if (self.content) {
        [UIPasteboard generalPasteboard].string = self.content;
        [YJProgressHUD showMsgWithoutView:@"复制成功，分享好友双十一拿收益"];
    }
}

@end
