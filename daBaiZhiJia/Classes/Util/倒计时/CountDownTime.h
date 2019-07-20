//
//  CountDownTime.h
//  zdbios
//
//  Created by skylink on 2016/12/15.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CountDownTimeDelegate;

@interface CountDownTime : NSObject

@property (nonatomic, assign) id<CountDownTimeDelegate> delegate;

- (void)starCountDown;

- (void)stopCountDown;

@end


@protocol CountDownTimeDelegate <NSObject>

- (void)countDownTimeWithCurrentCount:(NSInteger)count;

@end
