//
//  DBZJ_Income_ProView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_Income_ProView.h"
#import "LoopProgressView.h"
#import "DBZJ_IncomeModel.h"

@interface DBZJ_Income_ProView ()
@property (weak, nonatomic) IBOutlet UILabel *cur_Lb;
@property (weak, nonatomic) IBOutlet UILabel *pro_lb;
@property (nonatomic, strong) LoopProgressView*pro;

@end
@implementation DBZJ_Income_ProView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.pro];
}

- (void)setInfo:(id)model{
      DBZJ_Zqy_Info *info = model;
    self.cur_Lb.text = info.curStr;
    self.pro_lb.text = info.totalStr;
    
    self.pro.progress = info.progress;
    self.pro.lbStr = info.lbStr;
    self.pro.strokeColor = info.strokeColor;
  
    [self.pro setNeedsDisplay];
}

#pragma mark - getter
- (LoopProgressView *)pro{
    if (!_pro) {
        NSLog(@"LoopProgressView  init");
        _pro = [[LoopProgressView alloc]initWithFrame:CGRectMake(0, 0, 84, 84)];
    }
    return _pro;
}

@end
