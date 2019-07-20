//
//  CreateshareContent.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "CreateshareContent.h"
#import "CreateshareCollectionCell.h"
#import "GoodDetailModel.h"
#import "CreateShare_Model.h"
#import "GKPhotoBrowser.h"
#import "Share_PosterView.h"
static NSString *cellId = @"cellId";
@interface CreateshareContent ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *yujiMoney;

@property (weak, nonatomic) IBOutlet UIView *haiBaoV;
@property (weak, nonatomic) IBOutlet UIView *wenAnV;
@property (weak, nonatomic) IBOutlet UIView *taokaoulin;
@property (weak, nonatomic) IBOutlet UIButton *haibaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *wenanBtn;
@property (weak, nonatomic) IBOutlet UIButton *taokoulingBtn;
@property (weak, nonatomic) IBOutlet UILabel *tklLB;
@property (weak, nonatomic) IBOutlet UILabel *wenAnLb;

@property (weak, nonatomic) IBOutlet UIButton *tklBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tklLeadcons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderLead;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTrail;

@property (weak, nonatomic) IBOutlet UIButton *downLoadOrdBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveMoneyBtn;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIView *choseBtnView;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;


@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) GoodDetailInfo *detailinfo;

@property (nonatomic, strong) UIImage *postImage;
@end
@implementation CreateshareContent

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.haiBaoV, 4, UIColor.clearColor);
    ViewBorderRadius(self.wenAnV, 4, UIColor.clearColor);
    ViewBorderRadius(self.taokaoulin, 4, UIColor.clearColor);
    ViewBorderRadius(self.haibaoBtn,self.haibaoBtn.height/2,UIColor.clearColor);
    ViewBorderRadius(self.wenanBtn, self.wenanBtn.height/2, UIColor.clearColor);
    ViewBorderRadius(self.taokoulingBtn, self.taokoulingBtn.height/2, UIColor.clearColor); //: 888


    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.collectionViewLayout = self.layout;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CreateshareCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    self.dataSource = @[].mutableCopy;
      CGFloat w1 = self.tklBtn.width;
      CGFloat w2 = self.downLoadOrdBtn.width;
    CGFloat gap = (SCREEN_WIDTH - (w1+w2)*2 - 30*2) /3;

    self.orderLead.constant = gap;
    self.orderTrail.constant = gap;
    ViewBorderRadius(self.choseBtnView, 5, UIColor.clearColor);
}




- (void)setInfoWithModel:(id)model{
    self.detailinfo = model;
    self.yujiMoney.text = [NSString stringWithFormat:@"您的奖励预计: ¥%@",self.detailinfo.profit];
    self.tklLB.text = self.detailinfo.tkl;
    self.wenAnLb.text = self.detailinfo.wenAnStr;
    for (int i = 0; i < self.detailinfo.pics.count; i ++) {
        NSString*str  = self.detailinfo.pics[i];
        CreateShare_CellInfo *cellInfo = [CreateShare_CellInfo new];
        cellInfo.imageStr = str;
        cellInfo.isSelected = (i == 0)?YES:NO;
        [self.dataSource addObject:cellInfo];
    }
    self.selectedInfo = self.dataSource.firstObject;
    [self.collectionView reloadData];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CreateshareCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
      CreateShare_CellInfo *info = self.dataSource[indexPath.row];
    info.indexPath = indexPath;
    [cell setInfoWith:info];
    @weakify(self);
    cell.block = ^(NSIndexPath *path, BOOL isSelect) {
        @strongify(self);

        for (NSInteger i = 0; i < self.dataSource.count; i++) {
            CreateShare_CellInfo *itemInfo = self.dataSource[i];
            if (isSelect) {
                if (i == path.row) {
                     itemInfo.isSelected = YES;
                }else{
                      itemInfo.isSelected = NO;
                }
            }else{
                if (i == path.row) {
                    itemInfo.isSelected = isSelect;
                }
            }
        }

        [self.collectionView reloadData];
        for ( CreateShare_CellInfo *itemInfo in self.dataSource) {
            if (itemInfo.isSelected) {
                self.selectedInfo = itemInfo;
                break;
            }else{
                self.selectedInfo = nil;
            }
        }
        NSLog(@"selectedInfo = %@",self.selectedInfo);
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"");
    
    NSMutableArray *photos = [NSMutableArray new];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CreateShare_CellInfo *itemInfo = obj;
          GKPhoto *photo = [GKPhoto new];
        if (!itemInfo.isPoster) {
            photo.url = [NSURL URLWithString:itemInfo.imageStr];
        }else{
            photo.image = itemInfo.image;
        }
        [photos addObject:photo];
    }];
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:indexPath.row];
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
    [browser showFromVC:self.viewController];
}

#pragma mark - action
- (IBAction)haibaoAction:(UIButton *)sender {
    NSLog(@"%@",self.selectedInfo);
    if (!self.selectedInfo) {
        [YJProgressHUD showMsgWithoutView:@"请选中一张图片"];
        return;
    }
    if (self.postImage) {
         [YJProgressHUD showMsgWithoutView:@"已经生成过海报"];
        return;
    }
    Share_PosterView *postV= [[Share_PosterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    self.detailinfo.pic = self.selectedInfo.imageStr;

    [postV setInfoWithModel:self.detailinfo];
    
   UIImage *image =  [self getmakeImageWithView:postV andWithSize:CGSizeMake(SCREEN_WIDTH  , SCREEN_HEIGHT)];
     CreateShare_CellInfo *item = [CreateShare_CellInfo new];
    item.isPoster = YES;
    item.image = image;
    item.isSelected = YES;
    self.postImage = image;
    self.selectedInfo = item;
    [self.dataSource insertObject:item atIndex:0];//插入到第一个
    for ( CreateShare_CellInfo *info in self.dataSource) {
        if (!(info == item)) {
            info.isSelected = NO;
        }
    }
    [self.collectionView reloadData];
}


- (IBAction)wenanAction:(UIButton *)sender {
      NSLog(@"");
    [UIPasteboard generalPasteboard].string = self.detailinfo.wenAnStr;
    [YJProgressHUD showMsgWithoutView:@"文案复制成功"];
}

- (IBAction)koulingAction:(UIButton *)sender {
      NSLog(@"");
    [UIPasteboard generalPasteboard].string = self.detailinfo.tkl;
    [YJProgressHUD showMsgWithoutView:@"淘口令复制成功"];
}

#pragma mark - WenAnbtnAction
- (IBAction)tklAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self setUpWenAnStr];
}

- (IBAction)xiaDanAction:(UIButton *)sender {
    sender.selected = !sender.selected;
     [self setUpWenAnStr];
}

- (IBAction)saveMoneyAction:(UIButton *)sender {
    sender.selected = !sender.selected;
     [self setUpWenAnStr];
}
- (IBAction)codeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self setUpWenAnStr];
}

- (void)setUpWenAnStr{
     [CreateShare_Model geneRateWenanWithDetail:self.detailinfo isAdd:self.downLoadOrdBtn.selected isDown:self.saveMoneyBtn.selected isRegisCode:self.codeBtn.selected isTkl:self.tklBtn.selected];
      self.wenAnLb.text = self.detailinfo.wenAnStr;
}

#pragma mark - getter
- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 10;
        _layout.itemSize = CGSizeMake(104, 104);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}


@end
