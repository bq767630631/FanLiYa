//
//  Brand_ShowCells.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Brand_ShowCells.h"
#import "HomePage_Model.h"

@interface Brand_ShowCells ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIButton *entryBtn;

@end
@implementation Brand_ShowCells

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.entryBtn, self.entryBtn.height*0.5, UIColor.clearColor);
     ViewBorderRadius(self, 5, UIColor.clearColor);
//    self.layer.shadowColor = RGBA(0, 0, 0, 0.5).CGColor;
//    self.layer.shadowOffset = CGSizeMake(5,5);
//    self.layer.shadowOpacity = 1;
//    self.layer.shadowRadius = 3;
}

- (void)setInfoWithModel:(id)model{
    BrandCat_info *info = model;
    [self.image setDefultPlaceholderWithFullPath:info.logo];
    self.title.text = info.name;
    self.content.text = info.introduce;
}
@end
