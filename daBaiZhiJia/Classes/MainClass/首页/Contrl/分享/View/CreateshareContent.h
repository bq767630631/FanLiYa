//
//  CreateshareContent.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateShare_CellInfo;


@interface CreateshareContent : UIView
@property (weak, nonatomic) IBOutlet UITextView *wenAnTextV;
@property (nonatomic, strong) CreateShare_CellInfo *selectedInfo;
@property (nonatomic, strong) NSMutableArray *seletedArr;

@property (nonatomic, strong) UIImage *postImage;

@property (nonatomic, assign) FLYPT_Type  pt;

- (void)setInfoWithModel:(id)model;


@end

