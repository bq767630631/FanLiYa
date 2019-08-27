//
//  BrandSpecialAreaCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "BrandSpecialAreaCell.h"
#import "HomePage_Model.h"

@interface BrandSpecialAreaCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;

@property (weak, nonatomic) IBOutlet UIView *titleV;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
@implementation BrandSpecialAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _image.layer.shadowColor = RGBA(0, 0, 0, 0.5).CGColor;
//    _image.layer.shadowOffset = CGSizeMake(5,5);
//    _image.layer.shadowOpacity = 1;
//    _image.layer.shadowRadius = 3;
//    _image.clipsToBounds = NO;
    ViewBorderRadius(self.image, self.image.height*0.5, UIColor.whiteColor);
    ViewBorderRadius(self.titleV, 3, UIColor.clearColor);
}

- (void)setInfoWithModel:(id)model{
    BrandCat_info *info = model;
    [self.image setDefultPlaceholderWithFullPath:info.logo];
    self.title.text = info.name;
    self.content.text = info.introduce;
    if (info.index==0) {
        self.bgImageV.image = ZDBImage(@"brand001");
    }else if (info.index==1){
         self.bgImageV.image = ZDBImage(@"brand002");
    }else if (info.index==2){
         self.bgImageV.image = ZDBImage(@"brand003");
    }
}

@end
