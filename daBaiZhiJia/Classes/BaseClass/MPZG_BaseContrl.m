//
//  MPZG_BaseContrl.m
//  MinPingZhangGui
//
//  Created by 包强 on 2018/12/24.
//  Copyright © 2018 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"

@interface MPZG_BaseContrl ()

@end

@implementation MPZG_BaseContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
     [self.navigationController.navigationBar navBarBottomLineHidden:YES];
    self.view.backgroundColor = UIColor.whiteColor;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapGestureAction:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
  
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11.0f) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar navBarBackGroundColor:ThemeColor image:nil isOpaque:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)initRightBarButtonWithImage:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:@selector(onTapRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonitem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonitem;
}

#pragma mark - event response
- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    
    [self clickToHideKeyboard];
}

- (void)onTapRightBarButton {
}


#pragma mark - public method
- (void)clickToHideKeyboard {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
