//
//  IntelligenceSearchView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "IntelligenceSearchView.h"
#import "SearchResultContrl.h"
#import "SearchSaveManager.h"

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
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSLog(@"contentStr %@",contentStr);
    self.content.text = contentStr;
}

- (IBAction)clickaction:(UIButton *)sender {
    [self hideView];
    
    for (NSString *str in [SearchSaveManager getArray]) {//如果本地有，就清空
        if ([str isEqualToString:[UIPasteboard generalPasteboard].string]) {
            [UIPasteboard generalPasteboard].string = @"";
            NSLog(@"有。。%@",str);
            break;
        }
    }
    //保存在历史搜索里面
    NSMutableArray *temp  = [SearchSaveManager getArray];
    [temp insertObject:self.contentStr atIndex:0];
    [SearchSaveManager saveArrWithArr:temp];
    
    SearchResultContrl *sear = [[SearchResultContrl alloc] initWithSearchStr:self.contentStr];
    sear.searchType = sender.tag;
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

- (IBAction)closeAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = @"";
    [self hideView];
}

@end
