//
//  DBZJ_ComNewHandCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_ComNewHandCell.h"
#import "IndexButton.h"
#import "DBZJ_CommunityModel.h"
#import <AVKit/AVKit.h>

@interface DBZJ_ComNewHandCell ()
@property (weak, nonatomic) IBOutlet UIImageView *images;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet IndexButton *playBtn;

@property (nonatomic, strong) CommunityRecommendInfo *info;

@end
@implementation DBZJ_ComNewHandCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setInfoWithModel:(id)model{
     CommunityRecommendInfo *info = model;
    self.info = info;
    self.playBtn.indexPath = info.indexPath;
    [self.images setDefultPlaceholderWithFullPath:info.live_pic];
    self.title.text = info.title;
}

- (IBAction)playBtn:(IndexButton *)sender {
    NSString *webVideoPath = self.info.live_url;
    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
    AVPlayerViewController *avPlayerVC = [[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [self.viewController presentViewController:avPlayerVC animated:YES completion:nil];
}


@end
