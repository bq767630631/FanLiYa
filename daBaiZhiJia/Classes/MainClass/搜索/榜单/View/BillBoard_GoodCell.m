//
//  BillBoard_GoodCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/15.
//  Copyright © 2019 包强. All rights reserved.
//

#import "BillBoard_GoodCell.h"
#import "HomePage_Model.h"
#import "IndexButton.h"
#import "CreateShareContrl.h"
#import "CreateShare_Model.h"
#import "LoginContrl.h"
@interface BillBoard_GoodCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodimage;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *pt;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *soldNum;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UILabel *sharePro;
@property (weak, nonatomic) IBOutlet UILabel *shengjiPro;//IndexButton

@property (weak, nonatomic) IBOutlet IndexButton *sharebtn;
@property (nonatomic, strong)  SearchResulGoodInfo *info;
@end
@implementation BillBoard_GoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    ViewBorderRadius(self.bgView, 5, UIColor.whiteColor);
    ViewBorderRadius(self.sharePro, self.sharePro.height/2, UIColor.clearColor);
    ViewBorderRadius(self.shengjiPro, self.shengjiPro.height/2, UIColor.clearColor);
    ViewBorderRadius(self.goodimage, 5, UIColor.clearColor);
}

- (void)setModel:(id)model{
    SearchResulGoodInfo *info = model;
    self.info = info;
    self.sharebtn.indexPath = info.indexPath;
    [self.goodimage setDefultPlaceholderWithFullPath:info.img];
    
    self.pt.image = (info.pt == 1)?ZDBImage(@"icon_zbytianmao"):ZDBImage(@"img_zbytaobao");
    [self.quanBtn setTitle:[NSString stringWithFormat:@"¥%@",info.discount] forState:UIControlStateNormal];
    self.title.text = [NSString stringWithFormat:@"%@",info.title];

    NSString *soldStr1 = @"";
    if (info.rankType ==1) {
        soldStr1 = @"近两小时成交";
    }else if (info.rankType ==2){
        soldStr1 = @"全天成交";
    }else if (info.rankType ==3){
        soldStr1 = @"近一个月成交";
    }
    self.soldNum.attributedText = [self soldAttrStr:soldStr1 str2:info.sold_num str3:@"件"];
    self.price.attributedText = [self priceAttr:@"¥" str2:[NSString stringWithFormat:@"%@  ",info.price] str3:[NSString stringWithFormat:@"¥%@",info.market_price]];
    self.sharePro.text = [NSString stringWithFormat:@"分享赚%@",info.profit];
    self.shengjiPro.text = [NSString stringWithFormat:@"%@%@",info.shengji_str,info.profit_up];
}


- (IBAction)shareAction:(IndexButton *)sender {
    NSLog(@"");
    if ([self judgeisLogin]) {
        [CreateShare_Model geneRateTaoKlWithSku:self.info.sku vc:self.viewController navi_vc:self.viewController.navigationController  block:^(NSString *tkl, NSString *code, NSString *shorturl) {
            if (tkl) {
                CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:self.info.sku ];
                [self.viewController.navigationController pushViewController:share animated:YES];
            }
        }];
    }
}

- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0 &&token.length > 0) {
        return YES;
    }else{
          [self.viewController.navigationController pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
}

#pragma mark - private
- (NSMutableAttributedString*)soldAttrStr:(NSString*)str1 str2:(NSString*)str2  str3:(NSString*)str3{
    NSMutableAttributedString* mustr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",str1,str2,str3]];
    
    [mustr setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:NSMakeRange(str1.length, str2.length)];
    [mustr setAttributes:@{NSForegroundColorAttributeName:RGBColor(195, 152, 77)} range:NSMakeRange(str1.length, str2.length)];
    return mustr;
    return mustr;
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
