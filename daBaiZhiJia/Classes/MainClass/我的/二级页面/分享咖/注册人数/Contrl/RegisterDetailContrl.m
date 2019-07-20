//
//  RegisterDetailContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "RegisterDetailContrl.h"
#import "RegisterDetailCell.h"

@interface RegisterDetailContrl ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regisLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regisTrain;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

static NSString *cellId = @"cellId";
@implementation RegisterDetailContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册明细";
    [self setUp];
}

- (void)setUp {
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([RegisterDetailCell class]) bundle:nil] forCellReuseIdentifier:cellId];
    self.tableview.rowHeight = 50.f;
    self.tableview.dataSource = self;
    self.tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1f)];
    self.totalNum.attributedText = [self mutStrWithStr:@"合计登记量: " str2:@"500"];
    if (IS_iPhone5SE) {
        self.regisLead.constant = 17;
        self.regisTrain.constant = 17;
    }else if (IS_iPhone6_6s){
        self.regisLead.constant = 35;
        self.regisTrain.constant = 35;
    }else{
        self.regisLead.constant = 47;
        self.regisTrain.constant = 47;
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RegisterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}

#pragma mark - private
- (NSMutableAttributedString *)mutStrWithStr:(NSString *)str1 str2:(NSString*)str2{
    NSMutableAttributedString  *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [mutStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(255, 102, 102)} range:NSMakeRange(str1.length, str2.length)];
    return mutStr;
}
@end
