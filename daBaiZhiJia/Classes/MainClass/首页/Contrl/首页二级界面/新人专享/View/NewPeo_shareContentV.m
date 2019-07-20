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

@interface NewPeo_shareContentV ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lingquanVTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_lead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_trail;

@property (weak, nonatomic) IBOutlet UIView *time_v;



@property (nonatomic, strong) NewPeo_shareBottomV *bottom;

@property (nonatomic, strong) NSMutableArray *goodArr;
@property (nonatomic, assign) NSInteger  time;
@end

static NSString *cellId = @"cellId";
@implementation NewPeo_shareContentV

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.lingquanVTop.constant =   self.lingquanVTop.constant*SCALE_Normal;
    [self.time_v addSubview:self.timeV];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewPeo_ShareGoodCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.dataSource  = self;
    self.tableView.delegate  = self;
    self.tableView.rowHeight = 137.f;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = UIColor.clearColor;
    [self.contentV addSubview:self.bottom];
    if (IS_iPhone5SE) {
        self.table_lead.constant = self.table_trail.constant = 5;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"self.bottom.bottom %.f",self.bottom.bottom);
}

- (void)setInfoWith:(NSMutableArray *)arr time:(NSInteger)time rule:(id)rule{
    [self.timeV setTime:time];
    self.goodArr = arr;
    [self.tableView reloadData];
    [self.bottom setModel:rule];
    
    self.table_H.constant = self.goodArr.count *self.tableView.rowHeight;
    self.bottom.frame = CGRectMake(0, 20 + self.tableView.top +  self.table_H.constant, SCREEN_WIDTH,  self.bottom.height);
   
    self.height = self.tableView.top + self.table_H.constant + self.bottom.height + 80;
    self.contentV.height = self.height ;
    NSLog(@"self.height  =%.f", self.height);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewPeo_ShareGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    [cell setModel:info];
    return cell;
}

#pragma mark - getter
- (NewPeo_shareBottomV *)bottom{
    if (!_bottom) {
        _bottom = [NewPeo_shareBottomV viewFromXib];
        _bottom.frame = CGRectMake(0, self.tableView.bottom, SCREEN_WIDTH, 371);
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
