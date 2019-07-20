//
//  LimitSale_SecStatusCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "LimitSale_SecStatusCell.h"
#import "LimitSale_SecModel.h"


@interface LimitSale_SecStatusCell ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
@implementation LimitSale_SecStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.status.font = [UIFont systemFontOfSize:12];
}

- (void)setInfo:(id)model{
    HomePage_FlashSaleInfo *info = model;
    self.time.text = info.time;
    self.status.text = info.status;
    if (info.isSelected) {
        self.time.font = [UIFont boldSystemFontOfSize:17];
        self.time.textColor = UIColor.whiteColor;
        self.status.textColor = UIColor.whiteColor;
    }else{
        self.time.font = [UIFont systemFontOfSize:15];
        self.time.textColor = RGBA(255, 255, 255, 0.5);
        self.status.textColor = RGBA(255, 255, 255, 0.5);
    }
}

@end
