//
//  LimitSale_SecModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomePage_Model.h"

typedef void(^LimitSale_block)(NSMutableArray *goodArr, NSError *error);
@interface LimitSale_SecModel : NSObject

@property (nonatomic, copy) NSString *time_;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL isHaveNomoreData;

- (void)queryDataWithBlock:(LimitSale_block)block;


@end


