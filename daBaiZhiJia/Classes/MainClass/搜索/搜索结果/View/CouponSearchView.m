//
//  CouponSearchView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "CouponSearchView.h"
#import "KLSwitch.h"
@interface CouponSearchView ()

@property (weak, nonatomic) IBOutlet KLSwitch *customSwitch;
@property (weak, nonatomic) IBOutlet UIButton *quanzhan;
@property (weak, nonatomic) IBOutlet UIButton *app;

@end
@implementation CouponSearchView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.customSwitch.tintColor = RGBColor(220, 220, 220);
    self.customSwitch.onTintColor = RGBColor(241, 152, 51);
    [self.customSwitch setDidChangeHandler:^(BOOL isOn) {
        if (self.block) {
            self.block(isOn);
        }
    }];
}

- (void)setSearchType:(NSInteger)searchType{
    _searchType = searchType;
    if (_searchType!=1) {//拼多多，京东没有全网搜
        self.quanzhan.hidden = YES;
        self.app.hidden = YES;
    }
}



- (IBAction)quanzhanAction:(UIButton *)sender {
    self.app.selected = NO;
    sender.selected = YES;
    if (self.typeblock) {
        self.typeblock(1);
    }
}


- (IBAction)appAction:(UIButton *)sender {
     self.quanzhan.selected = NO;
     sender.selected = YES;
    if (self.typeblock) {
        self.typeblock(2);
    }
}



@end
