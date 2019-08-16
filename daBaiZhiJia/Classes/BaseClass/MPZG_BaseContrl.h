//
//  MPZG_BaseContrl.h
//  MinPingZhangGui
//
//  Created by 包强 on 2018/12/24.
//  Copyright © 2018 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPZG_BaseContrl : UIViewController

- (void)clickToHideKeyboard;


/**
 *  生成导航栏右侧图片按钮
 *
 *  @param imageName 图片名称
 */
- (void)initRightBarButtonWithImage:(NSString *)imageName;

- (void)onTapRightBarButton;
@end

NS_ASSUME_NONNULL_END
