//
//  GoodDetail_ShengjiV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetail_ShengjiV.h"

@interface GoodDetail_ShengjiV ()

@property (weak, nonatomic) IBOutlet UILabel *shengJiBtn;

@end
@implementation GoodDetail_ShengjiV

- (void)setInfo:(NSString *)profit{
    self.shengJiBtn.text = [NSString stringWithFormat:@"¥ %@",profit];
}

- (IBAction)action:(UIButton *)sender {
    if (self.bloock) {
        self.bloock();
    }
}

@end
