//
//  NewPeo_shareBottomV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_shareBottomV.h"
#import "NewPeo_shareModel.h"
#import "NewPeople_EnjoyContrl.h"


@interface NewPeo_shareBottomV ()
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *type;

@property (weak, nonatomic) IBOutlet UILabel *attition;
@end

@implementation NewPeo_shareBottomV
-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentV.layer.cornerRadius =  5.f;
    self.contentV.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    self.contentV.layer.borderWidth = 3.f;//宽度
    self.contentV.layer.borderColor = RGBColor(246, 189, 57).CGColor;
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
    self.height = self.contentV.bottom;
}

- (IBAction)shareAction:(UIButton *)sender {
    [self.viewController.navigationController pushViewController:[NewPeople_EnjoyContrl new] animated:YES];
}


@end
