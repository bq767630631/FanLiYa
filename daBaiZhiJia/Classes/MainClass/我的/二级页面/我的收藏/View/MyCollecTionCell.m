//
//  MyCollecTionCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyCollecTionCell.h"
#import "IndexButton.h"
#import "MyCollecTionModel.h"
@interface MyCollecTionCell ()
@property (weak, nonatomic) IBOutlet IndexButton *selecBtn;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLead;


@property (weak, nonatomic) IBOutlet UIView *myContent;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *origprice;
@property (weak, nonatomic) IBOutlet UILabel *yuGuzhuan;

@end
@implementation MyCollecTionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.myContent, 7, UIColor.whiteColor);
    ViewBorderRadius(self.image, 5, UIColor.clearColor);
    ViewBorderRadius(self.yuGuzhuan, self.yuGuzhuan.height /2, UIColor.clearColor);
}

- (void)setModel:(id)model{
    MyCollecTionGoodInfo *info =  model;
    
    [self.image setDefultPlaceholderWithFullPath:info.pic];
    self.title.text = info.title;
    self.imageLead.constant = info.imageLeadCons;
    info.price = [NSString stringRoundingTwoDigitWithNumber:info.price.doubleValue];
    info.market_price = [NSString stringRoundingTwoDigitWithNumber:info.market_price.doubleValue];
    info.commission_money = [NSString stringRoundingTwoDigitWithNumber:info.commission_money.doubleValue];
    self.price.attributedText = [self priceWithStr1:@"¥ " str2:info.price];
    self.origprice.attributedText = [self marketPriceWithStr1:@"原价 ¥" str2:info.market_price];
    self.yuGuzhuan.text = [NSString stringWithFormat:@"预估赚 ¥%@",info.commission_money];
    self.selecBtn.selected = info.isSelected;
    self.selecBtn.indexPath = info.indexPath;
}

- (NSMutableAttributedString *)priceWithStr1:(NSString *)str1 str2:(NSString *)str2{
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, str1.length)];
    return mutStr;
}

- (NSMutableAttributedString *)marketPriceWithStr1:(NSString *)str1 str2:(NSString *)str2{
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(str1.length, str2.length)];
    [mutStr addAttribute:NSStrikethroughColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(str1.length, str2.length)];
    [mutStr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(str1.length, str2.length)];
    return mutStr;
}

- (IBAction)selecBtnAction:(IndexButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectBlock) {
        self.selectBlock(sender.indexPath, sender.isSelected);
    }
}


@end
