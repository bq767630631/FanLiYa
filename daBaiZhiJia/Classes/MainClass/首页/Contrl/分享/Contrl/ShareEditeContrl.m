//
//  ShareEditeContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/8/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ShareEditeContrl.h"

@interface ShareEditeContrl ()
@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation ShareEditeContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑文案";
    [self setUp];
}

- (void)setUp{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.textV.text = self.textStr;
}

- (void)rightBtnClick{
    if (self.callBack) {
        self.callBack(self.textV.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getter
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 44, 44);
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
@end
