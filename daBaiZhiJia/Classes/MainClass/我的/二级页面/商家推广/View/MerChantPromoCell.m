//
//  MerChantPromoCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MerChantPromoCell.h"
#import "MerChantPromoModel.h"

@interface MerChantPromoCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (nonatomic, strong) MerChantPromoInfo *info;
@end
@implementation MerChantPromoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.contentV, 3, UIColor.clearColor);
    self.tf.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.info.tfStr = textField.text;
}

- (void)setInfoWithModel:(id)model{
    MerChantPromoInfo *info = model;
    self.info = model;
    self.title.text = info.title;
    self.tf.tag = info.tf_tag;
    self.tf.placeholder = info.placehoder;
    if (info.tf_tag==4) {
        self.tf.keyboardType = UIKeyboardTypePhonePad;
    }else{
        self.tf.keyboardType = UIKeyboardTypeDefault;
    }
}
@end
