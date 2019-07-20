//
//  ChangePersonContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/11.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"

typedef NS_ENUM(NSInteger, ChangeInfoType) {
    ChangeInfoType_niChen = 1,
    ChangeInfoType_wxNum = 2,
    
};
typedef void(^ChangePersonBlock)(NSString *str);
@interface ChangePersonContrl : MPZG_BaseContrl

- (instancetype)initWithType:(ChangeInfoType)type text:(NSString*)text;

@property (nonatomic, copy) ChangePersonBlock block;

@end




@interface PersonTF : UITextField

@end
