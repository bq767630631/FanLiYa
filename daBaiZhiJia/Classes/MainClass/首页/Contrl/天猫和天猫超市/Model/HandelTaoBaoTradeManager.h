//
//  HandelTaoBaoTradeManager.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/5.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *淘宝交易管理类
 */
@interface HandelTaoBaoTradeManager : NSObject

+ (void)openTaoBaoAndTraWithUrl:(NSString*)url navi:(UINavigationController*)navi;

+ (void)openCartWithNavi:(UINavigationController*)navi;
@end


