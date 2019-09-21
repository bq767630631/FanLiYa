//
//  HomePage_NewPersonPopV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/8/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomePage_NewPersonPopV.h"
#import "NewPeo_shareContrl.h"
#import "GoodDetailContrl.h"
#import "DetailWebContrl.h"
#import "HandelTaoBaoTradeManager.h"
#import "UIButton+WebCache.h"
@implementation HomePage_NewPersonPopV
- (void)awakeFromNib{
    [super awakeFromNib];
     self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
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

- (void)setInfo:(HomePage_bg_bannernfo *)info{
    _info = info;
    [self.bgBtn sd_setImageWithURL:[NSURL URLWithString:info.img] forState:UIControlStateNormal];
}

#pragma mark -action
- (IBAction)jumpAction:(UIButton *)sender {
    [self disMiss];
    [self handleAction];
}

- (IBAction)disMis:(UIButton *)sender {
    [self disMiss];
}

#pragma mark - private
- (void)handleAction{
    if (self.info.url_type ==1) {
        GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:self.info.url];
        detail.pt = self.info.pt;
        [self.navi pushViewController:detail animated:YES];
    }else if (self.info.url_type ==2||self.info.url_type ==3){
        DetailWebContrl *detailweb = [[DetailWebContrl alloc] initWithUrl:[NSString stringWithFormat:@"%@&token=%@",self.info.url,ToKen] title:@"" para:nil];
        [self.navi pushViewController:detailweb animated:YES];
    }else if (self.info.url_type==4){
        [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:self.info.url navi:self.navi];
    }else if (self.info.url_type==5){ //NewPeo_shareContrl
        [self.navi pushViewController:[NewPeo_shareContrl new] animated:YES];
    }
}

@end
