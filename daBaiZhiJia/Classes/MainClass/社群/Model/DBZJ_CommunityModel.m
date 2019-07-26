//
//  DBZJ_CommunityModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/16.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_CommunityModel.h"

@interface DBZJ_CommunityModel ()

@end


@implementation DBZJ_CommunityModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNum_Rec = 1;
        self.RecomArr = [NSMutableArray array];
        self.pageNum_Marketing = 1;
        self.MarketArr = [NSMutableArray array];
        self.pageNum_NewHand = 1;
        self.NewHandArr = [NSMutableArray array];
    }
    return self;
}

- (BOOL)showblankViewWithType:(NSInteger)type{
    BOOL showBlank = NO;
    if (type ==1 && self.RecomArr.count ==0) {
        showBlank = YES;
    }else if (type ==2 && self.MarketArr.count ==0){
         showBlank = YES;
    }else if (type ==3){
         showBlank = NO;
    }
    return showBlank;
}


- (void)queryRecommendWithType:(NSInteger)type{
    if (type==1) {
        if (self.haveNoMoreData_Rec) {
            [self noticeNoreMoreDataWithType:type];
            return;
        }
        NSDictionary *dict = @{@"page":@(self.pageNum_Rec),@"token":ToKen};
        NSLog(@"dict1 %@",dict);
        [PPNetworkHelper POST:URL_Add(@"/v.php/goods.share/getGoodsList") parameters:dict success:^(id responseObject) {
            
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == SucCode) {
                NSArray *array = [CommunityRecommendInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
                    self.logo1 = responseObject[@"data"][@"logo"];
                NSLog(@"array.count %zd",array.count);
                for (CommunityRecommendInfo *info in array) {
                    info.type = type;
                    [self handleCollectionWithInfo:info];
                }
                NSInteger totalPage = [responseObject[@"data"][@"totalpage"] integerValue];
                NSInteger curPage = [responseObject[@"data"][@"page"] integerValue];
                if ( curPage >= totalPage) {
                    self.haveNoMoreData_Rec = YES;
                    [self noticeNoreMoreDataWithType:type];
                }else{
                    self.haveNoMoreData_Rec = NO;
                }
                
                if (array.count || self.pageNum_Rec != 1) { //第一页有数据或者第二页起进来
                    
                    if (self.pageNum_Rec ==1) {
                        self.RecomArr = array.mutableCopy;
                    }else{
                         [self.RecomArr addObjectsFromArray:array];
                    }
                    
                    [self noticeDataWithType:type dataArr:self.RecomArr logo:self.logo1];
                    self.pageNum_Rec = curPage;
                }else{//提示无数据
                    [self noticeBlankViewWithType:type];
                }
                
            }else{//提示无数据
                if (code == NoDataCode) {
                     [self noticeBlankViewWithType:type];
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"error  %@",error);
        }];
    }else if (type ==2){
        
        if (self.haveNoMoreData_Marketing) {
            [self noticeNoreMoreDataWithType:type];
            return;
        }
          NSDictionary *dict = @{@"page":@(self.pageNum_Marketing),@"token":ToKen};
         NSLog(@"dict2 %@",dict);
        [PPNetworkHelper POST:URL_Add(@"/v.php/goods.share/getMarketList") parameters:dict success:^(id responseObject) {
            NSLog(@"营销素材responseObject %@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == SucCode) {
                NSArray *array = [CommunityRecommendInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
                for (CommunityRecommendInfo *info in array) {
                    info.type = type;
                      [self handleCollectionWithInfo:info];
                  
                    if (![info.live_url strIsEmptyOrNot]) {
                        NSLog(@"info.live_url  =%@",info.live_url);
                        NSMutableArray *mut = [NSMutableArray arrayWithArray:info.pics];
                        [mut insertObject:info.live_pic atIndex:0];
                        info.pics = mut.copy;
                    }
                    
                }
                NSInteger totalPage = [responseObject[@"data"][@"totalPage"] integerValue];
                 NSInteger cur_Page = [responseObject[@"data"][@"page"] integerValue];
                if (totalPage <= cur_Page) {
                    self.haveNoMoreData_Marketing = YES;
                    [self noticeNoreMoreDataWithType:type];
                }else{
                    self.haveNoMoreData_Marketing = NO;
                }
                
                if (array.count || self.pageNum_Marketing != 1) { //第一页有数据或者第二页起进来
                    if (self.pageNum_Marketing ==1) {
                        self.MarketArr = array.mutableCopy;
                    }else{
                        [self.MarketArr addObjectsFromArray:array];
                    }
                    
                    self.pageNum_Marketing  = cur_Page;
                    [self noticeDataWithType:type dataArr:self.MarketArr logo:self.logo2];
                }else{//提示无数据
                    [self noticeBlankViewWithType:type];
                }
                
            }else{//提示无数据
                if (code == NoDataCode) {
                    [self noticeBlankViewWithType:type];
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"营销素材 error  %@",error);
        }];
        
        
    }
  
    
}


#pragma mark -  private
- (void)handleCollectionWithInfo:(CommunityRecommendInfo*)info{
    CGFloat gap = 10;
    if (info.pics.count ==1) {
       
        info.item_width  = 140;
        info.item_height = 140;
        info.collection_width  =  info.item_width;
        info.collection_height =  info.item_height;
    }else if (info.pics.count ==2 ||info.pics.count ==4){
        info.item_width  = 140;
        info.item_height = 140;
        info.collection_width  =  info.item_width *2 + gap;
        info.collection_height = info.pics.count ==2? info.item_height: info.collection_width;
    }else{
        info.item_width  = 90;
        info.item_height = 90;
        info.collection_width  = info.item_width*3 + gap*2;
        if (info.pics.count==3) {
            info.collection_height = info.item_height;
        }else if (info.pics.count==5||info.pics.count==6){
            info.collection_height = info.item_height *2 + gap;
        }else{//7,8,9
            info.collection_height = info.item_height *3 + gap*2;
        }
    }
    
}
- (void)noticeDataWithType:(NSInteger)type dataArr:(NSArray*)array logo:(NSString*)logo{
    if ([self.delegate respondsToSelector:@selector(communityModel:dataSouse:type:logo:)]) {
        [self.delegate communityModel:self dataSouse:array type:type logo:logo];
    }
}

- (void)noticeNoreMoreDataWithType:(NSInteger)type {
    if ([self.delegate respondsToSelector:@selector(noticeNomoreDataWithCommunityModel:type:)]) {
        [self.delegate noticeNomoreDataWithCommunityModel:self type:type];
    }
}

- (void)noticeBlankViewWithType:(NSInteger)type {
    if ([self.delegate respondsToSelector:@selector(noticeBlankViewWithModel:type:)]) {
        [self.delegate noticeBlankViewWithModel:self type:type];
    }
}
@end



@implementation CommunityRecommendInfo


@end
