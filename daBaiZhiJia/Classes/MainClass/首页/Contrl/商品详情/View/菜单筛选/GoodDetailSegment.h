//
//  GoodDetailSegment.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^goodDetailSegmentBlock)(NSInteger type);//012
@interface GoodDetailSegment : UIView

@property (nonatomic, copy) goodDetailSegmentBlock typeBlock;

@property (nonatomic, assign) BOOL selfIsClick; //自己是否在点击防止卡顿


- (void)setSegmentToDetailToBaobei;

- (void)setSegmentToDetail;

- (void)setSegmentToTuiJian;
@end


