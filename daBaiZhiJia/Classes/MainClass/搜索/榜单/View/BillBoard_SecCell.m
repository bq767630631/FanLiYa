//
//  BillBoard_SecCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "BillBoard_SecCell.h"
#import "BillBoard_Model.h"

@interface BillBoard_SecCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation BillBoard_SecCell

- (void)setInfoWithModel:(id)model{
    BillBoard_CatInfo *info = model;
    [self.btn setTitle:info.title forState:UIControlStateNormal];
    [self.btn setTitle:info.title forState:UIControlStateSelected];
    self.btn.selected = info.isSelected;
    
    if (info.indexPath.item ==0) {
        self.imageV.image = ZDBImage(@"billicon_all");
    }else{
        [self.imageV setDefultPlaceholderWithFullPath:info.pic];
    }
}
@end
