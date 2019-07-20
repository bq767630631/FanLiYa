//
//  Home_AdVerView.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/12.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** 播报、广告视图*/
@interface Home_AdVerView : UIView
- (void)setBroadCastInfoWith:(BOOL)isShowNew strArr:(NSMutableArray*)strAtt;

- (void)setAdvInfoWithArr:(NSMutableArray*)arr;
@end

NS_ASSUME_NONNULL_END
