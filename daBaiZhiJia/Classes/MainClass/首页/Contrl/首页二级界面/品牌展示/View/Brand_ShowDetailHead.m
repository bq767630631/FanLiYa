//
//  Brand_ShowDetailHead.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Brand_ShowDetailHead.h"
#import "HomePage_Model.h"

@interface Brand_ShowDetailHead ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *contentV;

@end
@implementation Brand_ShowDetailHead
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.image, self.image.height*0.5, UIColor.clearColor);
     ViewBorderRadius(self.contentV, 7, UIColor.clearColor);
}

- (void)setInfoWithModel:(id)model{
    BrandCat_info *info = model;
    [self.image setDefultPlaceholderWithFullPath:info.logo];
    self.name.text = info.name;
    self.content.text = info.introduce;
 
    [self layoutIfNeeded];
  
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = self.contentV.bottom + 15;
    self.height = height;
    //NSLog(@"Brand_ShowDetailHead.height = %.f",self.height);
}

@end
