//
//  IndexTextField.h
//  zdbios
//
//  Created by skylink on 15/10/21.
//  Copyright © 2015年 skylink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexTextField : UITextField

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger section;

@end
