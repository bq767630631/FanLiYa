//
//  CategoryHeadView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import "CategoryHeadView.h"
#import "CategoryInfo.h"
#import "IndexButton.h"
#import "CategoryContrl.h"

@interface CategoryHeadView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2LeadCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3LeadCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view4LeadCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view6LeadCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view7LeadCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view8LeadCons;

@property (weak, nonatomic) IBOutlet IndexButton *btn1;
@property (weak, nonatomic) IBOutlet IndexButton *btn2;
@property (weak, nonatomic) IBOutlet IndexButton *btn3;
@property (weak, nonatomic) IBOutlet IndexButton *btn4;
@property (weak, nonatomic) IBOutlet IndexButton *btn5;
@property (weak, nonatomic) IBOutlet IndexButton *btn6;
@property (weak, nonatomic) IBOutlet IndexButton *btn7;
@property (weak, nonatomic) IBOutlet IndexButton *btn8;

@property (weak, nonatomic) IBOutlet UIImageView *image1;

@property (weak, nonatomic) IBOutlet UILabel *lb1;

@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *lb2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *lb3;

@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UILabel *lb4;

@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UILabel *lb5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UILabel *lb6;
@property (weak, nonatomic) IBOutlet UIImageView *image7;
@property (weak, nonatomic) IBOutlet UILabel *lb7;
@property (weak, nonatomic) IBOutlet UIImageView *image8;
@property (weak, nonatomic) IBOutlet UILabel *lb8;
@property (nonatomic, strong) NSArray *cateArr;
@end
@implementation CategoryHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    CGFloat wd = (SCREEN_WIDTH - 30*2 -  40 *4) / 3;
    NSLog(@"wd = %.f",wd);
    self.view2LeadCons.constant = wd;
    self.view3LeadCons.constant = wd;
    self.view4LeadCons.constant = wd;
    self.view6LeadCons.constant = wd;
    self.view7LeadCons.constant = wd;
    self.view8LeadCons.constant = wd;
    self.btn1.section = 0;
    self.btn2.section = 1;
    self.btn3.section = 2;
    self.btn4.section = 3;
    self.btn5.section = 4;
    self.btn6.section = 5;
    self.btn7.section = 6;
    self.btn8.section = 7;
    if (IS_iPhone5SE) {
         self.lb1.font = [UIFont systemFontOfSize:10];
         self.lb2.font = [UIFont systemFontOfSize:10];
         self.lb3.font = [UIFont systemFontOfSize:10];
         self.lb4.font = [UIFont systemFontOfSize:10];
         self.lb5.font = [UIFont systemFontOfSize:10];
         self.lb6.font = [UIFont systemFontOfSize:10];
         self.lb7.font = [UIFont systemFontOfSize:10];
         self.lb8.font = [UIFont systemFontOfSize:10];
    }
}

- (void)setModelWithArr:(NSArray *)cateArr{
    self.cateArr = cateArr;
    for (NSInteger i = 0; i < cateArr.count ; i ++) {
        CategoryInfo *info = cateArr[i];
        if (i == 0) {
            [self.image1 setDefultPlaceholderWithFullPath:info.img];
            self.lb1.text = info.title;
        } if (i == 1) {
            [self.image2 setDefultPlaceholderWithFullPath:info.img];
            self.lb2.text = info.title;
        } if (i == 2) {
            [self.image3 setDefultPlaceholderWithFullPath:info.img];
            self.lb3.text = info.title;
        } if (i == 3) {
            [self.image4 setDefultPlaceholderWithFullPath:info.img];
            self.lb4.text = info.title;
        } if (i == 4) {
            [self.image5 setDefultPlaceholderWithFullPath:info.img];
            self.lb5.text = info.title;
        } if (i == 5) {
            [self.image6 setDefultPlaceholderWithFullPath:info.img];
            self.lb6.text = info.title;
        } if (i == 6) {
            [self.image7 setDefultPlaceholderWithFullPath:info.img];
            self.lb7.text = info.title;
        }if (i == 7) {
            [self.image8 setDefultPlaceholderWithFullPath:info.img];
            self.lb8.text = info.title;
        }
    }
}

#pragma mark - -action
- (IBAction)tap1Action:(IndexButton *)sender {
      NSLog(@"tap1  %ld",(long)sender.section);
    [self jumpToSecInterfaceWithIndex:sender.section];
}


#pragma mark - private
- (void)jumpToSecInterfaceWithIndex:(NSInteger)index{
    CategoryInfo *info = self.cateArr[index];
    CategoryContrl *cat = [[CategoryContrl alloc] initWithCateId:info.cid isSec:YES secTitle:info.title];
    cat.pt = FLYPT_Type_TB;
    CategoryContrl *vc = (CategoryContrl *)self.viewController;
    [vc.naviContrl pushViewController:cat animated:YES];
}


@end

