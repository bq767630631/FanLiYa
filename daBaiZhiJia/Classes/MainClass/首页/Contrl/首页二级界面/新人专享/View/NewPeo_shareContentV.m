//
//  NewPeo_shareContentV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/22.
//  Copyright © 2019 包强. All rights reserved.
//

#import "NewPeo_shareContentV.h"
#import "NewPeo_shareBottomV.h"
#import "NewPeo_shareModel.h"

#import "NewPeo_ShareGoodCell.h"
#import "NewPeo_ShareGoodSecCell.h"
#import "NewPeo_RuleV.h"

#define Row_H 157.f
@interface NewPeo_shareContentV ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UIView *tipsV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guiZeCntentVH;

@property (weak, nonatomic) IBOutlet UIView *guiZeV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsV_H;
@property (weak, nonatomic) IBOutlet UILabel *ljLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lj_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lj_top;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_lead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_trail;

@property (weak, nonatomic) IBOutlet UITableView *tableV2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableV2_H;


@property (weak, nonatomic) IBOutlet UIView *time_v;


@property (weak, nonatomic) IBOutlet UIView *bottom_contentV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom_H;

@property (nonatomic, strong) NewPeo_shareBottomV *bottom; //底部视图

@property (nonatomic, strong) NSMutableArray *goodArr;
@property (nonatomic, strong) NSMutableArray *tljList;
@property (nonatomic, assign) NSInteger  time;
@property (nonatomic, strong) id ruleInfo;
@end

static NSString *cellId = @"cellId";
static NSString *cellId_sec = @"cellId_sec";
@implementation NewPeo_shareContentV

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.time_v addSubview:self.timeV];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"NewPeo_ShareGoodCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.dataSource  = self;
    self.tableView.delegate    = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableV2 registerNib:[UINib nibWithNibName:@"NewPeo_ShareGoodSecCell" bundle:nil] forCellReuseIdentifier:cellId_sec];
    self.tableV2.dataSource  = self;
    self.tableV2.delegate    = self;
    self.tableV2.scrollEnabled = NO;
    self.tableV2.backgroundColor = UIColor.clearColor;
     self.tableV2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bottom_contentV addSubview:self.bottom];
    if (IS_iPhone5SE) {
        self.table_lead.constant = self.table_trail.constant = 5;
    }
}

- (void)setInfoWith:(NSMutableArray *)arr time:(NSInteger)time rule:(id)rule tljList:(NSMutableArray*)tljList{
    [self.timeV setTime:time];
    self.goodArr = arr;
    self.tljList = tljList;
    [self.tableView reloadData];
    [self.tableV2 reloadData];
    self.ruleInfo = rule;
  
    [self.bottom setModel:rule];
    
    if (tljList.count==0) { //没淘礼金，隐藏相关
        self.ljLable.hidden = YES;
        self.tipsV.hidden = YES;
        self.lj_H.constant = 0;
        self.lj_top.constant = -40;
    }
   
    self.table_H.constant   = self.tljList.count *Row_H;
    self.tableV2_H.constant = self.goodArr.count *Row_H;
    self.bottom_H.constant = self.bottom.height;
    self.bottom.width = self.bottom_contentV.width;
    
    [self layoutIfNeeded];
    CGFloat height  = 0;
    if (IS_X_Xr_Xs_XsMax) {
       height =  self.bottom_contentV.bottom + 85;
    }else{
        height =  self.bottom_contentV.bottom + 70;
    }
    
    self.height = height;
    self.contentV.height = self.height ;
    //NSLog(@"bottom_contentV.frame1 %@", NSStringFromCGRect(self.bottom_contentV.frame));
    NSLog(@"contentVH  %.f",self.height);
    NSLog(@"bottom_contentV.bottom%.f",self.bottom_contentV.bottom);
    NSLog(@"bottom_H  %.f",self.bottom_H.constant);
    NSLog(@"contentV %@", self.contentV);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.tableView==tableView ? self.tljList.count:self.goodArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView == tableView ) { //淘礼金商品
        NewPeo_ShareGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        SearchResulGoodInfo *info = self.tljList[indexPath.row];
        [cell setModel:info];
        return cell;
    }else{//普通商品
        NewPeo_ShareGoodSecCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId_sec];
        SearchResulGoodInfo *info = self.goodArr[indexPath.row];
        [cell setModel:info];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Row_H;
}

#pragma mark  - action
- (IBAction)ruleAction:(UIButton *)sender {
    NewPeo_RuleV *rule = [NewPeo_RuleV viewFromXib];
    rule.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [rule setModel:self.ruleInfo];
    [rule show];
}

#pragma mark - getter
- (NewPeo_shareBottomV *)bottom{
    if (!_bottom) {
        _bottom = [NewPeo_shareBottomV viewFromXib];
        _bottom.frame = CGRectMake(0, 0, SCREEN_WIDTH, 371);
    }
    return _bottom;
}

- (NewPeo_timeView *)timeV{
    if (!_timeV) {
        _timeV = [NewPeo_timeView viewFromXib];
        _timeV.frame = self.time_v.bounds;
    }
    return _timeV;
}

@end
