//
//  CreateshareCollectionCell.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CreateshareCollectionCellBlock)(NSIndexPath *indexpath, BOOL isSelect);


@interface CreateshareCollectionCell : UICollectionViewCell

@property (nonatomic, copy) CreateshareCollectionCellBlock block;

- (void)setInfoWith:(id) model;
@end


