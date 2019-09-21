//
//  PDDHotSaleMenu.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PDDHotSaleMenu.h"
@interface PDDHotSaleMenu ()
@property (weak, nonatomic) IBOutlet UIButton *saleBtn;
@property (weak, nonatomic) IBOutlet UIView *silder;
@property (weak, nonatomic) IBOutlet UIButton *shouYiBtn;

@property (nonatomic, assign) NSInteger  index;
@end

@implementation PDDHotSaleMenu
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.silder, 1, UIColor.clearColor);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.index ==1) {
          CGFloat left = SCREEN_WIDTH/4 - self.silder.width*0.5;
        if (self.silder.left==left) {
            return;
        }
        [UIView animateWithDuration:0.1 animations:^{
            self.silder.left = left;
        }];
    }else if(self.index==2){
        CGFloat left = SCREEN_WIDTH/4 *3 - self.silder.width*0.5;
        if (self.silder.left==left) {
            return;
        }
        [UIView animateWithDuration:0.1 animations:^{
            self.silder.left = left;
        }];
    }
}

- (IBAction)clickSale:(UIButton *)sender {
    sender.selected = YES;
    self.shouYiBtn.selected = NO;
    self.index = 1;
    [UIView animateWithDuration:0.1 animations:^{
        self.silder.left = SCREEN_WIDTH/4 - self.silder.width*0.5;
        if (self.block) {
            self.block(1);
        }
    }];
}




- (IBAction)clickShouyi:(UIButton *)sender {
    sender.selected = YES;
    self.saleBtn.selected = NO;
       self.index = 2;
    [UIView animateWithDuration:0.1 animations:^{
        self.silder.left = SCREEN_WIDTH/4 *3 - self.silder.width*0.5;
        if (self.block) {
            self.block(2);
        }
    }];
}

@end
