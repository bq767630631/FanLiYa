//
//  IndexButton.h
//  zdbios
//
//  Created by skylink on 15/10/21.
//  Copyright © 2015年 skylink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexButton : UIButton

@property (nonatomic) NSInteger section;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
