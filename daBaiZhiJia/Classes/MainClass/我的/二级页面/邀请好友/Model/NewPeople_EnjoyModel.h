//
//  NewPeople_EnjoyModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^NewPeople_Block)(NSArray*list);
@interface NewPeople_EnjoyModel : NSObject

+ (void)queryHaiBaoWitkBlcok:(NewPeople_Block)block;
@end


@interface  NewPeople_EnjoyInfo : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *pic;
@end

