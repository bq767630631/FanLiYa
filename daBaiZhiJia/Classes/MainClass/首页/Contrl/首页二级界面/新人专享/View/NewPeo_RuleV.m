//
//  NewPeo_RuleV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/12.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_RuleV.h"
#import "NewPeo_shareModel.h"


@interface NewPeo_RuleV ()
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentV_W;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *type;

@property (weak, nonatomic) IBOutlet UILabel *attition;
@end
@implementation NewPeo_RuleV

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    ViewBorderRadius(self.contentV, 5, UIColor.clearColor);
    self.contentV_W.constant =   self.contentV_W.constant *SCALE_Normal;
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



- (void)setModel:(id)model{
    NewPeo_shareRuleInfo *info = model;
    self.time.text = info.action_time;
    self.user.text = info.action_user;
    self.type.text = info.action_type;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6.0;
    self.attition.attributedText = [[NSMutableAttributedString alloc] initWithString:info.action_content attributes:@{NSParagraphStyleAttributeName:paraStyle}];
    [self layoutIfNeeded];
   // self.height = self.contentV.bottom;
//    self.width = SCREEN_WIDTH;
}


- (IBAction)closeAction:(id)sender {
    [self disMiss];
}


@end
