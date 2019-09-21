//
//  PDDOperationChannelContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"


/**
 *拼多多和京东运营频道商品
 */
@interface PDDOperationChannelContrl : MPZG_BaseContrl

//0, “1.9包邮”, 1, “今日爆款”, 2, “品牌清仓”, 非必填 ,默认是1
@property (nonatomic, assign) NSInteger  channel_type; //拼多多频道

//10：9.9专区、1: 好券商品、7：居家生活、 15：京东配送
@property (nonatomic, assign) NSInteger  type; //京东频道

@property (nonatomic, assign) FLYPT_Type  pt;
@end


