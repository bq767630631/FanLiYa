//
//  Home_horseRacelpCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/28.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_horseRacelpCell.h"
#import "HomePage_Model.h"

@interface Home_horseRacelpCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation Home_horseRacelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(id)model{
    HomePage_BroadCastInfo *info = model;
    self.title.text = [NSString stringWithFormat:@"%@    在%@分出单赚了",info.name, info.time];
    self.price.text =[NSString stringWithFormat:@"%@元",info.price];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
