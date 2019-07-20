//
//  HomeTextFidld.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HomeTextFidld.h"
static NSInteger kTextFieldTextFont          = 12.0f;
static NSInteger kHeight          = 30.0f;
@implementation HomeTextFidld

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    
    frame.size.height = 30.0f;
    self = [super initWithFrame:frame];
    if (self) {
        [self initSearchTextFieldProperty];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSearchTextFieldProperty];
}

#pragma mark - init method
- (void)initSearchTextFieldProperty {
    
    UIImage *image = [UIImage imageNamed:@"home_navi_search"];
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:image];

    self.leftView     = leftImageView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.placeholder = @"请输入商品名称,先领券再购物";
    self.returnKeyType     = UIReturnKeySearch;
    self.borderStyle       = UITextBorderStyleNone;
    self.backgroundColor   = UIColor.whiteColor;
    
    self.font = [UIFont systemFontOfSize:kTextFieldTextFont];
    self.layer.cornerRadius = kHeight / 2;
    self.layer.masksToBounds = YES;
    NSString *holderText = self.placeholder;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttributes:@{NSForegroundColorAttributeName
                                 :RGBColor(153, 153, 153), NSFontAttributeName:[UIFont systemFontOfSize:12.f] } range:NSMakeRange(0, holderText.length)];
    self.attributedPlaceholder = placeholder;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    bounds.origin.x = IS_iPhone5SE?20:42.f*SCALE_Normal;
    bounds.origin.y = 8.5;
    bounds.size.width  = 13.f;
    bounds.size.height = 13.f;
    return bounds;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    bounds.origin.x = (IS_iPhone5SE?20:42.f*SCALE_Normal) + 13.f + 10.f;
    return bounds;
}


//- (CGRect)editingRectForBounds:(CGRect)bounds{
//    bounds.origin.x = (IS_iPhone5SE?20:42.f*SCALE_Normal) + 13.f + 10.f;
//    return bounds;
//}
@end
