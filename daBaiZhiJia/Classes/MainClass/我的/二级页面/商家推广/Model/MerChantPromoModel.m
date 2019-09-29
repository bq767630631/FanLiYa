//
//  MerChantPromoModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MerChantPromoModel.h"

@implementation MerChantPromoModel
+ (NSArray *)dataSource{
    NSMutableArray *temp = [NSMutableArray array];
    MerChantPromoInfo *info1 = [MerChantPromoInfo inifoWithType:1 title:@"店铺名" placehoder:@"请输入店铺名" tf_tag:1];
    MerChantPromoInfo *info2 = [MerChantPromoInfo inifoWithType:2 title:@"平台" placehoder:nil tf_tag:0];
    MerChantPromoInfo *info3 = [MerChantPromoInfo inifoWithType:1 title:@"联系人姓名" placehoder:@"请输入联系人真实姓名" tf_tag:3];
    MerChantPromoInfo *info4 = [MerChantPromoInfo inifoWithType:1 title:@"手机号码" placehoder:@"请输入联系人手机号码" tf_tag:4];
    MerChantPromoInfo *info5 = [MerChantPromoInfo inifoWithType:1 title:@"微信号码" placehoder:@"请输入联系人微信号" tf_tag:5];
    MerChantPromoInfo *info6 = [MerChantPromoInfo inifoWithType:1 title:@"店铺链接" placehoder:@"请输入店铺链接" tf_tag:6];

    [temp addObject:info1];
    [temp addObject:info2];
    [temp addObject:info3];
    [temp addObject:info4];
    [temp addObject:info5];
    [temp addObject:info6];
    return temp;
}

@end


@implementation MerChantPromoInfo

+ (instancetype)inifoWithType:(NSInteger)type title:(NSString *)title placehoder:(NSString *)placehoder tf_tag:(NSInteger)tf_tag{
    MerChantPromoInfo *info = [MerChantPromoInfo new];
    info.type = type;
    info.title = title;
    info.placehoder = placehoder;
    info.tf_tag = tf_tag;
    info.tfStr = @"";
    return info;
}

@end
