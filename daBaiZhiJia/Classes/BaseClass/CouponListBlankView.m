//
//  CouponListBlankView.m
//  MinPingZhangGui
//
//  Created by mc on 2019/1/8.
//  Copyright © 2019 包强. All rights reserved.
//

#import "CouponListBlankView.h"
@interface CouponListBlankView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnW;

@end

@implementation CouponListBlankView

- (void)awakeFromNib{
    [super awakeFromNib];
    _titleLb.font = [UIFont systemFontOfSize:13];
    self.hidden = YES; //默认隐藏
    _actionBtn.hidden = YES ; //默认隐藏
    ViewBorderRadius(_actionBtn, 5, ThemeColor);
}

- (void)setModel:(id)model{
    BlankViewInfo *info = model;
    self.imageView.image = info.image;
    self.titleLb.text = info.title;
    [self.actionBtn setTitle:info.btnTitle forState:UIControlStateNormal];
    self.actionBtn.hidden = !info.isShowActionBtn;
    if (info.btnW!=0) {
        self.btnW.constant = info.btnW;
    }
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}


@end


@implementation BlankViewInfo

+ (instancetype)infoWithNoticeNetError{
    BlankViewInfo *info = [BlankViewInfo new];
    info.title = @"网络错误";
    info.image = ZDBImage(@"img-blank-net");
    info.isShowActionBtn = YES;
    info.btnTitle = @"重新加载";
    return info;
}

@end
