//
//  AppGuidePlayV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/15.
//  Copyright © 2019 包强. All rights reserved.
//

#import "AppGuidePlayV.h"
#import "ZQPlayer.h"

@interface AppGuidePlayV()<ZQPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;

@property (weak, nonatomic) IBOutlet UIView *playV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playV_Wd;

@property (weak, nonatomic) IBOutlet UIButton *rePlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *goHomeBtn;
@property (nonatomic, strong) ZQPlayer *audioPlayer;

@property (nonatomic, assign) CGFloat  totalTime;
@end

@implementation AppGuidePlayV
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.goHomeBtn, 20, UIColor.clearColor);
    self.playV_Wd.constant =  self.playV_Wd.constant* SCALE_Normal;
    self.rePlayBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}

- (void)setUpAudioPlayer{
    self.audioPlayer = [[ZQPlayer alloc] init];
    self.audioPlayer.isPlaying =  NO; 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"guideVideo" ofType:@"mp4"];
    [self.audioPlayer nextWithUrl:path];
     self.audioPlayer.delegate = self;
     self.audioPlayer.playerLayer.frame = self.playV.bounds;
     [self.playV.layer addSublayer:self.audioPlayer.playerLayer];
     [self.playV.layer insertSublayer:self.rePlayBtn.layer above:self.audioPlayer.playerLayer];
}

- (IBAction)playBtn:(UIButton *)sender {
    [self.audioPlayer play];
}

- (IBAction)goHomeBtn:(UIButton *)sender {
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:GuideViewLoadFinishNotification object:nil];
}

#pragma mark - ZQPlayerDelegate
- (void)ZQPlayerStateChange:(ZQPlayer *)player state:(ZQPlayerState)state{
    if (state==ZQPlayerStateStop) {
        self.rePlayBtn.hidden = NO;
    }else{
        self.rePlayBtn.hidden = YES;
    }
    if (state ==ZQPlayerStatePlaying ) {
        self.skipBtn.hidden = NO;
    }else{
        self.skipBtn.hidden = YES;
    }
}

- (void)ZQPlayerTotalTime:(ZQPlayer *)player totalTime:(CGFloat)time{
    self.totalTime = time;
}

- (void)ZQPlayerCurrentTime:(ZQPlayer *)player currentTime:(CGFloat)time{
    CGFloat timeGap  = self.totalTime - time;
    if (timeGap >0) {
          [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过(%.fs)",timeGap] forState:UIControlStateNormal];
    }
   
    if (time ==_totalTime) {
        self.skipBtn.hidden = YES;
    }else{
        self.skipBtn.hidden = NO;
    }
}


@end
