//
//  DBZJ_CommunityHead.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^communityHeadBlock)(NSInteger index);//1:新品 2:营销 3:新手
@interface DBZJ_CommunityHead : UIView

@property (nonatomic, assign) CGFloat headHeight;

@property (nonatomic, copy) communityHeadBlock block;

- (void)setBtnSelectedWithIndex:(NSInteger)index;

//- (void)setLogoWithImage:(NSString*)imageUrl;

@end

NS_ASSUME_NONNULL_END
