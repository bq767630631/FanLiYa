//
//  DWSearchTableHeadV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DWSearchTableHeadV.h"
#import "DWQSearchController.h"
@interface DWSearchTableHeadV ()
@property (weak, nonatomic) IBOutlet UIButton *tb;
@property (weak, nonatomic) IBOutlet UIButton *pdd;
@property (weak, nonatomic) IBOutlet UIButton *jd;

@end
@implementation DWSearchTableHeadV


- (void)selectBtnWiThType:(NSInteger)type{
     [self handleSeletedBtnWithTag:type];
}


- (IBAction)clickAction:(UIButton *)sender {
    NSInteger tag = sender.tag;
    [self handleSeletedBtnWithTag:tag];
    DWQSearchController *vc = (DWQSearchController*)self.viewController;
    vc.searchType = tag;
}

#pragma mark - private
- (void)handleSeletedBtnWithTag:(NSInteger)tag{
    if (tag==1) {
        self.tb.selected = YES;
        self.pdd.selected = NO;
        self.jd.selected = NO;
    }else if (tag==2){
        self.tb.selected = NO;
        self.pdd.selected = YES;
        self.jd.selected = NO;
    }else if (tag==3){
        self.tb.selected = NO;
        self.pdd.selected = NO;
        self.jd.selected = YES;
    }
    [self handleBtnColor:self.tb];
    [self handleBtnColor:self.pdd];
    [self handleBtnColor:self.jd];
}


- (void)handleBtnColor:(UIButton*)btn{
    if (btn.isSelected) {
        ViewBorderRadius(btn, 14, RGBColor(255, 215, 0));
        btn.backgroundColor =  RGBColor(255, 215, 0);
    }else{
        ViewBorderRadius(btn, 14, RGBColor(85, 85, 85));
        btn.backgroundColor =  RGBColor(34, 34,34);
    }
}

@end
