//
//  PingDuoduoHomeSearch.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PingDuoduoHomeSearch.h"
#import "DWQSearchController.h"
@implementation PingDuoduoHomeSearch

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.containV, 3, UIColor.clearColor);
}

- (IBAction)tapAction:(UIButton *)sender {
    DWQSearchController *search  = [DWQSearchController new];
    if (self.pt == FLYPT_Type_Pdd) {
          search.searchType = 2;
    }else if (self.pt == FLYPT_Type_JD){
         search.searchType = 3;
    }
  
    [self.viewController.navigationController pushViewController:search animated:YES];
}

@end
