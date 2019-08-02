//
//  NewPeople_EnjoyCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeople_EnjoyCell.h"
#import "NewPeople_EnjoyModel.h"
#import "SGQRCode.h"


@interface NewPeople_EnjoyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgimage;

@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@property (weak, nonatomic) IBOutlet UILabel *codeLb;
@property (weak, nonatomic) IBOutlet UILabel *notice;


@end
@implementation NewPeople_EnjoyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.codeImage, 5, UIColor.whiteColor);
    ViewBorderRadius(self.codeLb, self.codeLb.height *0.5, UIColor.whiteColor);
    ViewBorderRadius(self.notice, self.notice.height *0.5, UIColor.whiteColor);
}

- (void)setModel:(id)model{
    NewPeople_EnjoyInfo *info = model;
    [self.bgimage setDefultPlaceholderWithFullPath:info.pic];
     self.codeImage.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:info.url imageViewWidth: 90];
    self.codeLb.text = info.code;
    [self layoutIfNeeded];
}

@end
