//
//  NewPeo_shareModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "SearchResulModel.h"
@class NewPeo_shareRuleInfo;
typedef void(^NewPeo_shareBlock)(NSMutableArray *goodArr,NSInteger time, NewPeo_shareRuleInfo *rule,NSMutableArray *tlj_list,NSError *error);
@interface NewPeo_shareModel : NSObject

+ (void)queryNewPeoGoodWithBlock:(NewPeo_shareBlock)block;

@end


@interface NewPeo_shareRuleInfo : NSObject
@property (nonatomic, copy) NSString *action_time;
@property (nonatomic, copy) NSString *action_user   ;
@property (nonatomic, copy) NSString *action_type;
@property (nonatomic, copy) NSString *action_content;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSData *imageData;
@end
