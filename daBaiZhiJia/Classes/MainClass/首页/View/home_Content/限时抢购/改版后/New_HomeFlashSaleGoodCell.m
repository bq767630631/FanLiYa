//
//  New_HomeFlashSaleGoodCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "New_HomeFlashSaleGoodCell.h"
#import "HomePage_Model.h"
@interface New_HomeFlashSaleGoodCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *soldNum;

@end
@implementation New_HomeFlashSaleGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.image, 3, UIColor.clearColor);
}

- (void)setInfoModel:(id)model{
    SearchResulGoodInfo *info = model;
    [self.image setDefultPlaceholderWithFullPath:info.img];
    self.price.text = [NSString stringWithFormat:@"¥ %@",info.price];
    self.soldNum.text = [NSString stringWithFormat:@"已售%@件",info.sold_num];
}

@end
