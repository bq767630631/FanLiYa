//
//  MyCollecTionCell.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseTableViewCell.h"
typedef void(^mineCollecTionGoodsCellSelectBlock)(NSIndexPath * _Nullable indexPath ,BOOL isSelected);
NS_ASSUME_NONNULL_BEGIN

@interface MyCollecTionCell : MPZG_BaseTableViewCell
@property (nonatomic, copy) mineCollecTionGoodsCellSelectBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
