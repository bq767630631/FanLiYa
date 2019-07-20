//
//  DBZJ_SearchTextField.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_SearchTextField.h"

@implementation DBZJ_SearchTextField

- (void)awakeFromNib{
    [super awakeFromNib];
   // self.height = 42;
    [self initliztion];
}


- (void)initliztion{
    UIImage *image = [UIImage imageNamed:@"icon_searchss"];
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:image];
    
    self.leftView     = leftImageView;
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setTitle:@"搜索" forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    right.backgroundColor= UIColor.cyanColor;
    [right addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightView     = right;
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode   = UITextFieldViewModeWhileEditing;
    self.returnKeyType     = UIReturnKeySearch;
    self.borderStyle       = UITextBorderStyleNone;
    self.backgroundColor   = UIColor.whiteColor;
    ViewBorderRadius(self, self.height/2, RGBColor(255, 102, 102));
    NSString *holderText = self.placeholder;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttributes:@{NSForegroundColorAttributeName
                                 :RGBColor(179, 179, 179), NSFontAttributeName:[UIFont systemFontOfSize:12.f] } range:NSMakeRange(0, holderText.length)];
    self.attributedPlaceholder = placeholder;
}


#pragma mark - action
- (void)searchAction{
    NSLog(@"searchAction");
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    bounds.origin.x = 12.f;
    bounds.origin.y = 11.5;
    bounds.size.width  = 19.f;
    bounds.size.height = 19.f;
    return bounds;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    bounds.origin.x = 12.f + 19.f + 10.f;
    return bounds;
}


- (CGRect)editingRectForBounds:(CGRect)bounds{
    bounds.origin.x = 12.f + 19.f + 10.f;
    return bounds;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    bounds.origin.x = self.width - 64;
    bounds.origin.y = 0;
    bounds.size.width  = 64.f;
    bounds.size.height = self.height;
    return bounds;
}

@end
