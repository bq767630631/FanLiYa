//
//  DetailWebContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"

@interface DetailWebContrl : MPZG_BaseContrl

- (instancetype)initWithUrl:(NSString*)url title:(NSString*)title para:(NSDictionary*)para;

@property (nonatomic, assign) BOOL  isFromhomeTab;
@end

