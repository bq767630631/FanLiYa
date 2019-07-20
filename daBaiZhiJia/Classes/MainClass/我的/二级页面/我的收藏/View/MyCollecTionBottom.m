//
//  MyCollecTionBottom.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyCollecTionBottom.h"
#import "MyCollecTionModel.h"


@interface MyCollecTionBottom ()
@property (weak, nonatomic) IBOutlet UIButton *selecBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
@implementation MyCollecTionBottom
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.deleteBtn, 16, ThemeColor);
}

- (void)setModelWithArray:(NSArray *)arr{
     BOOL select = NO;
    for (MyCollecTionGoodInfo *goodModel in arr) {
        if (goodModel.isSelected ==0) {//只要有一个商品是未选中的  就跳出循环返回no 说明不是全选
            select = NO;
            break;
        }else{
            select = YES;
        }
    }
     self.selecBtn.selected = select;
}

- (IBAction)allSelecAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.block) {
        self.block(1, sender.selected);
    }
}


- (IBAction)deleteAction:(UIButton *)sender {
    if (self.block) {
        self.block(2, sender.selected);
    }
}

@end
