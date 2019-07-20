//
//  NSString+URLErrorString.h
//  zdbios
//
//  Created by skylink on 16/9/26.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLErrorString)

+ (NSString *)urlErrorMsgWithError:(NSError *)error;

@end
