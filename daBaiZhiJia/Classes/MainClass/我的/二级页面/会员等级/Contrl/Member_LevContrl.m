//
//  Member_LevContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/1.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Member_LevContrl.h"
#import "Member_LevCell.h"
#import "Member_Model.h"

#define Banner_W (SCREEN_WIDTH - 37.f*2)
@interface Member_LevContrl ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huiyuanTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view6Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view6Bottom;

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selfBuyLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selfBuyTrail;
@property (weak, nonatomic) IBOutlet UILabel *award1;

@property (weak, nonatomic) IBOutlet UILabel *award2;
@property (weak, nonatomic) IBOutlet UILabel *award3;
@property (weak, nonatomic) IBOutlet UILabel *award4;
//升级攻略
@property (weak, nonatomic) IBOutlet UILabel *shareLb;

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UILabel *linkLb;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UILabel *buyOrderlb;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) Member_LevCell *memCell01;
@property (nonatomic, strong) Member_LevCell *memCell02;
@property (nonatomic, strong) Member_LevCell *memCell03;
@property (nonatomic, strong) NSMutableArray <Member_LeverSetInfo*>*totalArr;
@property (nonatomic, strong) Member_CurLeverInfo *curInfo;
//@property (nonatomic, assign) NSInteger  curIndex;
@end

@implementation Member_LevContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员等级";
    [self setUp];
    [self queryData];
}

- (void)setUp{
    CGFloat consW = (SCREEN_WIDTH - 58 *2 - 71.5*2 - 20*2) /3;
    NSLog(@"consW =%.f",consW);
    self.selfBuyLead.constant  = self.selfBuyTrail.constant = consW;
      ViewBorderRadius(self.line1, 5, UIColor.clearColor);
      ViewBorderRadius(self.line2, 5, UIColor.clearColor);
      ViewBorderRadius(self.btn1, 15, UIColor.clearColor);
      ViewBorderRadius(self.btn2, 15, UIColor.clearColor);
      ViewBorderRadius(self.btn3, 15, UIColor.clearColor);
    self.lineHCons.constant = self.lineHCons.constant*SCALE_MAX;
     self.lineTop.constant =  self.lineTop.constant*SCREEN_WIDTH/375;
     self.huiyuanTop.constant =  self.huiyuanTop.constant*SCREEN_WIDTH/375;
     self.view6Bottom.constant = self.view6Top.constant  = (self.view6Top.constant*SCREEN_WIDTH/375);
    SCALE;
     [self.view addSubview:self.scroView];;
}

- (void)queryData{

    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [Member_Model queryMemSetInfoWithBlock:^(NSMutableArray<Member_LeverSetInfo* >* _Nullable arr, NSError* _Nullable err) {
        if (arr) {
             self.totalArr = arr;
        }
        dispatch_group_leave(group);
    }];
     dispatch_group_enter(group);
    [Member_Model queryMemCurInfoWithBlock:^(Member_CurLeverInfo* _Nullable curInfo, NSError* _Nullable err) {
        if (curInfo) {
            self.curInfo = curInfo;
        }
         dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_group_notify");
        
        for (Member_LeverSetInfo *info  in self.totalArr) {
            if (info.level == self.curInfo.level) {
                info.isCurent = YES;
                break;
            }
        }
        [self handleSetInfo];
    });
}

- (void)handleSetInfo{
  
    if (self.curInfo.level == 1) {//当前等级是普通会员 可以往右边化两次   （依次是中，高）
        [_scroView addSubview:self.memCell01];
        [_scroView addSubview:self.memCell02];
        [_scroView addSubview:self.memCell03];
         _scroView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
        [self.memCell01 setInfo:self.totalArr[0]];
        [self.memCell02 setInfo:self.totalArr[1]];
        [self.memCell03 setInfo:self.totalArr[2]];
        [self setOtherValueWith:self.totalArr[0] curInfo:self.curInfo];
    }else if (self.curInfo.level == 2){//当前等级是中级会员 可以往右边一次 ， 左边不用滑
        [_scroView addSubview:self.memCell01];
        [_scroView addSubview:self.memCell02];
        _scroView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
        [self.memCell01 setInfo:self.totalArr[1]];
        [self.memCell02 setInfo:self.totalArr[2]];
        [self setOtherValueWith:self.totalArr[1] curInfo:self.curInfo];
    }else if (self.curInfo.level == 3){//当前等级是高级会员 不用滑动吧
        [_scroView addSubview:self.memCell01];
         _scroView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        [self.memCell01 setInfo:self.totalArr[2]];
        [self setOtherValueWith:self.totalArr[2] curInfo:self.curInfo];
    }
}

