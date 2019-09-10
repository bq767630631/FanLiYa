//
//  Home_EveeChoiCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_EveeChoiCell.h"
#import "IndexButton.h"
#import "HomePage_Model.h"
#import "YYAnimatedImageView.h"
#import "YYImage.h"
#import "CreateShareContrl.h"
#import "CreateShare_Model.h"
#import "LoginContrl.h"
#import "PageViewController.h"
#import "CategoryContrl.h"


@interface Home_EveeChoiCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodimage;
@property (weak, nonatomic) IBOutlet UIView *playNumV;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gif;

@property (weak, nonatomic) IBOutlet UILabel *playLable; //播放量

@property (weak, nonatomic) IBOutlet UIImageView *videoImag;


@property (weak, nonatomic) IBOutlet UIImageView *pt;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *soldNum;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quanBtn_W;
@property (weak, nonatomic) IBOutlet UILabel *sharePro;
@property (weak, nonatomic) IBOutlet UILabel *shengjiPro;//IndexButton
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quanBtnTrail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLead;
@property (weak, nonatomic) IBOutlet IndexButton *sharebtn;

@property (nonatomic, strong) SearchResulGoodInfo *info;
@end
@implementation Home_EveeChoiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_iPhone5SE) {
        self.quanBtnTrail.constant = 0;
        self.priceLead.constant = 0;
    }
    ViewBorderRadius(self.goodimage, 5, UIColor.clearColor);
    ViewBorderRadius(self, 5, UIColor.clearColor);
    ViewBorderRadius(self.sharePro, self.sharePro.height/2, UIColor.clearColor);
    ViewBorderRadius(self.shengjiPro, self.shengjiPro.height/2, UIColor.clearColor);
    ViewBorderRadius(self.playNumV, self.playNumV.height/2, UIColor.clearColor);
}


- (void)setModel:(id)model{
    SearchResulGoodInfo *info = model;
    self.info = model;
    self.sharebtn.indexPath=  info.indexPath;
    [self.goodimage setDefultPlaceholderWithFullPath:info.pic];
    self.pt.image = (info.pt == 1)?ZDBImage(@"icon_zbytianmao"):ZDBImage(@"img_zbytaobao");
    [self.quanBtn setTitle:[NSString stringWithFormat:@"¥%@",info.discount] forState:UIControlStateNormal];
    
    CGFloat wd = [[NSString stringWithFormat:@"¥%@",info.discount] textWidthWithFont:self.quanBtn.titleLabel.font maxHeight:18];
    self.quanBtn_W.constant = wd + 5;
    self.title.text = [NSString stringWithFormat:@"%@",info.title];
    self.soldNum.text = [NSString stringWithFormat:@"已售%@件",info.sold_num];
    self.price.attributedText = [self priceAttr:@"¥" str2:[NSString stringWithFormat:@"%@  ",info.price] str3:[NSString stringWithFormat:@"¥%@",info.market_price]];
    self.sharePro.text = [NSString stringWithFormat:@"分享赚%@",info.profit];
    
    self.shengjiPro.text = [NSString stringWithFormat:@"%@%@",info.shengji_str,info.profit_up];
    
    if (info.isZby) {
        self.playNumV.hidden = NO;
        self.videoImag.hidden = NO;
        self.gif.image = [YYImage imageNamed:@"icon_watch_ios"];
        self.playLable.text = info.playNum;
    }else{
        self.playNumV.hidden = YES;
        self.videoImag.hidden = YES;
    }
    
}

- (IBAction)shareAction:(IndexButton *)sender {
    NSLog(@"");
    if ([self judgeisLogin]) {
        [CreateShare_Model geneRateTaoKlWithSku:self.info.sku vc:self.viewController navi_vc:[self getCur_Navi]  block:^(NSString *tkl, NSString *code, NSString *shorturl) {
            if (tkl) {
             
                CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:self.info.sku];
                [[self getCur_Navi] pushViewController:share animated:YES];
            }
        }];
    }
}

#pragma mark - private
- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0 &&token.length > 0) {
        return YES;
    }else{
        [[self getCur_Navi] pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
}

- (UINavigationController*)getCur_Navi{
    UINavigationController *navi = nil;
    if (self.info.is_From_page) {
        PageViewController *page  = (PageViewController *)self.viewController;
        navi =  page.naviContrl;
    }else if (self.info.is_From_cate){
        CategoryContrl *cate  = (CategoryContrl *)self.viewController;
        if (!self.info.is_Cate_Sec) {
            navi = cate.naviContrl;
        }else{
            navi = cate.navigationController;
        }
    }else{
        navi = self.viewController.navigationController;
    }
    return navi;
}


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
