//
//  DBZJ_ComShareView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/4.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_ComShareView.h"
#import "CreateshareBottom.h"

@interface DBZJ_ComShareView ()
@property (nonatomic, strong) CreateshareBottom *bottomShare;

@property (weak, nonatomic) IBOutlet UIView *contentView;


@end
@implementation DBZJ_ComShareView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView addSubview:self.bottomShare];
}

-  (void)layoutSubviews{
    [super layoutSubviews];
    self.bottomShare.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
}


- (void)show{
    [self showInWindowWithBackgoundTapDismissEnable:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideView];
}

- (void)setModel:(id)model{
     _model = model;
    _bottomShare.model = model;
    _bottomShare.comInfo =  _model;
    _bottomShare.cur_vc = self.cur_vc;
    _bottomShare.isFrom_sheQu = self.isFrom_sheQu;
    _bottomShare.isFrom_haiBao = self.isFrom_haiBao;
}

#pragma mark - getter
- (CreateshareBottom *)bottomShare{
    if (!_bottomShare) {
        _bottomShare = [CreateshareBottom viewFromXib];
        @weakify(self);
        _bottomShare.block = ^{
            @strongify(self);
              [self hideView];
        };
    }
    return _bottomShare;
}
@end
