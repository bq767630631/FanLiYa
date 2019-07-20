//
//  SearchResultMenu.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/3.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>
//价格 默认升序   销量 默认降序
typedef void(^SearchMenueBlock)(NSString * _Nullable searchType);//排序(取值：sales/ratio/price/stoptime 对应：销量/佣金比例/价格/优惠券到期时间)

typedef void(^SearchSwitchBlock)(BOOL isSelected);
NS_ASSUME_NONNULL_BEGIN
/*搜索框筛选栏*/
@interface SearchResultMenu : UIView

@property (nonatomic, copy) SearchMenueBlock searchBlock;

@property (nonatomic, copy) SearchSwitchBlock switchBlock;
@end

NS_ASSUME_NONNULL_END
