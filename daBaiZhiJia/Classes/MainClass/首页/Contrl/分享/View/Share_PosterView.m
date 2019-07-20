//
//  Share_PosterView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/4.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Share_PosterView.h"
#import "GoodDetailModel.h"
#import "SGQRCode.h"
@interface Share_PosterView ()
@property (strong, nonatomic)  UIImageView *goodImage;
@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *market_price;
@property (strong, nonatomic)  UIButton *discont;
@property (strong, nonatomic)  UIButton *quanBtn;


@property (strong, nonatomic)  UIImageView *kuangBg;//红色虚框
@property (strong, nonatomic)  UIImageView *codeImage;
@property (strong, nonatomic)  UILabel *first;
@property (strong, nonatomic)  UILabel *second;
@property (strong, nonatomic)  UILabel *third;
@property (strong, nonatomic)  UIImageView *taoImage;
@property (strong, nonatomic)  UILabel *four;
@end
@implementation Share_PosterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor whiteColor];
        self.goodImage.backgroundColor = [UIColor yellowColor];
        
         [self addSubview:self.goodImage];
         [self addSubview:self.title];
         [self addSubview:self.price];
         [self addSubview:self.market_price];
         [self addSubview:self.discont];
         [self addSubview:self.quanBtn];
        
         [self addSubview:self.kuangBg];
         [self addSubview:self.codeImage];
         [self addSubview:self.first];
         [self addSubview:self.second];
         [self addSubview:self.third];
         [self addSubview:self.taoImage];
         [self addSubview:self.four];
       
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideInWindow];
}

- (void)setInfoWithModel:(id)model{
    GoodDetailInfo *info = model;
    self.title.text = info.title;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.title.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7.0f];//设置行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.title.text.length)];
    self.title.attributedText = attributedString;
    
    self.price.text =  [NSString stringWithFormat:@"券后 ¥%@",info.price];
    self.price.width  =  [self.price.text textWidthWithFont: self.price.font maxHeight:MAXFLOAT];
    self.market_price.attributedText = [self marketPriceWithStr1:@"原价: " str2:[NSString stringWithFormat:@"¥%@",info.market_price]];
    self.market_price.left =  self.price.right + 22;
    self.market_price.width = [self.market_price.text textWidthWithFont: self.market_price.font maxHeight:MAXFLOAT];
    
    [self.goodImage setDefultPlaceholderWithFullPath:info.pic];
    [self.discont setTitle:[NSString stringWithFormat:@"¥ %@",info.coupon_amount] forState:UIControlStateNormal];
    if (info.coupon_amount.doubleValue==0) {
        self.quanBtn.hidden = YES;
        self.discont.hidden = YES;
    }
      
    self.codeImage.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:info.shorturl imageViewWidth: 90*SCALE_Normal];
}

#pragma mark - private
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

#pragma mark - getter
- (UIImageView *)goodImage{
    if (!_goodImage) {
        _goodImage = [[UIImageView alloc] init];
        CGFloat top = 10;
        if (IS_X_Xr_Xs_XsMax) {
            top = Height_StatusBar;
        }
        _goodImage.frame = CGRectMake(10, top, SCREEN_WIDTH - 20,  SCREEN_WIDTH - 20);
    }
    return _goodImage;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.frame = CGRectMake(10, _goodImage.bottom + 10, SCREEN_WIDTH - 20, 45.f);
        _title.numberOfLines = 2;
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = RGBColor(51, 51, 51);
    }
    return _title;
}

- (UILabel *)price{
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.frame = CGRectMake(10, _title.bottom + 30*SCALE_Normal, 70.f,18);
        _price.textColor = ThemeColor;
        _price.font = [UIFont systemFontOfSize:12*SCALE_Normal];
    }
    return _price;
}

- (UILabel *)market_price{
    if (!_market_price) {
        _market_price = [[UILabel alloc] init];
        _market_price.frame = CGRectMake(_price.right + 22*SCALE_Normal, _price.top , 70.f, 13);
        _market_price.textColor = RGBColor(153, 153, 153);
        _market_price.font = [UIFont systemFontOfSize:12*SCALE_Normal];
        _market_price.centerY = _price.centerY;
    }
    return _market_price;
}

