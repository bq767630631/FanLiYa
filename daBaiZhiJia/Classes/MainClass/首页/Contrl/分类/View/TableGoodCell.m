//
//  TableGoodCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "TableGoodCell.h"
#import "SearchResulModel.h"
@interface TableGoodCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *originPrice;
@property (weak, nonatomic) IBOutlet UILabel *soldNum;
@property (weak, nonatomic) IBOutlet UIButton *quanLb;
@property (weak, nonatomic) IBOutlet UIButton *quanbtn;
@property (weak, nonatomic) IBOutlet UILabel *profit;


@end
@implementation TableGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.profit, 5, RGBColor(255, 232, 232));
    ViewBorderRadius(self.imageView, 5, RGBColor(255, 232, 232));
}

- (void)setInfo:(id)model{
     SearchResulGoodInfo *goodInfo = model;
    [self.imageView setDefultPlaceholderWithFullPath:goodInfo.pic];

    [self.quanLb setTitle:[NSString stringWithFormat:@"¥ %@",goodInfo.discount] forState:UIControlStateNormal];
    if (goodInfo.discount.doubleValue >0) {
        self.quanLb.hidden = NO;
        self.quanbtn.hidden = NO;
    }else{
        self.quanLb.hidden = YES;
        self.quanbtn.hidden = YES;
    }
    self.soldNum.text = [NSString stringWithFormat:@"%@人购买",goodInfo.sold_num];
    self.title.text = goodInfo.title;
    goodInfo.price = [NSString stringRoundingTwoDigitWithNumber:goodInfo.price.doubleValue];
    goodInfo.market_price = [NSString stringRoundingTwoDigitWithNumber:goodInfo.market_price.doubleValue];
    self.price.attributedText = [self priceWithStr1:@"券后 " str2:[NSString stringWithFormat:@"¥%@",goodInfo.price]];;
    self.originPrice.attributedText = [self marketPriceWithStr1:@"原价:" str2:[NSString stringWithFormat:@"%@",goodInfo.market_price]];
    goodInfo.profit = [NSString stringRoundingTwoDigitWithNumber:goodInfo.profit.doubleValue];
    self.profit.text = [NSString stringWithFormat:@"可赚%@",goodInfo.profit];
}


#pragma mark - private
- (NSMutableAttributedString *)priceWithStr1:(NSString *)str1 str2:(NSString *)str2{
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr addAttribute:NSForegroundColorAttributeName value:RGBColor(255, 102, 102) range:NSMakeRange(str1.length, str2.length)];
    return mutStr;
}

- (NSMutableAttributedString *)marketPriceWithStr1:(NSString *)str1 str2:(NSString *)str2{
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(str1.length, str2.length)];
    [mutStr addAttribute:NSStrikethroughColorAttributeName value:RGBColor(128, 128, 128) range:NSMakeRange(str1.length, str2.length)];
    [mutStr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(str1.length, str2.length)];
    return mutStr;
}
@end
