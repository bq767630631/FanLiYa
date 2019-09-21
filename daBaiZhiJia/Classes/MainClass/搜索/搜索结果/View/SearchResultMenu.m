//
//  SearchResultMenu.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/3.
//  Copyright © 2019 包强. All rights reserved.
//

#import "SearchResultMenu.h"


@interface SearchResultMenu ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleLeadCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleTrailCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTrailCon;

@property (weak, nonatomic) IBOutlet UIButton *comprehenBtn; //综合


@property (weak, nonatomic) IBOutlet UIButton *saleBtn;


@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@property (weak, nonatomic) IBOutlet UIButton *commissionBtn;//切换按钮

////价格 默认升序   销量 默认降序
@property (assign, nonatomic) NSInteger sale_sort; // 默认是2  偶数 降序


@property (assign, nonatomic) NSInteger price_sort; // 默认是1 奇数 升序

@property (nonatomic, copy) NSString *searchStr; //
@end
@implementation SearchResultMenu

- (void)awakeFromNib{
    [super awakeFromNib];
    self.sale_sort = 2;
    self.price_sort = 1;
    self.searchStr = @"";
    CGFloat consW = (SCREEN_WIDTH - 30.f * 3 - 40 - 34*2) / 3;
    self.saleLeadCon.constant   = consW;
    self.saleTrailCon.constant  = consW;
    self.priceTrailCon.constant = consW;
}

- (void)setSearchType:(NSInteger)searchType{
    _searchType = searchType;
    if (searchType==2) {
        [self.comprehenBtn setTitleColor:RGBColor(255, 102, 102) forState:UIControlStateSelected];
        [self.saleBtn setTitleColor:RGBColor(255, 102, 102) forState:UIControlStateSelected];
        [self.priceBtn setTitleColor:RGBColor(255, 102, 102) forState:UIControlStateSelected];
        [self.comprehenBtn setTitleColor:RGBColor(255, 102, 102) forState:UIControlStateSelected];
    }
}

- (IBAction)zongheAction:(UIButton *)sender {
    NSLog(@"zongheAction");
    
    if (self.searchBlock) {
        self.searchBlock(@"");
    }
    self.sale_sort  = 2;
    self.price_sort = 1;
    sender.selected = YES;
    self.priceBtn.selected = NO;
    self.saleBtn.selected = NO;

}

- (IBAction)saleAction:(UIButton *)sender { //销量 默认降序
     NSLog(@"saleAction");
     sender.selected = YES;
     self.priceBtn.selected = NO;
     self.comprehenBtn.selected = NO;
    if (self.searchBlock) {
        self.searchBlock(@"total_sales_des");
    }
}


- (IBAction)priceAction:(UIButton *)sender {//价格 默认升序
     NSLog(@"priceAction");
    self.comprehenBtn.selected = NO;
    self.saleBtn.selected = NO;
    sender.selected = YES;
    if (self.price_sort %2 ==0 ) { //偶数
        NSString *imageStr = @"";
        if (self.searchType==2) {
            imageStr = @"icon_select_down_pdd";
        }else{
            imageStr = @"icon_select_down";
        }
        [self.priceBtn setImage:ZDBImage(imageStr) forState:UIControlStateSelected ];
        self.searchStr = @"price_des";
    }else{
        NSString *imageStr = @"";
        if (self.searchType==2) {
            imageStr = @"icon_select_up_pdd";
        }else{
            imageStr = @"icon_select_height";
        }
        [self.priceBtn setImage:ZDBImage(@"icon_select_height") forState:UIControlStateSelected ];
        self.searchStr = @"price_asc";
    }
    if (self.searchBlock) {
        self.searchBlock(self.searchStr);
    }
    self.price_sort ++;
}


- (IBAction)commissionAction:(UIButton *)sender {
     NSLog(@"commissionAction");
    sender.selected = !sender.selected;
    if (self.switchBlock) {
        self.switchBlock(sender.selected);
    }
}

#pragma mark - private
- (void)setBtnSelect:(UIButton *)btn{
    btn.selected = YES;
    for (UIView *subV in self.subviews) {
        if (subV != btn && [subV isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subV;
            btn.selected = NO;
        }
    }
}

@end