-(UIButton *)discont{
    if (!_discont) {
        _discont = [UIButton buttonWithType:UIButtonTypeCustom];
        _discont.frame = CGRectMake(SCREEN_WIDTH -41-15, _price.top ,41, 17);
        _discont.titleLabel.font = [UIFont systemFontOfSize:11];
        [_discont setTitleColor: RGBColor(195, 152, 77) forState:UIControlStateNormal];
        [_discont setBackgroundImage:ZDBImage(@"xsg_right")  forState:UIControlStateNormal];
    }
    return _discont;
}

-(UIButton *)quanBtn{
    if (!_quanBtn) {
        _quanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _quanBtn.frame = CGRectMake(SCREEN_WIDTH -41-15-17, _price.top ,20, 17);
        _quanBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_quanBtn setTitleColor: RGBColor(195, 152, 77) forState:UIControlStateNormal];
        [_quanBtn setTitle:@"券" forState:UIControlStateNormal];
        [_quanBtn setBackgroundImage:ZDBImage(@"xsg_lefe") forState:UIControlStateNormal];
    }
    return _quanBtn;
}

- (UIImageView *)kuangBg{
    if (!_kuangBg) {
        _kuangBg = [UIImageView new];
        _kuangBg.frame = CGRectMake(22*SCALE_Normal, _price.bottom +22*SCALE_Normal, SCREEN_WIDTH -22*2, 110*SCALE_Normal);
        _kuangBg.image = ZDBImage(@"img_dotted_border");
    }
    return _kuangBg;
}

- (UIImageView *)codeImage{
    if (!_codeImage) {
          _codeImage = [UIImageView new];
        CGFloat wd = 100 *SCALE_Normal;
         _codeImage.frame = CGRectMake(_kuangBg.left + 17*SCALE_Normal, _kuangBg.top +5*SCALE_Normal, wd, wd);
        _codeImage.centerY =   _kuangBg.centerY;
    }
    return _codeImage;
}

- (UILabel *)first{
    if (!_first) {
        _first = [UILabel new];
        _first.frame = CGRectMake(_codeImage.right + 14*SCALE_Normal, _kuangBg.top +16*SCALE_Normal, 150, 15);
        _first.font = [UIFont systemFontOfSize:15];
        _first.textColor = RGBColor(51, 51, 51);
        _first.text = @"1、长按识别左侧商品二维码";
        _first.width = [_first.text textWidthWithFont: _first.font maxHeight:MAXFLOAT];
    }
    return _first;
}

- (UILabel *)second{
    if (!_second) {
        _second = [UILabel new];
        _second.frame = CGRectMake(_codeImage.right + 14*SCALE_Normal, _first.bottom +16*SCALE_Normal, 131, 15);
        _second.font = [UIFont systemFontOfSize:15];
        _second.textColor = RGBColor(51, 51, 51);
        _second.text = @"2、一键复制口令";
        _second.width = [_second.text textWidthWithFont: _second.font maxHeight:MAXFLOAT];
    }
    return _second;
}

- (UILabel *)third{
    if (!_third) {
        _third = [UILabel new];
        _third.frame = CGRectMake(_codeImage.right + 14*SCALE_Normal, _second.bottom +16*SCALE_Normal, 90, 15);
        _third.font = [UIFont systemFontOfSize:15];
        _third.textColor = RGBColor(51, 51, 51);
        _third.text = @"3、打开手机";
        _third.width = [_third.text textWidthWithFont: _third.font maxHeight:MAXFLOAT];
    }
    return _third;
}

- (UIImageView *)taoImage{
    if (!_taoImage) {
        _taoImage = [[UIImageView alloc]initWithImage:ZDBImage(@"img_taobao")];
        _taoImage.frame = CGRectMake(_third.right + 5, _third.top, 20.5, 20.5);
        _taoImage.centerY = _third.centerY;
    }
    return _taoImage;
}

- (UILabel *)four{
    if (!_four) {
        _four = [UILabel new];
        _four.frame = CGRectMake(_taoImage.right + 5, _third.top, 50, 15);
        _four.font = [UIFont systemFontOfSize:15];
        _four.textColor = RGBColor(51, 51, 51);
        _four.text = @"购买";
    }
    return _four;
}

@end
