//
//  NSTimer+Extention.h
//  lfldelinDemo
//
//  Created by lfldelin on 2016/11/21.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extention)

+ (NSTimer *)extScheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;

@end
