//
//  GoodDetailTuiJianCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/12.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailTuiJianCell.h"
#import "GoodDetailModel.h"
@interface GoodDetailTuiJianCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation GoodDetailTuiJianCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self, 5, UIColor.clearColor);
}
- (void)setInfo:(id)model{
    SearchResulGoodInfo *info = model;
    [self.image setDefultPlaceholderWithFullPath:info.pic];
    self.title.text = info.title;
    self.price.text = [NSString stringWithFormat:@"¥%@",info.price];
}


@end
