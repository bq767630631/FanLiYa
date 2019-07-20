//
//  ClassScheCardContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ClassScheCardContrl.h"
#import "ClassScheCardCellTableViewCell.h"

@interface ClassScheCardContrl ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UILabel *totalClass;
@property (weak, nonatomic) IBOutlet UIButton *openCloseBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end
static NSString *cellId = @"cellId";
@implementation ClassScheCardContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"课程表";
    [self setUp];
}

- (void)setUp{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassScheCardCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.dataSource = self;
    self.dataSource = @[@"1",@"1",@"1",@"1",@"1"].mutableCopy;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassScheCardCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}

- (IBAction)btnAction:(UIButton *)sender {
    sender.selected = ! sender.selected;
    if (!sender.isSelected) {
         self.dataSource = @[@"1",@"1",@"1",@"1",@"1"].mutableCopy;
    }else{
        self.dataSource = @[].mutableCopy;
    }
    [self.tableView reloadData];
}

@end
