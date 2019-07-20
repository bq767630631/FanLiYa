//
//  NewPeo_timeView.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPeo_timeView : UIView

@property (nonatomic, strong) NSTimer *timer;

- (void)setTime:(NSInteger)time;

@end


