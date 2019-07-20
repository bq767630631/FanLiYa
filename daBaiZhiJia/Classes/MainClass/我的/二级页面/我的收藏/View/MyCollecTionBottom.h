//
//  MyCollecTionBottom.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^mineCollectionFootBlock)(NSInteger type, BOOL isSelect); //type 1全选  2删除
@interface MyCollecTionBottom : UIView
@property (nonatomic, copy) mineCollectionFootBlock block;
- (void)setModelWithArray:(NSArray*)arr;
@end

NS_ASSUME_NONNULL_END
