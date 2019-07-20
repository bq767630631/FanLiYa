//
//  IntelligenceSearchView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "IntelligenceSearchView.h"
#import "SearchResultContrl.h"
@interface IntelligenceSearchView ()

@property (weak, nonatomic) IBOutlet UILabel *content;

@end
@implementation IntelligenceSearchView
- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self
                     , 5, UIColor.clearColor);
}
- (void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    self.content.text = contentStr;
}

- (IBAction)cancleAction:(UIButton *)sender {
    [self hideView];
}

- (IBAction)searchAction:(UIButton *)sender {
     [self hideView];
    SearchResultContrl *sear = [[SearchResultContrl alloc] initWithSearchStr:self.contentStr];
   UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSLog(@"rootVc  %@",rootVc);
    UINavigationController *navi ;
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        navi = (UINavigationController*)rootVc;
    }else if ([rootVc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController*)rootVc;
        navi = rootVc.childViewControllers[tab.selectedIndex];
    }else{
        UIViewController *vc = [UIViewController new];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    [navi pushViewController:sear animated:YES];
}


@end
