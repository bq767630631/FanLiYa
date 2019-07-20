//
//  Home_EveeChoiCell.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Margin 107.f //图片底部距离cell的距离

#ifdef  IS_iPhone5SE
#define Item_Gap (5.f)
#else
#define Item_Gap (10.f)
#endif


NS_ASSUME_NONNULL_BEGIN

@interface Home_EveeChoiCell : UICollectionViewCell
- (void)setModel:(id)model;
@end

NS_ASSUME_NONNULL_END
