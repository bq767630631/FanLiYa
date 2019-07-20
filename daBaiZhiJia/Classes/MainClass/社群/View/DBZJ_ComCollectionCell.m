//
//  DBZJ_ComCollectionCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_ComCollectionCell.h"
@interface DBZJ_ComCollectionCell ()


@property (weak, nonatomic) IBOutlet UIImageView *playImage;

@end
@implementation DBZJ_ComCollectionCell


- (void)setModelWithModel:(id)model{
     [self.image setDefultPlaceholderWithFullPath:model];
    if (self.isVideo) {
          self.playImage.hidden = NO;
    }else{
         self.playImage.hidden = YES;
    }
}
@end
