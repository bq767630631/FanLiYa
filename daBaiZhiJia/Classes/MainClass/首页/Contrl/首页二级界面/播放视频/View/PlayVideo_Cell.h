//
//  PlayVideo_Cell.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResulModel.h"

typedef void(^touchSel_fBlock)(void);
@interface PlayVideo_Cell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;
@property (nonatomic, strong) SearchResulGoodInfo  *info;

@property (nonatomic, copy) touchSel_fBlock block;

- (void)setInfoModel:(id)model;

@end


