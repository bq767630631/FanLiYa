//
//  MerChantPromoContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MerChantPromoContrl.h"
#import "MerChantPromoSecCell.h"
#import "MerChantPromoCell.h"
#import "MerChantPromoModel.h"
@interface MerChantPromoContrl ()
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger  pt_type; //默认淘宝4
@end
static NSString *cellId = @"cellId";
static NSString *cellId_sec = @"cellId_sec";
@implementation MerChantPromoContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家推广";
    [self setUp];
}

- (void)setUp{
    ViewBorderRadius(_commitBtn,3, UIColor.clearColor);
    self.pt_type = 4;
    self.dataSource = [MerChantPromoModel dataSource];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.tableV registerNib:[UINib nibWithNibName:@"MerChantPromoCell" bundle:nil] forCellReuseIdentifier:cellId];
    [self.tableV registerNib:[UINib nibWithNibName:@"MerChantPromoSecCell" bundle:nil] forCellReuseIdentifier:cellId_sec];
    [self.tableV reloadData];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MerChantPromoInfo *info = self.dataSource[indexPath.row];
    if (info.type ==1) {
        MerChantPromoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        [cell setInfoWithModel:info];
        return cell;
    }else{
        MerChantPromoSecCell *secCell = [tableView dequeueReusableCellWithIdentifier:cellId_sec];
        MJWeakSelf;
        secCell.callBack = ^(NSUInteger x){
            weakSelf.pt_type = x;
        };
        return secCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108.f;
}

#pragma mark - action
- (IBAction)commitAction:(UIButton *)sender {
    MerChantPromoInfo *info1 = self.dataSource[0];
    MerChantPromoInfo *info3 = self.dataSource[2];
    MerChantPromoInfo *info4 = self.dataSource[3];
    MerChantPromoInfo *info5 = self.dataSource[4];
    MerChantPromoInfo *info6 = self.dataSource[5];
    if (info1.tfStr.length ==0) {
        [YJProgressHUD showMsgWithoutView:@"店铺名不能为空"];
    }else if (info3.tfStr.length ==0){
        [YJProgressHUD showMsgWithoutView:@"联系人真实姓名不能为空"];
    }else if (info4.tfStr.length ==0){
        [YJProgressHUD showMsgWithoutView:@"手机号码不能为空"];
    }else if (![info4.tfStr validateMobile]){
        [YJProgressHUD showMsgWithoutView:@"手机号格式不对"];
    }else if (info5.tfStr.length ==0){
        [YJProgressHUD showMsgWithoutView:@"联系人微信号不能为空"];
    }else if (info6.tfStr.length ==0){
        [YJProgressHUD showMsgWithoutView:@"店铺链接不能为空"];
    }else{
        NSDictionary *para = @{@"shopname":info1.title,@"pt":@(self.pt_type),@"username":info3.title,@"phone":info4.title, @"wx":info5.title, @"url":info6.title, @"token":ToKen,@"v":APP_Version};
        NSLog(@"%@",para);
        [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/addshop") parameters:para success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == SucCode) {
                [self delayDoWork:0.5 WithBlock:^{
                    [YJProgressHUD showMsgWithoutView:@"登记成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            [YJProgressHUD showAlertTipsWithError:error];
        }];
    }
}

@end
