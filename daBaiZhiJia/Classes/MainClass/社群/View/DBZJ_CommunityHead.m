//
//  DBZJ_CommunityHead.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_CommunityHead.h"
@interface DBZJ_CommunityHead ()

@property (weak, nonatomic) IBOutlet UIButton *jingXuanBtn; //精选

@property (weak, nonatomic) IBOutlet UIButton *suCaiBtn;  //素材

@property (weak, nonatomic) IBOutlet UIButton *stuDyBtn; //商学院


@end
@implementation DBZJ_CommunityHead

- (void)awakeFromNib{
    [super awakeFromNib];
    [self xinPinAction:self.jingXuanBtn];
}


- (void)setBtnSelectedWithIndex:(NSInteger)index{
    if (index == 0) {
        [self xinPinAction:self.jingXuanBtn];
    }else if (index == 1){
        [self yingxiaoAction:self.suCaiBtn];
    }else{
        [self xinshouAction:self.stuDyBtn];
    }
}

#pragma mark - action
//精选
- (IBAction)xinPinAction:(UIButton *)sender {
    sender.selected = YES;
    self.suCaiBtn.selected = NO;
    self.stuDyBtn.selected = NO;
    [self setBordWithSender:sender];
    [self setBordWithSender:self.suCaiBtn];
    [self setBordWithSender:self.stuDyBtn];
    if (self.block) {
        self.block(0);
    }
}

//素材
- (IBAction)yingxiaoAction:(UIButton *)sender {
    sender.selected = YES;
    self.jingXuanBtn.selected = NO;
    self.stuDyBtn.selected = NO;
    [self setBordWithSender:sender];
    [self setBordWithSender:self.jingXuanBtn];
    [self setBordWithSender:self.stuDyBtn];
    if (self.block) {
        self.block(1);
    }
    
}

//商学院
- (IBAction)xinshouAction:(UIButton *)sender {
    sender.selected = YES;
    self.suCaiBtn.selected = NO;
    self.jingXuanBtn.selected = NO;
    [self setBordWithSender:sender];
    [self setBordWithSender:self.suCaiBtn];
    [self setBordWithSender:self.jingXuanBtn];
    if (self.block) {
        self.block(2);
    }
}

#pragma mark - private
- (void)setBordWithSender:(UIButton *)sender{
    if (sender.isSelected) {
        ViewBorderRadius(sender, sender.height*0.5, RGBColor(195, 152, 77));
    }else{
        ViewBorderRadius(sender, sender.height*0.5, UIColor.clearColor);
    }
}

@end
