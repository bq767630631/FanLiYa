//
//  ShareCoffeeContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ShareCoffeeContrl.h"
#import "LearnKnowLedgeCell.h"
#import "ClassScheCardContrl.h"
#import "MySpreadContrl.h"
#import "RegisterDetailContrl.h"
#import "MyGroupMemberContrl.h"
@interface ShareCoffeeContrl ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *learKonwdgeV;

@property (weak, nonatomic) IBOutlet UITableView *LearingTableV;

@property (weak, nonatomic) IBOutlet UIView *prifitView;

@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *shareCode;

@property (weak, nonatomic) IBOutlet UIView *prifit_bg1;

@property (weak, nonatomic) IBOutlet UIView *prifit_bg2;
@property (weak, nonatomic) IBOutlet UIView *prifit_bg3;
@property (weak, nonatomic) IBOutlet UIView *prifit_bg4;


@property (weak, nonatomic) IBOutlet UIButton *learnBtn;
@property (weak, nonatomic) IBOutlet UIButton *prifitBtn;


@end

static NSString *cellId = @"cellId";
@implementation ShareCoffeeContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学知识";
    [self setUp];
}

#pragma mark - setUp
- (void)setUp {
    [self.LearingTableV registerNib:[UINib nibWithNibName:NSStringFromClass([LearnKnowLedgeCell class]) bundle:nil] forCellReuseIdentifier:cellId];
    self.LearingTableV.dataSource = self;
    self.LearingTableV.delegate = self;
    self.LearingTableV.rowHeight = 87 ;
    ViewBorderRadius(_prifit_bg1, 5, UIColor.whiteColor);
    ViewBorderRadius(_prifit_bg2, 5, UIColor.whiteColor);
    ViewBorderRadius(_prifit_bg3, 5, UIColor.whiteColor);
    ViewBorderRadius(_prifit_bg4, 5, UIColor.whiteColor);
    [self.navigationController.navigationBar navBarBottomLineHidden:YES];
}

#pragma mark - UITableViewDataSource &UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    LearnKnowLedgeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
    ClassScheCardContrl *class = [[ClassScheCardContrl alloc] init];
    [self.navigationController pushViewController:class animated:YES];
}

#pragma mark -  action

- (IBAction)spreadAction:(UITapGestureRecognizer *)sender {
    NSLog(@"");
    MySpreadContrl *spre = [MySpreadContrl new];
    [self.navigationController pushViewController:spre animated:YES];
}

- (IBAction)rgisterAction:(UITapGestureRecognizer *)sender {
     [self.navigationController pushViewController:[RegisterDetailContrl new] animated:YES];
}

- (IBAction)groupMem:(UITapGestureRecognizer *)sender {
      NSLog(@"");
     [self.navigationController pushViewController:[MyGroupMemberContrl new] animated:YES];
}

- (IBAction)learnAction:(UIButton *)sender {
    sender.selected = YES;
    self.prifitBtn.selected = NO;
    self.learKonwdgeV.hidden = NO;
    self.prifitView.hidden = YES;
    self.title = @"学知识";
}

- (IBAction)prifitAction:(UIButton *)sender {
    sender.selected = YES;
     self.learnBtn.selected = NO;
     self.learKonwdgeV.hidden = YES;
     self.prifitView.hidden = NO;
     self.title = @"收益";
}

@end
