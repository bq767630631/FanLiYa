//
//  SearchSaveManager.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/3.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchSaveManager : NSObject

+ (void)saveArrWithArr:(NSArray *)array;

+ (NSMutableArray *)getArray;

+ (void)deleteArray;

@end

NS_ASSUME_NONNULL_END
