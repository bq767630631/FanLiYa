//
//  GoodDetailSegment.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailSegment.h"
@interface GoodDetailSegment ()
@property (weak, nonatomic) IBOutlet UIButton *baoBei;
@property (weak, nonatomic) IBOutlet UIButton *detail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line_cenX;

@property (weak, nonatomic) IBOutlet UIButton *tuijian;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
@implementation GoodDetailSegment
- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setSegmentToDetailToBaobei{
    [UIView animateWithDuration:0.2 animations:^{
        self.line.frame = CGRectMake(self.baoBei.left, self.baoBei.bottom+1, self.line.width, 2);
        self.detail.selected = NO;
        self.tuijian.selected = NO;
    }];
}

- (void)setSegmentToDetail{
    if (self.line.left!=self.detail.left) {
        [UIView animateWithDuration:0.2 animations:^{
            self.line.frame = CGRectMake(self.detail.left, self.detail.bottom + 1, self.line.width, 2);
            self.detail.selected = YES;
            self.baoBei.selected = NO;
            self.tuijian.selected = NO;
        }];
    }
   
}

- (void)setSegmentToTuiJian{
    if (self.line.left!=self.tuijian.left) {
          self.selfIsClick = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.line.frame = CGRectMake(self.tuijian.left, self.tuijian.bottom + 1, self.line.width, 2);
            self.detail.selected = NO;
            self.baoBei.selected = NO;
            self.tuijian.selected = YES;
        }];
    }
}



#pragma mark - action
- (IBAction)baobeiAction:(UIButton *)sender {
     sender.selected = YES;
    self.selfIsClick = YES;
    self.detail.selected = NO;
    self.tuijian.selected = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.line.frame = CGRectMake(sender.left, sender.bottom+1, self.line.width, 2);
//        self.line.centerX = sender.centerX;
       
    }];
    if (self.typeBlock) {
        self.typeBlock(0);
    }
}


- (IBAction)detailAction:(UIButton *)sender {
    sender.selected = YES;
    self.selfIsClick = YES;
    self.baoBei.selected = NO;
    self.tuijian.selected = NO;
    [UIView animateWithDuration:0.2 animations:^{
          self.line.frame = CGRectMake(sender.left, sender.bottom+1, self.line.width, 2);
    }];
    if (self.typeBlock) {
        self.typeBlock(1);
    }
}

- (IBAction)tuijianAction:(UIButton *)sender {
     sender.selected = YES;
    self.selfIsClick = YES;
    self.baoBei.selected = NO;
    self.detail.selected = NO;
    [UIView animateWithDuration:0.2 animations:^{
           self.line.frame = CGRectMake(sender.left, sender.bottom+1, self.line.width, 2);
    }];
    if (self.typeBlock) {
        self.typeBlock(2);
    }
}

#pragma mark - overideMethod
//重写该属性 要不然不相应事件
- (CGSize)intrinsicContentSize{
    return CGSizeMake(250, 44);
}

@end
