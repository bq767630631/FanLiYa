//
//  NewNoviceGuideFirst.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewNoviceGuideFirst.h"
#import "HandelTaoBaoTradeManager.h"

@implementation NewNoviceGuideFirst
- (IBAction)action:(id)sender {
    if (self.url) {
         [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:self.url navi:self.viewController.navigationController];
    }
}



@end
