//
//  MyGroupMemberContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MyGroupMemberContrl.h"
#import "MyGroupMemberCell.h"
@interface MyGroupMemberContrl ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
static NSString *cellId = @"cellId";
@implementation MyGroupMemberContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的群员";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyGroupMemberCell class]) bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.rowHeight = 70.f;
    self.tableView.dataSource = self;
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
