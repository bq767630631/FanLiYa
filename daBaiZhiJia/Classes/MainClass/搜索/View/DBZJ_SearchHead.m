//
//  DBZJ_SearchHead.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_SearchHead.h"
#import "DBZJ_SearchTextField.h"
#import "SearchResultContrl.h"
#import "TeachYouContrl.h"

@interface DBZJ_SearchHead ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iageHCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTop;


@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet DBZJ_SearchTextField *textFied;

@end
@implementation DBZJ_SearchHead

- (void)awakeFromNib{
    [super awakeFromNib];
    self.iageHCons.constant =  [self.iageHCons constantForAdaptationPlus];
    ViewBorderRadius(self.line1, 1, RGBColor(255, 102, 102));
    ViewBorderRadius(self.line2, 1, RGBColor(255, 102, 102));
    self.textFied.delegate = self;
}

- (IBAction)teachYou:(UIButton *)sender {
    TeachYouContrl *teaVc  = [TeachYouContrl new];
    [self.viewController.navigationController
     pushViewController:teaVc animated:YES];
}

- (IBAction)search:(UIButton *)sender {
    NSLog(@"搜索");
     [self jumpToSearchResWithstr:self.textFied.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self jumpToSearchResWithstr:textField.text];
    return YES;
}

#pragma mark - private
- (void)jumpToSearchResWithstr:(NSString *)res{
    SearchResultContrl *search  = [[SearchResultContrl alloc] initWithSearchStr:res];
    [self.viewController.navigationController
     pushViewController:search animated:YES];
}
@end
