//
//  CouponListBlankView.h
//  MinPingZhangGui
//
//  Created by mc on 2019/1/8.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BlankViewInfo;
typedef void(^blankBlock)(void);
@interface CouponListBlankView : UIView

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (nonatomic, strong) BlankViewInfo *info;

@property (nonatomic, copy) blankBlock block;

- (void)setModel:(id)model;

@end



@interface BlankViewInfo : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString  *title; //文本框的文字
@property (nonatomic, assign) CGFloat  btnW;
@property (nonatomic, assign)BOOL isShowActionBtn ; //是否显示按钮。yes 显示

@property (nonatomic, copy) NSString *btnTitle; //按钮的文字

//提示网络错误
+ (instancetype)infoWithNoticeNetError;
@end

NS_ASSUME_NONNULL_END
