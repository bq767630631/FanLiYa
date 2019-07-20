//
//  MPZG_BaseTableViewCell.m
//  MinPingZhangGui
//
//  Created by mc on 2019/1/9.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseTableViewCell.h"

@implementation MPZG_BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(id)model{
}

@end
