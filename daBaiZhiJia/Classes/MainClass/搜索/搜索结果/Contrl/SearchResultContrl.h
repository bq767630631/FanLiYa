//
//  SearchResultContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/3.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultContrl : MPZG_BaseContrl

- (instancetype)initWithSearchStr:(NSString *)str;

@property (nonatomic, assign) NSInteger  searchType;//1淘宝,2拼多多,3京东

@end

NS_ASSUME_NONNULL_END
