//
//  CreateshareBottom.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^activityVCShowBlock)(void);
/**
 *底部分享视图
 */
@class CreateShare_CellInfo,CommunityRecommendInfo;
@interface CreateshareBottom : UIView

@property (nonatomic, strong) id model;

#pragma mark - 分享
@property (nonatomic, strong) CreateShare_CellInfo *selectedInfo;
@property (nonatomic, strong) UIImage *postImage;
@property (nonatomic, strong) NSArray<NSString*>*pics;

#pragma mark - 社区
@property (nonatomic, assign) BOOL  isFrom_sheQu;//是否来自社区
@property (nonatomic, strong) UIViewController *cur_vc;
@property (nonatomic, strong) CommunityRecommendInfo *comInfo;
@property (nonatomic, copy) activityVCShowBlock block;

#pragma mark - 海报
@property (nonatomic, assign) BOOL  isFrom_haiBao;//是否来自海报

@end

