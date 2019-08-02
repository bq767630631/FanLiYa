//
//  MineFirstView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MineFirstView.h"
#import "PrersonInfoContrl.h"
#import "PrersonInfoModel.h"
#import "Member_LevContrl.h"
#import "DetailWebContrl.h"
#import "ZKCycleScrollView.h"
#import "GoodDetailCustomCell.h"
#import "GoodDetailModel.h"

@interface MineFirstView ()<ZKCycleScrollViewDelegate,ZKCycleScrollViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hedimageTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setBtnTop;

@property (weak, nonatomic) IBOutlet UIView *huiyuanView;
@property (weak, nonatomic) IBOutlet UIImageView *huiYuanImage;
@property (weak, nonatomic) IBOutlet UILabel *huiyuanName;


@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UIButton *copysBtn;

@property (weak, nonatomic) IBOutlet UIView *bannerContentV;



@property (weak, nonatomic) IBOutlet UILabel *yuZhuLb;

@property (weak, nonatomic) IBOutlet UILabel *tiXianLb;

@property (weak, nonatomic) IBOutlet UILabel *yesYuGu;

@property (weak, nonatomic) IBOutlet UILabel *benYueYugu;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthYugu;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthJeSuan;


@property (weak, nonatomic) IBOutlet UIView *moneyV;
@property (weak, nonatomic) IBOutlet UIView *profitV;

@property (nonatomic, copy) NSString *codeStr;
@property (nonatomic, strong) ZKCycleScrollView *bannerV;
@property (nonatomic, strong) NSArray *bannerArr;//
@end

static NSString *KbannerId = @"KbannerId";
@implementation MineFirstView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.hedimageTop.constant += StatusBar_H;
    self.setBtnTop.constant +=  StatusBar_H;
    ViewBorderRadius(self.headImage, self.headImage.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.moneyV, 5, UIColor.whiteColor);
    ViewBorderRadius(self.profitV, 5, UIColor.whiteColor);
    [self.bannerContentV addSubview:self.bannerV];
}


- (void)setModel:(id)model{
    self.height = self.bannerContentV.bottom ;
    PersonRevenue *info = model;
    [self.headImage setPlaceholderImageWithFullPath:info.wechat_image placeholderImage:@"img_head_moren"];
    self.name.text = info.wechat_name;
    self.code.text = [NSString stringWithFormat:@"邀请码: %@",info.code];
    self.codeStr = info.code;
    if ([info.level isEqualToString:@"白银会员"]) {
        [self setHuiYuanViewWithInfo:@"白银会员" huiYuanimage:ZDBImage(@"img_silver") color:RGBColor(204, 204, 204)];
    }else if ([info.level isEqualToString:@"黄金会员"]){
        [self setHuiYuanViewWithInfo:@"黄金会员" huiYuanimage:ZDBImage(@"img_gold") color:RGBColor(213, 183, 131)];
    }else if ([info.level isEqualToString:@"团长"]){
        [self setHuiYuanViewWithInfo:@"团长" huiYuanimage:ZDBImage(@"img_tuanzhang_icon") color:RGBColor(245, 155, 17)];
    }
    
    self.yuZhuLb.attributedText = [self yuGuandTixianAttr:@"今日预估   " str2:info.today_profit];
    self.tiXianLb.attributedText = [self yuGuandTixianAttr:@"累计提现   " str2:info.drawcash];
    
    self.yesYuGu.text = info.yesterday_profit;
    self.benYueYugu.text = info.month_profit;
    self.lastMonthYugu.text = info.lastmonth_profit_yugu;
    self.lastMonthJeSuan.text = info.lastmonth_profit;
}

- (void)setAddVerInfo:(NSArray *)arr{
    self.bannerV.width = self.bannerContentV.width;
    self.bannerV.height = self.bannerContentV.height;
    NSMutableArray *temp = [NSMutableArray array];
    for ( PersonMiddAdvInfo *info in arr) {
        GoodDetailBannerInfo *banner =  [GoodDetailBannerInfo new];
        banner.videoUrl = @"";
        banner.pic = info.img;
        banner.url = info.url;
        [temp addObject:banner];
    }
    self.bannerArr = temp;
    [self.bannerV reloadData];
}

