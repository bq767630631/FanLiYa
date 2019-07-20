//
//  DBZJ_ComCollectionCell.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//图片
@interface DBZJ_ComCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, assign) BOOL  isVideo;

- (void)setModelWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
