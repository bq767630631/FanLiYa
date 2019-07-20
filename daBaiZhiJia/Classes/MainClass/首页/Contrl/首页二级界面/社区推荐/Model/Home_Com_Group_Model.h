//
//  Home_Com_Group_Model.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/24.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomePage_Model.h"

typedef void(^Home_Com_Group_block)(NSMutableArray *goodArr, NSString*logo,NSError *error);

@interface Home_Com_Group_Model : NSObject
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isHaveNomoreData;

- (void)queryDataWithBlock:(Home_Com_Group_block)block;

@end

