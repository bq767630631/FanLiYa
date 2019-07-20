//
//  BillBoard_FirstMenu.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "BillBoard_FirstMenu.h"

@interface BillBoard_FirstMenu ()
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *twoHour;
@property (weak, nonatomic) IBOutlet UIButton *allDay;
@property (weak, nonatomic) IBOutlet UIButton *highProf;

@end
@implementation BillBoard_FirstMenu

- (IBAction)allDayClick:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.arrow.centerX = sender.centerX;
    }];
    if (sender == _twoHour) {
        _twoHour.selected = YES;
        _allDay.selected = NO;
        _highProf.selected = NO;
    }else if (sender == _allDay){
        _twoHour.selected = NO;
        _allDay.selected = YES;
        _highProf.selected = NO;
    }else if (sender == _highProf){
        _twoHour.selected = NO;
        _allDay.selected = NO;
        _highProf.selected = YES;
    }
}

- (void)setBtnSelectWithType:(NSInteger)type{
    UIButton *btn = nil;
    if (type==1) {
        btn = self.twoHour;
    }else if (type==2){
        btn = self.allDay;
    }else if (type==3){
        btn = self.highProf;
    }
    [self allDayClick:btn];
}






@end