- (void)setOtherValueWith:(Member_LeverSetInfo*)setInfo curInfo:(Member_CurLeverInfo*)curinfo{
    self.award1.text = [NSString stringWithFormat:@"奖励%@%%",setInfo.percent];
    self.award2.text = [NSString stringWithFormat:@"奖励%@%%",setInfo.percent];
    self.award3.text = [NSString stringWithFormat:@"奖励%@%%",setInfo.share_percent];
    self.award4.text = [NSString stringWithFormat:@"奖励%@%%",setInfo.relation_percent];
    
    self.shareLb.attributedText = [self attStrWithStr1:[NSString stringWithFormat:@"邀请%@个好友成功注册 ",setInfo.share_number] str2:[NSString stringWithFormat:@"(%@/%@)",curinfo.share_number,setInfo.share_number]];
    self.linkLb.attributedText = [self attStrWithStr1:[NSString stringWithFormat:@"关联引流人数 "] str2:[NSString stringWithFormat:@"(%@/%@)",curinfo.relation_number,setInfo.relation_number]];
    self.buyOrderlb.attributedText = [self attStrWithStr1:[NSString stringWithFormat:@"自购有效订单数 "] str2:[NSString stringWithFormat:@"(%@/%@)",curinfo.order_number,setInfo.order_number]];
}

- (NSMutableAttributedString*)attStrWithStr1:(NSString*)str1 str2:(NSString*)str2{
    NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@%@",str1,str2]];
    [mut setAttributes:@{NSForegroundColorAttributeName:ThemeColor} range:NSMakeRange(str1.length, str2.length)];
    return mut;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar navBarBackGroundColor:RGBA(45, 45, 45, 1.0) image:nil isOpaque:YES];
    [self.navigationController.navigationBar navBarBottomLineHidden:YES];
}

#pragma mark - action
- (IBAction)action01:(UIButton *)sender {
    NSLog(@"");
}
- (IBAction)action2:(UIButton *)sender { NSLog(@"");
}
- (IBAction)action3:(UIButton *)sender { NSLog(@"");
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"contentOffset =%@",NSStringFromCGPoint(scrollView.contentOffset));
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat offSetY = scrollView.contentOffset.y;
       NSInteger index = offsetX /SCREEN_WIDTH;
    NSLog(@"index %zd",index);
    if (self.curInfo.level ==1) {
         [self setOtherValueWith:self.totalArr[index] curInfo:self.curInfo];
    }else if (self.curInfo.level ==2) {
         [self setOtherValueWith:self.totalArr[index + 1] curInfo:self.curInfo];
    }
    
    if (index == 0) {
        [scrollView setContentOffset:CGPointMake(0, offSetY) animated:YES];
    }else if (index == 1){ //当前是普通会员 滑到中级了 animated:YES
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH - 37 - 15, offSetY) animated:YES];
    }else if (index ==2){ //当前是普通会员 滑到高级了 animated:YES
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2 - 37*3, offSetY) animated:YES];
    }
}

#pragma mark - getter
- (UIScrollView *)scroView{
    if (!_scroView) {
        CGFloat origy = NavigationBarBottom(self.navigationController.navigationBar) + 30.f*SCALE_Normal;
          CGRect frame = CGRectMake(0, origy, SCREEN_WIDTH, 120.f*SCALE_MAX);
        _scroView = [[UIScrollView alloc] initWithFrame:frame];
        _scroView.pagingEnabled = YES;
        _scroView.showsHorizontalScrollIndicator = NO;
        _scroView.delegate = self;
    }
    return _scroView;
}

- (Member_LevCell *)memCell01{
    if (!_memCell01) {
        _memCell01 = [Member_LevCell viewFromXib];
        _memCell01.frame = CGRectMake(37.f, 0 , Banner_W, 120.f*SCALE_MAX);
    }
    return _memCell01;
}

- (Member_LevCell *)memCell02{
    if (!_memCell02) {
        _memCell02 = [Member_LevCell viewFromXib];
          _memCell02.frame = CGRectMake(_memCell01.right + 22, 0, Banner_W, 120.f*SCALE_MAX);
    }
    return _memCell02;
}

- (Member_LevCell *)memCell03{
    if (!_memCell03) {
        _memCell03 = [Member_LevCell viewFromXib];
        _memCell03.frame = CGRectMake( _memCell02.right + 22, 0, Banner_W, 120.f*SCALE_MAX);
    }
    return _memCell03;
}

@end
