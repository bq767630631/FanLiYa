//
//  NewPeo_shareContentV.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPeo_timeView.h"

@interface NewPeo_shareContentV : UIView

@property (nonatomic, strong) NewPeo_timeView *timeV;


- (void)setInfoWith:(NSMutableArray*)arr time:(NSInteger)time rule:(id)rule tljList:(NSMutableArray*)tljList;



@end