#pragma mark - ZKCycleScrollViewDataSource &ZKCycleScrollViewDelegate
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView{
    return self.bannerArr.count;
}

- (UICollectionViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index{
    GoodDetailCustomCell *cusCell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:KbannerId forIndex:index];
    GoodDetailBannerInfo *banner =   self.bannerArr[index];
    [cusCell setInfo:banner];
    return cusCell;
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
     GoodDetailBannerInfo *banner=  self.bannerArr[index];
    NSString *url = [NSString stringWithFormat:@"%@&token=%@", banner.url,ToKen];
    [self gotoSecVWithUrl:url title:nil];
}

#pragma mark - private
- (void)setHuiYuanViewWithInfo:(NSString*)name  huiYuanimage:(UIImage*)image color:(UIColor *)color{
    self.huiyuanName.text = name;
    self.huiYuanImage.image = image;
    ViewBorderRadius(self.huiyuanView, self.huiyuanView.height*0.5,color);
    self.huiyuanName.textColor = color;
}


- (NSMutableAttributedString *)yuGuandTixianAttr:(NSString *)str1 str2:(NSString*)str2{
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1, str2]];
    
    [ mutStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:UIColor.whiteColor} range:NSMakeRange(0, str1.length)];
    return mutStr;
}


- (void)gotoSecVWithUrl:(NSString *)url title:(NSString*)title{
    DetailWebContrl *detail = [[DetailWebContrl alloc] initWithUrl:url title:title para:nil];
    [self.viewController.navigationController pushViewController:detail animated:YES];
}

#pragma mark - action
- (IBAction)setAction:(id)sender {
    [self.viewController.navigationController pushViewController:[PrersonInfoContrl new] animated:YES];
}

- (IBAction)copyAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = self.codeStr;
    [YJProgressHUD showMsgWithoutView:@"邀请码复制成功"];
}


- (IBAction)myProfit:(UIButton *)sender {
    NSLog(@"");
    NSString *url = [NSString stringWithFormat:@"%@myBenefits.html?token=%@",BASE_WEB_URL,ToKen];
    [self gotoSecVWithUrl:url title:@"我的收益"];
}

- (IBAction)myYue:(UIButton *)sender {
    NSLog(@"");
    NSString *url = [NSString stringWithFormat:@"%@myBalance.html?token=%@",BASE_WEB_URL,ToKen];
    [self gotoSecVWithUrl:url title:@"我的余额"];
}

- (IBAction)myOrder:(id)sender {
    NSLog(@"");
    NSString *url = [NSString stringWithFormat:@"%@myOrder.html?token=%@",BASE_WEB_URL,ToKen];
    [self gotoSecVWithUrl:url title:@"我的订单"];
}


- (IBAction)myTeam:(UIButton *)sender {
    NSLog(@"");
    NSString *url = [NSString stringWithFormat:@"%@myTeams.html?token=%@",BASE_WEB_URL,ToKen];
    [self gotoSecVWithUrl:url title:@"我的团队"];
}

- (IBAction)findOrder:(UIButton *)sender {
    NSLog(@"");
//    NSString *url = [NSString stringWithFormat:@"%@retrieveOrder.html?token=%@",BASE_WEB_URL,ToKen];
//    [self gotoSecVWithUrl:url title:@"找回订单"];
}


#pragma mark - getter
- (ZKCycleScrollView *)bannerV{
    if (!_bannerV) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        _bannerV = [[ZKCycleScrollView alloc] initWithFrame:frame];
        _bannerV.delegate = self;
        _bannerV.dataSource = self;
        _bannerV.autoScroll = NO;
        [_bannerV registerCellNib:[UINib nibWithNibName:@"GoodDetailCustomCell" bundle:nil] forCellWithReuseIdentifier:KbannerId];
    }
    return _bannerV;
}

@end
