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
@property (weak, nonatomic) IBOutlet UIView *tipsV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guiZeCntentVH;

@property (weak, nonatomic) IBOutlet UIView *guiZeV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lingquanVTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_lead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_trail;

@property (weak, nonatomic) IBOutlet UIView *time_v;


@property (nonatomic, strong) NewPeo_shareBottomV *bottom; //底部视图

@property (nonatomic, strong) NSMutableArray *goodArr;
@property (nonatomic, assign) NSInteger  time;
@end

static NSString *cellId = @"cellId";
@implementation NewPeo_shareContentV

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.time_v addSubview:self.timeV];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewPeo_ShareGoodCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.dataSource  = self;
    self.tableView.delegate  = self;
    self.tableView.rowHeight = 137.f;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = UIColor.clearColor;
//    [self.contentV addSubview:self.bottom];
    [self.guiZeV addSubview:self.bottom];
    if (IS_iPhone5SE) {
        self.table_lead.constant = self.table_trail.constant = 5;
    }
}

- (void)setInfoWith:(NSMutableArray *)arr time:(NSInteger)time rule:(id)rule{
    [self.timeV setTime:time];
    self.goodArr = arr;
    [self.tableView reloadData];
    [self layoutIfNeeded];
    [self.bottom setModel:rule];
    
     [self layoutIfNeeded];
    self.table_H.constant = self.goodArr.count *self.tableView.rowHeight;

    self.guiZeCntentVH.constant =  self.bottom.height;

    self.height = self.guiZeV.top + self.guiZeCntentVH.constant + 15 + 28 +  self.table_H.constant + 60;
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
