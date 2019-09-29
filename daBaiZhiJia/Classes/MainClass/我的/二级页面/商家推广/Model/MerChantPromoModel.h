//
//  MerChantPromoModel.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MerChantPromoModel : NSObject
+ (NSArray*)dataSource;
@end




@interface MerChantPromoInfo : NSObject
@property (nonatomic, assign) NSInteger  type;//1输入框类型的cell,2 按钮类型的cell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placehoder;
@property (nonatomic, copy) NSString *tfStr; //默认nil
@property (nonatomic, assign) NSInteger  tf_tag;//输入框的tag  1,2,3..

+ (instancetype)inifoWithType:(NSInteger)type title:(NSString*)title placehoder:(NSString*)placehoder tf_tag:(NSInteger)tf_tag;
@end
