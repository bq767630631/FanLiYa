//
//  MySpreadContrlHeadView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MySpreadContrlHeadView.h"
#import "IndexButton.h"

@interface MySpreadContrlHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet IndexButton *bTn;

@end
@implementation MySpreadContrlHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)action:(IndexButton *)sender {
    NSLog(@"");
    sender.selected = !sender.selected;
}



@end
