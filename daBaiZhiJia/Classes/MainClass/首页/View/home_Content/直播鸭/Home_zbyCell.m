//
//  Home_zbyCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_zbyCell.h"
#import "HomePage_Model.h"
#import "YYAnimatedImageView.h"
#import "YYImage.h"

@interface Home_zbyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;

@property (weak, nonatomic) IBOutlet UIView *numView;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gif;

@property (weak, nonatomic) IBOutlet UILabel *soldNum;

@property (weak, nonatomic) IBOutlet UIButton *yuguZhuan;

@property (weak, nonatomic) IBOutlet UIImageView *pt;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIButton *quanBtn;

@end
@implementation Home_zbyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.goodImage, 5, UIColor.clearColor);
    ViewBorderRadius(self.numView, self.numView.height/2, UIColor.clearColor);
}

- (void)setInfoWithModel:(id)model{
    SearchResulGoodInfo *info = model;
    [self.goodImage setDefultPlaceholderWithFullPath:info.pic];
    self.title.text = info.title;
    self.pt.image = (info.pt == 1)?ZDBImage(@"icon_zbytianmao"):ZDBImage(@"img_zbytaobao");
    self.soldNum.text = info.playNum;
    [self.yuguZhuan setTitle:[NSString stringWithFormat:@"预估赚¥%@",info.profit] forState:UIControlStateNormal];
     [self.quanBtn setTitle:[NSString stringWithFormat:@"¥%@",info.discount] forState:UIControlStateNormal];
    self.price.attributedText = [self priceAttr:@"¥ " str2:info.price];
    
    self.gif.image = [YYImage imageNamed:@"icon_watch_ios"];
}

- (NSMutableAttributedString*)priceAttr:(NSString*)str1 str2:(NSString*)str2{
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0, str1.length)];
    return mutStr;
}

@end
