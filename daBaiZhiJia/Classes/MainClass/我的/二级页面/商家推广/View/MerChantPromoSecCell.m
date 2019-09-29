//
//  MerChantPromoSecCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MerChantPromoSecCell.h"


@interface MerChantPromoSecCell ()
@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIButton *tbBtn;

@property (weak, nonatomic) IBOutlet UIButton *tmBtn;
@property (weak, nonatomic) IBOutlet UIButton *pddBtn;

@property (weak, nonatomic) IBOutlet UIButton *jdBtn;

@end
@implementation MerChantPromoSecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.contentV, 3, UIColor.clearColor);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (IBAction)btnAction:(UIButton *)sender {
    NSInteger tag  = sender.tag;
    if (self.callBack) {
        self.callBack(tag);
    }
    if (tag ==1) {
        [self setBtnSelected:_tmBtn sec:_tbBtn third:_jdBtn fourth:_pddBtn];
    }else if (tag==2){
        [self setBtnSelected:_jdBtn sec:_tbBtn third:_tmBtn fourth:_pddBtn];
    }else if (tag==3){
         [self setBtnSelected:_pddBtn sec:_tbBtn third:_jdBtn fourth:_tmBtn];
    }else if (tag==4){
        [self setBtnSelected:_tbBtn sec:_tmBtn third:_jdBtn fourth:_pddBtn];
    }
}

#pragma mark - private

- (void)setBtnSelected:(UIButton*)first sec:(UIButton*)sec third:(UIButton*)third fourth:(UIButton*)fourth{
    first.selected = YES;
    sec.selected = NO;
    third.selected = NO;
    fourth.selected = NO;
}



@end
