//
//  MySpreadContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MySpreadContrl.h"
#import "MySpreadContrlHeadView.h"
#import "MySpreadContrlcel.h"
@interface MySpreadContrl ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
@property (nonatomic, strong) NSMutableArray <NSArray*>*dataSource;
@end
static NSString *cellId = @"cellId";
static NSString *headId = @"headId";

@implementation MySpreadContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的推广";
    [self setUp];
}

- (void)setUp{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MySpreadContrlHeadView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:headId];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MySpreadContrlcel class]) bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.rowHeight = 50.f;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = @[@[@"1",@"2",@"3"],@[],@[@"2"],@[@"1",@"2",@"3"], @[@"2"]].mutableCopy;
    self.totalNum.attributedText = [self mutStrWithStr:@"新增人数合计: " str2:@"500"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MySpreadContrlcel *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MySpreadContrlHeadView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId];
    return head;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 57.f;
}

#pragma mark - private
- (NSMutableAttributedString *)mutStrWithStr:(NSString *)str1 str2:(NSString*)str2{
    NSMutableAttributedString  *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(255, 102, 102)} range:NSMakeRange(str1.length, str2.length)];
    return mutStr;
}
@end
