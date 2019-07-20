//
//  XZSearchBar.m
//  DWQSearchWithHotAndHistory
//
//  Created by 杜文全 on 16/8/14.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved. © 2016年 Fangxuele－iOS. All rights reserved.
//

#import "DWQSearchBar.h"
//#import "UIViewExt.h"
@implementation DWQSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
    
        self.placeholder = @"请输入商品名称,先领券再购物";
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.height / 2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = RGBColor(241, 241, 241);
        self.returnKeyType = UIReturnKeySearch;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        // 添加搜索图
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_navi_search"]];
        imgView.contentMode = UIViewContentModeCenter;
//        imgView.width += 30;
        self.leftView = imgView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.returnKeyType =UIReturnKeySearch;
        self.font = [UIFont systemFontOfSize:12.f];
        NSString *holderText = self.placeholder;
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttributes:@{NSForegroundColorAttributeName
                                     :RGBColor(153, 153, 153), NSFontAttributeName:[UIFont systemFontOfSize:12.f] } range:NSMakeRange(0, holderText.length)];
        self.attributedPlaceholder = placeholder;
    }
    
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    bounds.origin.x = 15.f;
    bounds.origin.y = 8.5;
    bounds.size.width  = 13.f;
    bounds.size.height = 13.f;
    return bounds;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    bounds.origin.x = 15.f + 13.f + 10.f;
    return bounds;
}


- (CGRect)editingRectForBounds:(CGRect)bounds{
    bounds.origin.x = 15.f + 13.f + 10.f;
    return bounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    bounds.origin.x = 15.f + 13.f + 10.f;
    return bounds;
}
@end
