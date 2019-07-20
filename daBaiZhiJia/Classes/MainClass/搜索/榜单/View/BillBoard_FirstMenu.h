//
//  BillBoard_FirstMenu.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/14.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^BillBoard_FirstMenuBlock)(NSInteger type);//1,2,3
//第一个筛选
@interface BillBoard_FirstMenu : UIView

@property (nonatomic, copy) BillBoard_FirstMenuBlock clickBlock;

- (void)setBtnSelectWithType:(NSInteger)type;
@end


