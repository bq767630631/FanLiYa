//
//  YdwTagView.m
//  DWQSearchWithHotAndHistory
//  ----------------------搜索用的标签View、----------------------
//  Created by 杜文全 on 16/8/14.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.

#import "DWQTagView.h"
/** 字体离边框的水平距离 */
#define HORIZONTAL_PADDING 15.0f
/** 字体离边框的竖直距离 */
#define VERTICAL_PADDING   10.0f
/** tagLab之间的水平间距 */
#define HORIZONTAL_MARGIN  10.0f
/** tagLab之间的竖直间距 */
#define VERTICAL_MARGIN    10.0f
@implementation DWQTagView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        totalHeight = 0;
        self.userInteractionEnabled = YES;
        self.frame = frame;
    }
    return self;
}

- (void)setTagWithTagArray:(NSArray*)arr{

    /**
     *  很关键——————防止放于cell上时复用重复创建
     *  让第之后创建totalHeight重新置为0
     *  删除之前存在的subView
     */
    totalHeight = 0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    /***************************************/
    
    previousFrame = CGRectZero;
    
    for (NSString *textStr in arr) {
        UILabel *tag = [[UILabel alloc] initWithFrame:CGRectZero];
        tag.userInteractionEnabled = YES;
//        UIButton*tag = [UIButton buttonWithType:0];
        tag.frame = CGRectZero;
        if(_singleTagColor){
            //可以单一设置tag的颜色
            tag.backgroundColor = _singleTagColor;
        }else{
            //tag颜色默认白色
            tag.backgroundColor = [UIColor whiteColor];
        }
        tag.textAlignment = NSTextAlignmentCenter;
        tag.textColor = RGBColor(128, 128, 128);
        tag.font = [UIFont boldSystemFontOfSize:12];
        tag.text = textStr;
        
        tag.layer.borderWidth = .5;
        tag.layer.borderColor = RGBColor(245, 245, 245).CGColor;
        tag.clipsToBounds = YES;
        
        [textStr textSizeWithFont:[UIFont boldSystemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH-HORIZONTAL_PADDING*2, 20)];
        
        
        CGSize textStrSize = [textStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
       
        textStrSize.width += HORIZONTAL_PADDING*2;
        textStrSize.height += VERTICAL_PADDING*2;
        
        CGFloat maxW =  SCREEN_WIDTH - HORIZONTAL_PADDING*2;
        if (textStrSize.width > maxW) {//超出最大边框得做判断
            textStrSize.width = maxW;
        }
        if (textStrSize.height > 34.32) {
            textStrSize.height = 34.32;
        }
        
        NSLog(@"textStrSize %@",NSStringFromCGSize(textStrSize));
        CGRect newRect = CGRectZero;
        
        /** 如果新的tagLab超出屏幕边界 */
        if (previousFrame.origin.x + previousFrame.size.width + textStrSize.width + HORIZONTAL_MARGIN > self.bounds.size.width) {
            newRect.origin = CGPointMake(10, previousFrame.origin.y + textStrSize.height + VERTICAL_MARGIN);
            totalHeight += textStrSize.height + VERTICAL_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + HORIZONTAL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = textStrSize;
        
        [tag setFrame:newRect];
        tag.layer.cornerRadius = tag.height *0.5;
        previousFrame = tag.frame;
       // NSLog(@"newRect %@",NSStringFromCGRect(newRect));
        [self setHight:self andHight:totalHeight + textStrSize.height];
        [self addSubview:tag];
//        [tag addTarget:self action:@selector(touchSubTagViewClick:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSubTagView:)];
        tapOne.delegate = self;
        tapOne.numberOfTapsRequired = 1.0;
        [tag addGestureRecognizer:tapOne];
    }
    if(_BigBGColor){
        self.backgroundColor=_BigBGColor;
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
}

-(void)touchSubTagView:(UITapGestureRecognizer*)tapOne
{
    UILabel *lab = (UILabel *)tapOne.view;
//    NSLog(@"%@",lab.text);
    if (self.delegate && [self.delegate respondsToSelector:@selector(DWQTagView:fetchWordToTextFiled:)]) {
        [self.delegate DWQTagView:self fetchWordToTextFiled:lab.text];
    }
}
#pragma mark-改变子tag控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}

@end
