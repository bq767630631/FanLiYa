//
//  Home_SecSingleCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/15.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_SecSingleCell.h"
#import "IndexButton.h"
#import "HomePage_Model.h"
#import "CreateShareContrl.h"
#import "CreateShare_Model.h"
#import "LoginContrl.h"
#import "PageViewController.h"
#import "CategoryContrl.h"

@interface Home_SecSingleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodimage;

@property (weak, nonatomic) IBOutlet UIImageView *playImagV;

@property (weak, nonatomic) IBOutlet UIImageView *pt;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *soldNum;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quanBtn_W;
@property (weak, nonatomic) IBOutlet UILabel *sharePro;
@property (weak, nonatomic) IBOutlet UILabel *shengjiPro;//IndexButton

@property (weak, nonatomic) IBOutlet IndexButton *sharebtn;
@property (nonatomic, strong) SearchResulGoodInfo *info;
@end

@implementation Home_SecSingleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewBorderRadius(self.goodimage, 5, UIColor.clearColor);
    ViewBorderRadius(self.sharePro, self.sharePro.height/2, UIColor.clearColor);
    ViewBorderRadius(self.shengjiPro, self.shengjiPro.height/2, UIColor.clearColor);
}

- (void)setModel:(id)model{
    SearchResulGoodInfo *info = model;
    self.info = info;
    self.sharebtn.indexPath=  info.indexPath;
    [self.goodimage setDefultPlaceholderWithFullPath:info.pic];
    self.playImagV.hidden = !info.video.length;
    self.pt.image = (info.pt == 1)?ZDBImage(@"icon_zbytianmao"):ZDBImage(@"img_zbytaobao");
    [self.quanBtn setTitle:[NSString stringWithFormat:@"¥%@",info.discount] forState:UIControlStateNormal];
    CGFloat wd = [[NSString stringWithFormat:@"¥%@",info.discount] textWidthWithFont:self.quanBtn.titleLabel.font maxHeight:18];
    self.quanBtn_W.constant = wd + 5;
    self.title.text = [NSString stringWithFormat:@"     %@",info.title];
    self.soldNum.text = [NSString stringWithFormat:@"%@人已买",info.sold_num];
    self.price.attributedText = [self priceAttr:@"¥" str2:[NSString stringWithFormat:@"%@  ",info.price] str3:[NSString stringWithFormat:@"¥%@",info.market_price]];
    self.sharePro.text = [NSString stringWithFormat:@"分享赚%@",info.profit];
    self.shengjiPro.text = [NSString stringWithFormat:@"%@%@",info.shengji_str,info.profit_up];
}

- (IBAction)shareAction:(IndexButton *)sender {
    if ([self judgeisLogin]) {
        UINavigationController *navi = nil;
        if (self.info.is_From_page) {
            PageViewController *page  = (PageViewController *)self.viewController;
            navi = page.naviContrl;
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
        
        [CreateShare_Model geneRateTaoKlWithSku:self.info.sku vc:self.viewController navi_vc:navi  block:^(NSString *tkl, NSString *code, NSString *shorturl) {
            if (tkl) {
                
                CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:self.info.sku ];
                if (self.info.is_From_page) {
                    PageViewController *page  = (PageViewController *)self.viewController;
                    [page.naviContrl pushViewController:share animated:YES];
                }else if (self.info.is_From_cate){
                    CategoryContrl *cate  = (CategoryContrl *)self.viewController;
                    if (!self.info.is_Cate_Sec) {
                        [cate.naviContrl pushViewController:share animated:YES];
                    }else{
                        [cate.navigationController pushViewController:share animated:YES];
                    }
                }else{
                    [self.viewController.navigationController pushViewController:share animated:YES];
                }
            }
        }];
    }
}

#pragma mark - private

- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0 && token.length > 0) {
        return YES;
    }else{
        LoginContrl *share = [LoginContrl new];
        if (self.info.is_From_page) {
            PageViewController *page  = (PageViewController *)self.viewController;
            [page.naviContrl pushViewController:share animated:YES];
        }else if (self.info.is_From_cate){
            CategoryContrl *cate  = (CategoryContrl *)self.viewController;
            if (!self.info.is_Cate_Sec) {
                [cate.naviContrl pushViewController:share animated:YES];
            }else{
                [cate.navigationController pushViewController:share animated:YES];
            }
        }else{
            [self.viewController.navigationController pushViewController:share animated:YES];
        }
        return NO;
    }
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
