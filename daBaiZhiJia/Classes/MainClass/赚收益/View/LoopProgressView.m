//
//  LoopProgressView.m
//  头像蒙板
//
//  Created by CUG on 16/1/29.
//  Copyright © 2016年 CUG. All rights reserved.
//

#import "LoopProgressView.h"
#import <QuartzCore/QuartzCore.h>

#define ViewWidth self.frame.size.width   //环形进度条的视图宽度
#define ProgressWidth 8                //环形进度条的圆环宽度
#define Radius ViewWidth/2-ProgressWidth  //环形进度条的半径
//#define RGBA(r, g, b, a)   [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a)]
#define RGB(r, g, b)        RGBA(r, g, b, 1.0)

@interface LoopProgressView()
{
    CAShapeLayer *arcLayer;
    UILabel *label;
    NSTimer *progressTimer;
    UIView *dotV;
}
@property (nonatomic, assign) CGFloat i;

@end

@implementation LoopProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        //圆点
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(self.width*0.5-2, 5.5, 4, 4)];
        v.backgroundColor = UIColor.whiteColor;
        ViewBorderRadius(v,2, UIColor.whiteColor);
        [self addSubview:v];
        dotV = v;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _i = 0;
    //
 
    CGContextRef progressContext = UIGraphicsGetCurrentContext();
    CGContextClearRect(progressContext, rect);
    CGContextSetLineWidth(progressContext, ProgressWidth);
    CGContextSetRGBStrokeColor(progressContext, 245/255.0, 245/255.0, 245/255.0, 1);
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    //绘制环形进度条底框
    CGContextAddArc(progressContext, xCenter, yCenter, Radius, 0, 2*M_PI, 0);
    CGContextDrawPath(progressContext, kCGPathStroke);
    
    //    //绘制环形进度环
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI *2; // - M_PI * 0.5为改变初始位置
    
    // 进度数字字号,可自己根据自己需要，从视图大小去适配字体字号
//    int fontNum = ViewWidth/6;
    int weight = ViewWidth - ProgressWidth*2;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, weight, 12)];
    label.center = CGPointMake(xCenter, yCenter);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = RGB(34, 34, 34);
    [self addSubview:label];
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(xCenter,yCenter) radius:Radius startAngle:- M_PI * 0.5 endAngle:to clockwise:YES];
    arcLayer = [CAShapeLayer layer];
    arcLayer.path = path.CGPath;
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor = self.strokeColor.CGColor;
    arcLayer.lineWidth = ProgressWidth;
    arcLayer.lineCap = @"round";
    arcLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    [self.layer addSublayer:arcLayer];
  
       label.text = self.lbStr;
    [self.layer insertSublayer:dotV.layer above:arcLayer];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self drawLineAnimation:arcLayer];
//    });
    
    if (self.progress > 1) {
        NSLog(@"传入数值范围为 0-1");
        self.progress = 1;
    }else if (self.progress < 0){
        NSLog(@"传入数值范围为 0-1");
        self.progress = 0;
        return;
    }
    
//    if (self.progress > 0) {
//        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(newThread) object:nil];
//        [thread start];
//    }
    
}

-(void)newThread
{
    @autoreleasepool {
        progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeLabel) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

//NSTimer不会精准调用  虚拟机和真机效果不一样
-(void)timeLabel
{
    _i += 0.01;
   
    dispatch_async( dispatch_get_main_queue(), ^{
        //self->label.text = [NSString stringWithFormat:@"%.f%%",_i*100];
        self->label.text = self.lbStr;
    });
    
    if (_i >= self.progress) {
        dispatch_async( dispatch_get_main_queue(), ^{
           // self->label.text = [NSString stringWithFormat:@"%.f%%",self.progress*100];
              self->label.text = self.lbStr;
        });
       
        [progressTimer invalidate];
        progressTimer = nil;
        
    }
    
}

//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=self.progress;//动画时间
    //bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

@end
