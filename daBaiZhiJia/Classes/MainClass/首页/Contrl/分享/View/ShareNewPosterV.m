//
//  ShareNewPosterV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/8/5.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ShareNewPosterV.h"
#import "GoodDetailModel.h"
#import "SGQRCode.h"
#import "UIImageView+WebCache.h"

@interface ShareNewPosterV ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ptTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;

@property (weak, nonatomic) IBOutlet UIImageView *pt;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *marketPrice;
@property (weak, nonatomic) IBOutlet UILabel *dicCount;

@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *tuiJian;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@property (weak, nonatomic) IBOutlet UIView *tuiJianV;


@end
@implementation ShareNewPosterV

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.goodImage, 7, UIColor.clearColor);
    ViewBorderRadius(self.tuiJianV, 7, UIColor.clearColor);
    ViewBorderRadius(self.codeImage, 3, UIColor.clearColor);
    if (IS_X_Xr_Xs_XsMax) {
        self.ptTop.constant = self.nameTop.constant += Height_StatusBar;
    }
}
- (void)setInfoWithModel:(id)model callBack:(VEBlockVoid)callback{
      GoodDetailInfo *info = model;
    NSString *imageStr = @"";
    if (info.pt==1) {
        imageStr = @"icon_zbytianmao";
    }else if (info.pt==3){
        imageStr = @"icon_pinduoduo";
    }else if (info.pt==4){
        imageStr = @"img_zbytaobao";
    }else if (info.pt==2){
        imageStr = @"icon_jd";
    }
    self.pt.image  = ZDBImage(imageStr);
    self.name.text = [NSString stringWithFormat:@"      %@",info.title];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.name.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6.0f];//设置行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.name.text.length)];
    self.name.attributedText = attributedString;
    self.price.attributedText = [self priceAttwithStr1:@"¥" str2:info.price];
    self.marketPrice.attributedText = [self marketPriceWithStr1:@"原价: " str2:[NSString stringWithFormat:@"¥%@",info.market_price]];
    self.dicCount.attributedText = [self dicountPriceWithStr1:info.coupon_amount str2:@"元"];
//    [self.goodImage setDefultPlaceholderWithFullPath:info.pic];
//    [self.goodImage sd_setImageWithURL:[NSURL URLWithString:info.pic] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (callback) {
//            callback();
//        }
//    }];
    [self.goodImage sd_setImageWithURL:[NSURL URLWithString:info.pic] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        NSLog(@"receivedSize  %zd",receivedSize);
        NSLog(@"expectedSize  %zd",expectedSize);
        NSLog(@"targetURL %@",targetURL);
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"completed")
        if (callback) {
            callback();
        }
    }];
    
    self.tuiJian.text = info.desc;
      self.codeImage.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:info.shorturl imageViewWidth: 95];
}

#pragma mark - getter
- (NSMutableAttributedString *)priceAttwithStr1:(NSString*)str1 str2:(NSString *)str2{
     NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, str1.length)];
     [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(str1.length, str2.length)];
    return mutStr;
}

- (NSMutableAttributedString *)marketPriceWithStr1:(NSString *)str1 str2:(NSString *)str2{
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(str1.length, str2.length)];
    [mutStr addAttribute:NSStrikethroughColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(str1.length, str2.length)];
    [mutStr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(str1.length, str2.length)];
    return mutStr;
}

- (NSMutableAttributedString *)dicountPriceWithStr1:(NSString *)str1 str2:(NSString *)str2{
     NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:21] range:NSMakeRange(0, str1.length)];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(str1.length, str2.length)];
    return mutStr;
}

@end
