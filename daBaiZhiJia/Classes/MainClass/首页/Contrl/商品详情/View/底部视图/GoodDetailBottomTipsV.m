//
//  GoodDetailBottomTipsV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailBottomTipsV.h"
@interface GoodDetailBottomTipsV ()

@property (weak, nonatomic) IBOutlet UILabel *tipsLb;
@end
@implementation GoodDetailBottomTipsV

- (void)setDetailInfo:(GoodDetailInfo *)detailInfo{
    _detailInfo = detailInfo;
     self.tipsLb.text= [NSString stringWithFormat:@"分享好友下单还能赚%@",detailInfo.share_profit];
}

- (IBAction)closeAction:(UIButton *)sender {
    self.hidden = YES;
}


@end
