//
//  DBZJ_FeedBack.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/8/30.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_FeedBack.h"
#import "VEPictureSelect.h"

#define Placeholder @"您宝贵的意见对我们非常的重要,请详细描述遇到的问题，或者需要我们改进的地方谢谢"
#define TotalNum 1000
@interface DBZJ_FeedBack ()<UITextViewDelegate,VEPictureSelectDelegate>
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIView *textContainV;

@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet UIButton *addBtn1;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *item1_W;

@property (weak, nonatomic) IBOutlet UIButton *addBtn2;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn2;
@property (weak, nonatomic) IBOutlet UIButton *addBtn3;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn3;
@property (weak, nonatomic) IBOutlet UIButton *addBtn4;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn4;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (strong, nonatomic) VEPictureSelect *pictureSelect;
@property (nonatomic, assign) NSInteger  typeAdd; //1,2,3,4
@end

@implementation DBZJ_FeedBack

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self setUp];
}

- (void)setUp{
    ViewBorderRadius(self.textContainV, 3, RGBColor(221, 221, 221));
    ViewBorderRadius(self.addBtn1, 3, RGBColor(221, 221, 221));
    ViewBorderRadius(self.addBtn2, 3, RGBColor(221, 221, 221));
    ViewBorderRadius(self.addBtn3, 3, RGBColor(221, 221, 221));
    ViewBorderRadius(self.addBtn4, 3, RGBColor(221, 221, 221));
    ViewBorderRadius(self.sureBtn, self.sureBtn.height*0.5, UIColor.clearColor);
    self.textV.delegate = self;
}

#pragma mark - UITextViewDelegate
//输入时自动删除占位文字
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = RGBColor(51, 51, 51);
    if ([textView.text isEqualToString:Placeholder]) {
        textView.text = @"";
    }
}

//当编辑时动态判断是否超过规定字数，这里限制20字
- (void)textViewDidChange:(UITextField *)textView{
    
    if (textView.text.length > TotalNum) {
        textView.text = [textView.text substringToIndex:TotalNum];
    }
    NSInteger len = textView.text.length;
    self.num.text = [NSString stringWithFormat:@"%zd",(TotalNum - len)];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    textView.font = [UIFont systemFontOfSize:12];
    textView.textColor = RGBColor(153, 153, 153);
    if ([textView.text isEqualToString:@""]) {
        textView.text = Placeholder;
    }
}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    
//    //判断加上输入的字符，是否超过界限
//    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
//    if (str.length > TotalNum) {
//        textView.text = [textView.text substringToIndex:TotalNum];
//        return NO;
//    }
//    return YES;
//}


#pragma mark -  VEPictureSelectDelegate
-(void)iconChooseFinish:(UIImage*)img{
//    self.selectImage = img;
//    [self.addPhotoBtn setImage:img forState:UIControlStateNormal];
    [self handleBtnImageWithImage:img isAdd:YES];
}

#pragma mark - action
- (IBAction)addAction:(UIButton *)sender {
     self.typeAdd = sender.tag;
     [self.pictureSelect changeIcon:@"选择图片"];
}

- (IBAction)deleAction:(UIButton *)sender {
     [self handleBtnImageWithImage:[UIImage imageNamed:@"形状1"] isAdd:NO];
}

- (IBAction)sureAction:(UIButton *)sender {
    NSLog(@"");
}

#pragma mark - private
- (void)handleBtnImageWithImage:(UIImage*)img isAdd:(BOOL)isAdd{
    if (self.typeAdd==1) {
        [self.addBtn1 setImage:img forState:UIControlStateNormal];
        self.deleBtn1.hidden = !isAdd;
    }else if (self.typeAdd==2){
        [self.addBtn2 setImage:img forState:UIControlStateNormal];
        self.deleBtn2.hidden = !isAdd;
    }else if (self.typeAdd==3){
        [self.addBtn3 setImage:img forState:UIControlStateNormal];
        self.deleBtn3.hidden = !isAdd;
    }else if (self.typeAdd==4){
        [self.addBtn4 setImage:img forState:UIControlStateNormal];
        self.deleBtn4.hidden = !isAdd;
    }
}

#pragma mark - getter
- (VEPictureSelect *)pictureSelect{
    if (!_pictureSelect) {
        _pictureSelect = [[VEPictureSelect alloc] initWithView:self
                          ];
        _pictureSelect.delegate = self;
    }
    return _pictureSelect;
}
@end
