//
//  VEPictureSelect.h
//  VocationalEducation
//
//  Created by WH-JS on 2019/7/24.
//  Copyright © 2019 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VEPictureSelectDelegate <NSObject>
@required
-(void)iconChooseFinish:(UIImage*)img;
@end

@interface VEPictureSelect : NSObject

@property (nonatomic,weak) id <VEPictureSelectDelegate> delegate;


- (instancetype)initWithView:(UIViewController*)viewControll;

- (void)changeIcon:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
