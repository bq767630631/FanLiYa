//
//  MyCombat_Bottom.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/1.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyCombat_Bottom.h"
#import "DBZJ_ComShareView.h"
@interface MyCombat_Bottom ()

@end
@implementation MyCombat_Bottom


- (IBAction)share:(UIButton *)sender {
    
    CGSize size = CGSizeMake(SCREEN_WIDTH,  self.contentV.line.top );
    UIImage*image = [self getmakeImageWithView: self.contentV andWithSize:size];
    DBZJ_ComShareView *share = [DBZJ_ComShareView viewFromXib];
    share.isFrom_haiBao = YES;
    share.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    share.model = image;
    [share show];
}

@end
