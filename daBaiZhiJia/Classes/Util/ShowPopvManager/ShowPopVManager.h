//
//  ShowPopVManager.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ShowPopVManager : NSObject
+ (instancetype)shareInstance;

@property (nonatomic, copy) NSString *pasBoardStr;

- (void)showPopV;
@end


