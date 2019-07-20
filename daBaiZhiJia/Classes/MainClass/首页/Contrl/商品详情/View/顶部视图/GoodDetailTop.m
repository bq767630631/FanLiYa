//
//  GoodDetailTop.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/15.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailTop.h"
#import "CreateShareContrl.h"
#import "LoginContrl.h"
#import "CreateShare_Model.h"

@interface GoodDetailTop ()

@end
@implementation GoodDetailTop

- (IBAction)returnAction:(UIButton *)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(UIButton *)sender {
    if ([self judgeisLogin]) {
        [CreateShare_Model geneRateTaoKlWithSku:self.info.sku vc:self.viewController navi_vc:self.viewController.navigationController  block:^(NSString *tkl, NSString *code, NSString *shorturl) {
            if (tkl) {
                CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:self.info.sku];
                [self.viewController.navigationController pushViewController:share animated:YES];
            }
        }];
    }
}


- (BOOL)judgeisLogin{
       NSString *token = ToKen;
    if (User_ID >0&&token.length >0) {
        return YES;
    }else{
        [self.viewController.navigationController pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
    
}
@end
