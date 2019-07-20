//
//  GoodDetailCustomCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/15.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailCustomCell.h"
#import "GoodDetailModel.h"
@interface GoodDetailCustomCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;

@end
@implementation GoodDetailCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(id)model{
    GoodDetailBannerInfo *info = model;
    [self.goodImage setDefultPlaceholderWithFullPath:info.pic];
    self.playImage.hidden = !info.videoUrl.length;
}
@end
