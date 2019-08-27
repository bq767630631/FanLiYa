//
//  HomePage_NewPersonPopV.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/8/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePage_Model.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomePage_NewPersonPopV : UIView
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;

@property (nonatomic, strong) UINavigationController *navi;
@property (nonatomic, strong) HomePage_bg_bannernfo *info;
- (void)show;
@end

NS_ASSUME_NONNULL_END
