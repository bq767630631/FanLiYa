//
//  GoodDetail_ShengjiV.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^GoodDetail_ShengjiVBlock)(void);
@interface GoodDetail_ShengjiV : UIView

@property (nonatomic, copy) GoodDetail_ShengjiVBlock bloock;

- (void)setInfo:(NSString *)profit;



@end


