//
//  ClassScheCardCellTableViewCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/27.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ClassScheCardCellTableViewCell.h"
#import "IndexButton.h"
@interface ClassScheCardCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet IndexButton *btn;

@end
@implementation ClassScheCardCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)action:(IndexButton *)sender {
    NSLog(@"");
}

@end
