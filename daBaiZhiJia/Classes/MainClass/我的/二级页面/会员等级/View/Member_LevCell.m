//
//  Member_LevCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/1.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Member_LevCell.h"
#import "Member_Model.h"
@interface Member_LevCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *isCurrent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levTopCons;

@end
@implementation Member_LevCell

- (void)setInfo:(id)model{
    Member_LeverSetInfo *info = model;
    self.imageView.image = ZDBImage(info.image);
    self.level.text = info.name;
    self.isCurrent.text = info.isCurent ?@"当前等级":@"";
    self.levTopCons.constant = info.isCurent?35.f:48.f;
    self.level.font = [UIFont systemFontOfSize:20];
}

@end
