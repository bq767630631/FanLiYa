//
//  CountDownTime.m
//  zdbios
//
//  Created by skylink on 2016/12/15.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import "CountDownTime.h"
#import "NSTimer+Extention.h"

@interface CountDownTime(){

    NSInteger downCount;
}

@property (nonatomic, strong) NSTimer *pollingTimer;

@end

@implementation CountDownTime

-(instancetype)init {

    self = [super init];
    if (self) {
    

    }
    return self;
}

- (void)dealloc {

    [_pollingTimer invalidate];
    _pollingTimer = nil;
}

- (void)starCountDown {
    downCount = 60;
    
    @weakify(self);
    _pollingTimer = [NSTimer extScheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
        
        @strongify(self);
        [self timerEvent];
    }];
}

- (void)timerEvent {
    
    if (downCount < 0) {
        [self stopCountDown];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(countDownTimeWithCurrentCount:)]) {
        [self.delegate countDownTimeWithCurrentCount:downCount--];
    }
}


- (void)stopCountDown {
    
    [_pollingTimer invalidate];
}

@end
