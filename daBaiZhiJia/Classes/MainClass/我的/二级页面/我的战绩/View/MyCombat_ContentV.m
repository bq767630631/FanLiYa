//
//  MyCombat_ContentV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyCombat_ContentV.h"
#import "SGQRCode.h"
#import "MyCombat_Model.h"
#import "DBZJ_ComShareView.h"
@interface MyCombat_ContentV ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *huiyuanView;
@property (weak, nonatomic) IBOutlet UIImageView *huiYuanImage;
@property (weak, nonatomic) IBOutlet UILabel *huiyuanName;

@property (weak, nonatomic) IBOutlet UILabel *yuGuShouyi;

@property (weak, nonatomic) IBOutlet UILabel *doDayShouru;

@property (weak, nonatomic) IBOutlet UILabel *todayOrday;

@property (weak, nonatomic) IBOutlet UILabel *monthShouru;
@property (weak, nonatomic) IBOutlet UILabel *monthOrder;

@property (weak, nonatomic) IBOutlet UIButton *codeNum;

@property (weak, nonatomic) IBOutlet UIImageView *codeImageV;


@property (weak, nonatomic) IBOutlet UILabel *fenXaingLb;



@property (nonatomic, strong) MyCombat_Info *info;

@end
@implementation MyCombat_ContentV

- (void)awakeFromNib{
    [super awakeFromNib];
     ViewBorderRadius(self.headImage, self.headImage.height*0.5, UIColor.whiteColor);
     ViewBorderRadius(self.codeNum,  self.codeNum.height*0.5, UIColor.clearColor);
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.height = self.line.bottom ;
    
}

- (void)setModel:(id)model{
    MyCombat_Info *info = model;
    self.info = model;
    
    [self.headImage setPlaceholderImageWithFullPath:info.wechat_image placeholderImage:@"img_head_moren"];
    self.name.text = info.wechat_name;
    [self.codeNum setTitle:[NSString stringWithFormat:@"邀请码: %@",info.code] forState:UIControlStateNormal];
    self.dateLb.text = [self get_curDate];
    if ([info.level isEqualToString:@"白银会员"]) {
        [self setHuiYuanViewWithInfo:@"白银会员" huiYuanimage:ZDBImage(@"img_silver") color:RGBColor(204, 204, 204)];
    }else if ([info.level isEqualToString:@"黄金会员"]){
        [self setHuiYuanViewWithInfo:@"黄金会员" huiYuanimage:ZDBImage(@"img_gold") color:RGBColor(213, 183, 131)];
    }else if ([info.level isEqualToString:@"团长"]){
        [self setHuiYuanViewWithInfo:@"团长" huiYuanimage:ZDBImage(@"img_tuanzhang_icon") color:RGBColor(245, 155, 17)];
    }
    
     self.yuGuShouyi.text = info.profit;
     self.doDayShouru.text = info.today;
     self.todayOrday.text  = info.todayorder;
     self.monthShouru.text = info.month;
     self.monthOrder.text  = info.monthorder;
     self.codeImageV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:info.url imageViewWidth: 130];
    
}


#pragma mark - private
- (void)setHuiYuanViewWithInfo:(NSString*)name  huiYuanimage:(UIImage*)image color:(UIColor *)color{
    self.huiyuanName.text = name;
    self.huiYuanImage.image = image;
    ViewBorderRadius(self.huiyuanView, self.huiyuanView.height*0.5,color);
    self.huiyuanName.textColor = color;
}

- (NSString*)get_curDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}


#pragma mark - action
- (IBAction)codeAction:(UIButton *)sender {
     NSLog(@"");
}


- (IBAction)shareWeixinAction:(UIButton *)sender {
    NSLog(@"");
    
        CGSize size = CGSizeMake(SCREEN_WIDTH,  self.fenXaingLb.bottom );
        UIImage*image = [self getmakeImageWithView:self andWithSize:size];
        DBZJ_ComShareView *share = [DBZJ_ComShareView viewFromXib];
        share.isFrom_haiBao = YES;
        share.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        share.model = image;
        [share show];
}

@end
