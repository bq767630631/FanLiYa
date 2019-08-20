//
//  CreateshareCollectionCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "CreateshareCollectionCell.h"
#import "IndexButton.h"
#import "CreateShare_Model.h"

@interface CreateshareCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet IndexButton *indexBtn;
@property (nonatomic, strong) CreateShare_CellInfo *info;
@end
@implementation CreateshareCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.imageV, 4, UIColor.clearColor);
}

- (void)setInfoWith:(id)model{
    CreateShare_CellInfo *info = model;
    self.info = info;
    if (!info.isPoster) {
          [self.imageV setDefultPlaceholderWithFullPath:info.imageStr];
    }else{
          self.imageV.image = info.image;
    }
  
    self.indexBtn.selected = info.isSelected;
    self.indexBtn.indexPath = info.indexPath;
}


- (IBAction)bTnAction:(IndexButton *)sender {
    if (!self.info.isPoster) { //海报默认勾选，不能再操作
        sender.selected = !sender.selected;
        if (self.block) {
            self.block(sender.indexPath, sender.selected);
        }
    }
}

@end
