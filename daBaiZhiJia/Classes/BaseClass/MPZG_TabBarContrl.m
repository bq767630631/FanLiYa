//
//  MPZG_TabBarContrl.m
//  MinPingZhangGui
//
//  Created by 包强 on 2018/12/24.
//  Copyright © 2018 包强. All rights reserved.
//

#import "MPZG_TabBarContrl.h"
#import "MPZG_NavigationContrl.h"
#import "DBZJ_HomeViewContrl.h"
#import "DBZJ_MineContrl.h"
#import "DBZJ_IncomeContrl.h"
#import "DBZJ_SearchContrl.h"
#import "DBZJ_CommunityContrl.h"
#import "BillBoard_Contrl.h"
#import <objc/runtime.h>
#import "MessageManger.h"

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7.0
@interface MPZG_TabBarContrl ()

@end

@implementation MPZG_TabBarContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tabBarInitialise];
    self.tabBar.backgroundColor = [UIColor whiteColor];///不透明
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UITabBarItem *item = self.tabBar.items[2];
    item.imageInsets = UIEdgeInsetsMake(-18, 0, 0, 0);
}


- (void)tabBarInitialise {
    UIViewController *viewCtrl = [[DBZJ_HomeViewContrl alloc] init];
     self.delegate = (DBZJ_HomeViewContrl*)viewCtrl;
    [self addChildViewController:viewCtrl
                           title:@"首页"
                       imageName:@"homePage_default"
               selectedImageName:@"homePage_hight"];
    
    viewCtrl = [BillBoard_Contrl new];
    [self addChildViewController:viewCtrl
                           title:@"榜单"
                       imageName:@"icon_toped_unselect"
               selectedImageName:@"icon_toped_select"];
    
    viewCtrl = [DBZJ_IncomeContrl new];
  [self addChildViewController:viewCtrl
                           title:@"赚钱鸭"
                       imageName:@"icon_zhuanshouyi"
               selectedImageName:@"icon_zhuanshouyi"];
    
    viewCtrl = [DBZJ_CommunityContrl new];
    [self addChildViewController:viewCtrl
                           title:@"社区"
                       imageName:@"icon_shequn_unselect"
               selectedImageName:@"icon_shequn_select"];
    
    viewCtrl = [DBZJ_MineContrl new];
    [self addChildViewController:viewCtrl
                           title:@"我的"
                       imageName:@"mine_default"
               selectedImageName:@"mine_hight"];
    
    
}


#pragma mark - private method
/**
 * 添加子控制器
 * @param childViewCtrl       子控制器
 * @param title               标题
 * @param imageName           标题
 * @param selectedImageName   被选中的图片
 */
- (void)addChildViewController:(UIViewController *)childViewCtrl title:(NSString *)title imageName:(NSString *)imageName
             selectedImageName:(NSString *)selectedImageName {
    childViewCtrl.tabBarItem.title = title; //只设置tabbar的标题
    childViewCtrl.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = RGBA(153, 153, 153, 1);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10.f];
    [childViewCtrl.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = RGBA(51, 51, 51, 1);
    selectedTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10.f];
    [childViewCtrl.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    if (IOS7) {
        // 在iOS7中, 会对selectedImage的图片进行再次渲染为蓝色
        // 声明这张图片用原图(别渲染)
        childViewCtrl.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else {
        
        childViewCtrl.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    }
    
    MPZG_NavigationContrl *childNav = [[MPZG_NavigationContrl alloc] initWithRootViewController:childViewCtrl];

    [self addChildViewController:childNav];
}


@end


@interface CustomTabBar:UITabBar

@end


@implementation CustomTabBar

#pragma mark -  -----------------以下两个方法解决ios12.1tabbar图标位移问题，如以后IOS12.1解决则可移除--------------

/**
 *  用 block 重写某个 class 的指定方法
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
 *  @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现，所以要在内部自己处理对 super 的调用，以及对当前调用方法的 self 的 class 的保护判断（因为如果 targetClass 的 targetSelector 是继承自父类的，targetClass 内部并没有重写这个方法，则我们这个函数最终重写的其实是父类的 targetSelector，所以会产生预期之外的 class 的影响，例如 targetClass 传进来  UIButton.class，则最终可能会影响到 UIView.class），implementationBlock 的参数里第一个为你要修改的 class，也即等同于 targetClass，第二个参数为你要修改的 selector，也即等同于 targetSelector，第三个参数是 targetSelector 原本的实现，由于 IMP 可以直接当成 C 函数调用，所以可利用它来实现“调用 super”的效果，但由于 targetSelector 的参数个数、参数类型、返回值类型，都会影响 IMP 的调用写法，所以这个调用只能由业务自己写。
 */

CG_INLINE BOOL
OverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP originIMP)) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP originIMP = method_getImplementation(originMethod);
    method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMP)));
    return YES;
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 12.1, *)) {
            OverrideImplementation(NSClassFromString(@"UITabBarButton"), @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP originIMP) {
                return ^(UIView *selfObject, CGRect firstArgv) {
                    
                    if ([selfObject isKindOfClass:originClass]) {
                        // 如果发现即将要设置一个 size 为空的 frame，则屏蔽掉本次设置
                        if (!CGRectIsEmpty(selfObject.frame) && CGRectIsEmpty(firstArgv)) {
                            return;
                        }
                    }
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originIMP;
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                };
            });
        }
    });
}


@end

@interface XPTabBarButton : UIView

@end

@implementation XPTabBarButton

+ (void)initialize {
    if (@available(iOS 12.1, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class originalClass = NSClassFromString(@"UITabBarButton");
            SEL originalSelector = @selector(setFrame:);
            SEL swizzledSelector = @selector(xp_setFrame:);
            
            Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            class_replaceMethod(originalClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
            class_replaceMethod(originalClass,
                                originalSelector,
                                method_getImplementation(swizzledMethod),
                                method_getTypeEncoding(swizzledMethod));
        });
    }
}

- (void)xp_setFrame:(CGRect)frame {
    if (!CGRectIsEmpty(self.frame)) {
        // for iPhone 8/8Plus
        if (CGRectIsEmpty(frame)) {
            return;
        }
        // for iPhone XS/XS Max/XR
        frame.size.height = MAX(frame.size.height, 48.0);
    }
    [self xp_setFrame:frame];
}

@end
