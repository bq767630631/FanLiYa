//
//  DWQSearchController.m
//  DWQSearchWithHotAndHistory
//
//  Created by 杜文全 on 16/8/14.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//
/******* 屏幕尺寸 *******/
#define DWQMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define DWQMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define DWQMainScreenBounds [UIScreen mainScreen].bounds
#import "DWQSearchController.h"
#import "DWQSearchBar.h"
#import "DWQTagView.h"
#import "HotSerachCell.h"
#import "DWSearchHeadView.h"
#import "SearchSaveManager.h"
#import "SearchResultContrl.h"
static NSString *const HotCellID = @"HotCellID";
static NSString *const HistoryCellID = @"HistoryCellID";

@interface DWQSearchController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DWQTagViewDelegate>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) DWQSearchBar *searchBar;
/** 历史搜索数组 */
@property (nonatomic, strong) NSMutableArray *historyArr;
/** 热门搜索数组 */
@property (nonatomic, strong) NSMutableArray *HotArr;
/** 得到热门搜索TagView的高度 */
@property (nonatomic ,assign) CGFloat tagViewHeight;
/** 得到历史搜索TagView的高度 */
@property (nonatomic ,assign) CGFloat tagHistoryViewHeight;
@end

@implementation DWQSearchController
-(instancetype)init
{
    if (self = [super init]) {
        self.HotArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar navBarBackGroundColor:ThemeColor image:nil isOpaque:YES];
    [self initData];
    [self createUI];
    // Do any additional setup after loading the view.
}


-(void)initData{

    /**
     * 热门搜索的假数据
     */
    [PPNetworkHelper GET:URL_Add(@"/v.php/goods.share/keyword") parameters:@{@"token":ToKen} success:^(id responseObject) {
         NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
             self.HotArr = [NSString mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableview reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
    //self.HotArr = [NSMutableArray arrayWithObjects:@"你想要搜索什么呢",@"web编程",@"JAVA8",@"JAVAVEE",@"Objective-c",@"SWift",@"iOS分享之路",@"MacBokPro",@"iOS直播",@"APPLE", nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.historyArr = [SearchSaveManager getArray];
    [self.tableview reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)createUI{

    DWQSearchBar *bar = [[DWQSearchBar alloc] initWithFrame:CGRectMake(0, 0, DWQMainScreenWidth - 100, 30)];
    _searchBar = bar;
    
    bar.delegate = self;
    self.navigationItem.titleView = bar;
    [self.view addSubview:self.tableview];
}

#pragma mark - popAction
- (void)leftBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"搜索了什么：%@",textField.text);
    SearchResultContrl *searR = [[SearchResultContrl alloc] initWithSearchStr:textField.text];
    [self.navigationController pushViewController:searR animated:YES];
    if (![self.historyArr containsObject:textField.text] &&textField.text.length >0) {
        [self.historyArr insertObject:textField.text atIndex:0];
        [SearchSaveManager saveArrWithArr:self.historyArr];
    }
    return YES;
}


#pragma mark - UITableViewDataSource
/** section的数量 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.historyArr.count == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

/** CELL */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.historyArr.count == 0) {//只有热门搜索
        HotSerachCell *hotCell = [tableView dequeueReusableCellWithIdentifier:HotCellID forIndexPath:indexPath];
        
        hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
        hotCell.userInteractionEnabled = YES;
        hotCell.hotSearchArr = self.HotArr;
        hotCell.dwqTagV.delegate = self;
        /** 将通过数组计算出的tagV的高度存储 */
        self.tagViewHeight = hotCell.dwqTagV.frame.size.height;
        return hotCell;
    }else{
        if (indexPath.section == 0) { //热门搜索
            HotSerachCell *hotCell = [tableView dequeueReusableCellWithIdentifier:HotCellID forIndexPath:indexPath];
            hotCell.dwqTagV.delegate = self;
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            hotCell.userInteractionEnabled = YES;
            hotCell.hotSearchArr = self.HotArr;
            /** 将通过数组计算出的tagV的高度存储 */
            self.tagViewHeight = hotCell.dwqTagV.frame.size.height;
            return hotCell;
        }else{ //历史搜索
    
            HotSerachCell *historyCell = [tableView dequeueReusableCellWithIdentifier:HotCellID forIndexPath:indexPath];
            historyCell.dwqTagV.delegate = self;
            historyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            historyCell.userInteractionEnabled = YES;
            historyCell.hotSearchArr = self.historyArr;
            /** 将通过数组计算出的tagV的高度存储 */
            self.tagHistoryViewHeight = historyCell.dwqTagV.frame.size.height;
            return historyCell;
        }
    }
}
/** HeaderView */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    DWSearchHeadView *head = [DWSearchHeadView viewFromXib];
    if (section==0) {
        head.titleLable.text = @"热门搜索";
        head.deleteBtn.hidden = YES;
    }else{
        head.titleLable.text = @"历史搜索";
        head.deleteBtn.hidden = NO;
        [head.deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return head;
}

/** 头部的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.f;
}

/** cell的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.historyArr.count == 0) {
        
        return self.tagViewHeight + 37;
    }
    else
    {
        if (indexPath.section == 0) {
            return self.tagViewHeight + 37;
        }
        else
        {
            return self.tagHistoryViewHeight;
        }
    }
}

#pragma mark -- 删除历史搜索
- (void)deleteBtnAction{
    NSLog(@"删除历史搜索");
    [self.historyArr removeAllObjects];
    [self.tableview reloadData];
    [SearchSaveManager deleteArray];
}

#pragma mark -- 实现点击热门搜索tag  Delegate
-(void)DWQTagView:(UIView *)dwq fetchWordToTextFiled:(NSString *)KeyWord
{
    NSLog(@"点击了%@",KeyWord);
    SearchResultContrl *searR = [[SearchResultContrl alloc] initWithSearchStr:KeyWord];
    [self.navigationController pushViewController:searR animated:YES];
    if (![self.historyArr containsObject:KeyWord]&& KeyWord.length >0) {
         [self.historyArr insertObject:KeyWord atIndex:0];
        [SearchSaveManager saveArrWithArr:self.historyArr];
    }
    
}

//#pragma mark -- 删除单个搜索历史
//-(void)removeSingleTagClick:(UIButton *)removeBtn
//{
//    [self.historyArr removeObjectAtIndex:removeBtn.tag - 250];
//
//    [self.tableview reloadData];
//}
//#pragma mark -- 删除所有的历史记录
//-(void)removeAllHistoryBtnClick
//{
//    [self.historyArr removeAllObjects];
//    [self.tableview reloadData];
//}

#pragma mark -- 懒加载
-(UITableView *)tableview
{
    if (!_tableview) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBarBottom(self.navigationController.navigationBar) + 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerClass:[HotSerachCell class] forCellReuseIdentifier:HotCellID];
        _tableview.backgroundColor = [UIColor whiteColor];
    }
    return _tableview;
}



@end
