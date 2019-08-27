//
//  GoodDetailHeadView.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailSegment.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^wkWebViewHeightBlock)(CGFloat  contentHeight, BOOL isSelected);//是否展开
@interface GoodDetailHeadView : UIView

@property (weak, nonatomic) IBOutlet UIView *line3;

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIView *detailV;

- (void)setInfo:(id)detailinfo tuijianArr:(NSMutableArray*)goodArray;

@property (copy, nonatomic) wkWebViewHeightBlock heightBlock;

@property (nonatomic, strong) GoodDetailSegment *segMenu;

@property (nonatomic, assign) CGFloat webTop;

@property (nonatomic, assign) CGFloat likeVTop;

@property (nonatomic, assign) BOOL  iszhankai;
@end

NS_ASSUME_NONNULL_END
