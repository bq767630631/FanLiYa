//
//  UIImageView+Private.m
//  MinPingZhangGui
//
//  Created by mc on 2018/12/27.
//  Copyright © 2018 包强. All rights reserved.
//

#import "UIImageView+Private.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Private)


- (void)setDefultPlaceholderWithFullPath:(NSString *)fullPath{
     [self sd_setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:[UIImage imageNamed:@"goodImg-blank"]];
}

- (void)setPlaceholderImageWithFullPath:(NSString *)fullPath placeholderImage:(NSString*)imageName{
    [self sd_setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:[UIImage imageNamed:imageName]];
}
@end
