//
//  CreateshareContent.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateShare_CellInfo;


@interface CreateshareContent : UIView

@property (nonatomic, strong) CreateShare_CellInfo *selectedInfo;



- (void)setInfoWithModel:(id)model;


@end

