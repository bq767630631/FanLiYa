//
//  NSTimer+Extention.m
//  lfldelinDemo
//
//  Created by lfldelin on 2016/11/21.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import "NSTimer+Extention.h"

@implementation NSTimer (Extention)

+ (NSTimer *)extScheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {

    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(extBlockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)extBlockInvoke:(NSTimer *)timer {

    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
