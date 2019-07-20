//
//  NSObject+Private.h
//  MinPingZhangGui
//
//  Created by mc on 2019/1/2.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Private)
- (UIViewController *)getCurrentVC ;

/**获取所有的cell*/
- (NSArray *)allCellsForTableView:(UITableView *)tableView;

//联系客服
- (void)connectKefuWithQQ:(NSString*)qq;

//打电话
- (void)makePhoneCallWithVith:(UIView*)onview num:(NSString *)num;

//延迟一秒执行
- (void)delayDoWork:(CGFloat)time WithBlock:(void (^)(void)) block;

//是否安装qq
- (BOOL)isInstallQQ;

//根据视图和大小生成图片
- (UIImage *)getmakeImageWithView:(UIView *)view andWithSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
@interface NSLayoutConstraint (Private)
//适配6plus
- (CGFloat)constantForAdaptationPlus;
@end
