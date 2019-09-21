//
//  Home_FlashSaleGoodCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_FlashSaleGoodCell.h"
#import "IndexButton.h"
#import "HomePage_Model.h"
#import "CreateShareContrl.h"
#import "CreateShare_Model.h"
#import "LoginContrl.h"
#import "PageViewController.h"

@interface Home_FlashSaleGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodimage;

@property (weak, nonatomic) IBOutlet UIImageView *playImagV;

@property (weak, nonatomic) IBOutlet UIImageView *pt;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *soldNum;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *sharePro;
@property (weak, nonatomic) IBOutlet UILabel *shengjiPro;//IndexButton

@property (weak, nonatomic) IBOutlet IndexButton *sharebtn;

@property (nonatomic, strong) SearchResulGoodInfo *info;
@end
@implementation Home_FlashSaleGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    ViewBorderRadius(self.goodimage, 5, UIColor.clearColor);
    ViewBorderRadius(self.sharePro, self.sharePro.height/2, UIColor.clearColor);
    ViewBorderRadius(self.shengjiPro, self.shengjiPro.height/2, UIColor.clearColor);
}

- (void)setModel:(id)model{
    SearchResulGoodInfo *info = model;
    self.info = model;
    self.sharebtn.indexPath=  info.indexPath;
    [self.goodimage setDefultPlaceholderWithFullPath:info.img];
    self.playImagV.hidden = !info.video.length;
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
     [self.quanBtn setTitle:[NSString stringWithFormat:@"¥%@",info.discount] forState:UIControlStateNormal];
    self.title.text = [NSString stringWithFormat:@"     %@",info.title];
    self.soldNum.text = [NSString stringWithFormat:@"%@人已买",info.sold_num];
    self.price.attributedText = [self priceAttr:@"¥" str2:[NSString stringWithFormat:@"%@  ",info.price] str3:[NSString stringWithFormat:@"¥%@",info.market_price]];
    self.sharePro.text = [NSString stringWithFormat:@"分享赚%@",info.profit];
    self.shengjiPro.text = [NSString stringWithFormat:@"%@%@",info.shengji_str,info.profit_up];
}

- (IBAction)shareAction:(IndexButton *)sender {
     NSLog(@"");
    if ([self judgeisLogin]) {
          PageViewController *page = (PageViewController*)self.viewController;
        [CreateShare_Model geneRateTaoKlWithSku:self.info.sku vc:self.viewController navi_vc:page.naviContrl  block:^(NSString *tkl, NSString *code, NSString *shorturl) {
            if (tkl) {
                PageViewController *page = (PageViewController*)self.viewController;
                CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:self.info.sku ];
                [page.naviContrl pushViewController:share animated:YES];
            }
        }];
    }
}

- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0 &&token.length > 0) {
        return YES;
    }else{
        PageViewController *page = (PageViewController*)self.viewController;
        [page.naviContrl pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
}

#pragma mark - private
- (NSMutableAttributedString*)priceAttr:(NSString*)str1 str2:(NSString*)str2 str3:(NSString*)str3{
    NSMutableAttributedString* mustr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",str1,str2,str3]];
    [mustr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0, str1.length)];
     [mustr setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:NSMakeRange(str1.length, str2.length)];
    
    [mustr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(str1.length + str2.length, str3.length)];
    [mustr addAttribute:NSForegroundColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(str1.length + str2.length, str3.length)];
    [mustr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(str1.length + str2.length, str3.length)];
    [mustr addAttribute:NSStrikethroughColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(str1.length + str2.length, str3.length)];
    [mustr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(str1.length + str2.length, str3.length)];
    return mustr;
}

@end
