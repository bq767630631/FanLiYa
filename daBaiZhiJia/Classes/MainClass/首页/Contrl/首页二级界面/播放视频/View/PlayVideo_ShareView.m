//
//  PlayVideo_ShareView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PlayVideo_ShareView.h"

@interface PlayVideo_ShareView ()
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (nonatomic, copy) NSString *str;
@property (weak, nonatomic) IBOutlet UIButton *copysBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancleBtnTop;

@end
@implementation PlayVideo_ShareView

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self, 5, UIColor.clearColor);
}


- (void)setContentStr:(NSString *)content{
    self.str = content;
    self.content.text = content;
    CGFloat contentH = [content textHeightWithFont:[UIFont systemFontOfSize:12] maxWidth:190];
    self.height = self.content.top + contentH + 25 + 37 ;
    //self.height = self.cancleBtnTop.constant + self.copysBtn.height;
    //NSLog(@"cancleBtnTop.constant %.f",self.cancleBtnTop.constant);
}

- (IBAction)cancleAction:(UIButton *)sender {
    [self hideView];
}

- (IBAction)copyAction:(UIButton *)sender {
      [self hideView];
    [YJProgressHUD showMsgWithoutView:@"文案已复制"];
    [UIPasteboard generalPasteboard].string = self.str;
}

@end
