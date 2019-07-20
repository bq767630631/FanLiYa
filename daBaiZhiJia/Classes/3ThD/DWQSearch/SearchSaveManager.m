//
//  SearchSaveManager.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/3.
//  Copyright © 2019 包强. All rights reserved.
//

#import "SearchSaveManager.h"
static NSString *arrayKey = @"arrayKey";
static NSInteger maxLen = 5; //存储最大长度
@implementation SearchSaveManager

+ (void)saveArrWithArr:(NSArray *)array{
    NSMutableArray *saveArr = [NSMutableArray arrayWithArray:array];
    if (array.count > maxLen ) {
        [saveArr removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:saveArr forKey:arrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)getArray{
    NSMutableArray *obj = [[NSUserDefaults standardUserDefaults] objectForKey:arrayKey];
    return  [NSMutableArray arrayWithArray:obj];
}

+ (void)deleteArray{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:arrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
