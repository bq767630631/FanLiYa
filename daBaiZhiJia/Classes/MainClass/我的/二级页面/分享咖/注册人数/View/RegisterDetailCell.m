//
//  RegisterDetailCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "RegisterDetailCell.h"

@interface RegisterDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *regisNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regisLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regisTrail;

@property (weak, nonatomic) IBOutlet UILabel *vipnum;
@property (weak, nonatomic) IBOutlet UILabel *newsRegisNum;


@end
@implementation RegisterDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
