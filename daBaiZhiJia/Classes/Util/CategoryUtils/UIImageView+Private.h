//
//  UIImageView+Private.h
//  MinPingZhangGui
//
//  Created by mc on 2018/12/27.
//  Copyright © 2018 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Private)
//

//全路径
- (void)setDefultPlaceholderWithFullPath:(NSString *)fullPath;

- (void)setPlaceholderImageWithFullPath:(NSString *)fullPath placeholderImage:(NSString*)imageName;
@end

NS_ASSUME_NONNULL_END
