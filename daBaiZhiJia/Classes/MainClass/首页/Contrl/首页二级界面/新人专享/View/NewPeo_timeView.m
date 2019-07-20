//
//  NewPeo_timeView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_timeView.h"
#import "MJProxy.h"
@interface NewPeo_timeView ()
@property (weak, nonatomic) IBOutlet UILabel *day_1;
@property (weak, nonatomic) IBOutlet UILabel *day_2;
@property (weak, nonatomic) IBOutlet UILabel *hour_1;
@property (weak, nonatomic) IBOutlet UILabel *hour_2;
@property (weak, nonatomic) IBOutlet UILabel *minute_1;
@property (weak, nonatomic) IBOutlet UILabel *minute_2;
@property (weak, nonatomic) IBOutlet UILabel *sec_1;
@property (weak, nonatomic) IBOutlet UILabel *sec_2;

@property (nonatomic, assign) NSInteger dif_time;
@end


@implementation NewPeo_timeView

- (void)setTime:(NSInteger)time{
    
    self.dif_time = time;
    if (time > 0) {
        [self.timer fire];
    }
}


- (void)timeAction{
   
    self.dif_time --;

    NSInteger day = self.dif_time /(3600*24);
    NSString *day1 = @"0";
    NSString *day2 = [NSString stringWithFormat:@"%ld",day%10];
    if (day >9) {
        day1 = [NSString stringWithFormat:@"%ld",day/10];
    }
    
    NSInteger hour =  self.dif_time/60/60%24;
    NSString *hour1  = @"0";
    NSString *hour2 = [NSString stringWithFormat:@"%ld",hour%10];
    
    if (hour >9) {
        hour1 = [NSString stringWithFormat:@"%ld",hour/10];
    }
    

    NSInteger minute = self.dif_time/60%60;//分钟的。
    NSString *minu1= @"0";
    NSString *minu2= [NSString stringWithFormat:@"%ld",minute%10];
    if (minute >9) {
          minu1 = [NSString stringWithFormat:@"%ld",minute/10];
    }
    
    NSInteger second =  self.dif_time%60;//秒
    NSString *sec1 = @"0";
    NSString *sec2 = [NSString stringWithFormat:@"%ld",second%10];
    if (minute >9) {
        sec1 = [NSString stringWithFormat:@"%ld",second/10];
    }
   
    self.day_1.text = day1;
    self.day_2.text = day2;
    
    self.hour_1.text = hour1;
    self.hour_2.text = hour2;
    
    self.minute_1.text = minu1;
    self.minute_2.text = minu2;
    
    self.sec_1.text = sec1;
    self.sec_2.text = sec2;
    
 //   NSLog(@"%@%@  %@%@  %@%@  %@%@",day1,day2,hour1,hour2,minu1,minu2,sec1,sec2);
    if (self.dif_time <=0) {
        [self.timer invalidate];
        self.timer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:NewPeo_CountdownNotifation object:nil];
    }
}

#pragma mark - getter
- (NSTimer *)timer{
    if (!_timer) {
        _timer =[NSTimer timerWithTimeInterval:1 target:[MJProxy proxyWithTarget:self] selector:@selector(timeAction) userInfo:nil repeats:YES] ;
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
@end
