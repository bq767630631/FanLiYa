//
//  Home_FlashTimeStaCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_FlashTimeStaCell.h"
#import "HomePage_Model.h"

@interface Home_FlashTimeStaCell ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
@implementation Home_FlashTimeStaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self, 5, UIColor.clearColor);
}

- (void)setInfo:(id)info{
    HomePage_FlashSaleInfo *saleInfo = info;
    self.time.text = saleInfo.time;
    self.status.text = saleInfo.status;
    if ([saleInfo.status isEqualToString:@"疯抢中"]) {
        self.backgroundColor = UIColor.whiteColor;
        self.time.textColor = RGBColor(195, 152, 77);
        self.status.textColor = RGBColor(195, 152, 77);
    }else{
        self.backgroundColor = UIColor.clearColor;
        self.time.textColor = UIColor.whiteColor;
        self.status.textColor = UIColor.whiteColor;
    }
}


@end
