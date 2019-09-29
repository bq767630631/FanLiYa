//
//  GoodDetailModel.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailModel.h"
#import "HSDownloadManager.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPSessionManager.h"

@interface GoodDetailModel ()
@property (nonatomic, copy) NSString *sku;

@property (nonatomic, strong) NSMutableArray *tuiJianArr;

@property (nonatomic, copy) NSString *videoUrl;
@end
@implementation GoodDetailModel

- (instancetype)initWithSku:(NSString*)sku{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.sku = sku;
    return self;
}


- (void)queryData{
      
    NSDictionary *dic = @{@"sku":self.sku, @"token":ToKen,@"v":APP_Version};
    NSLog(@"para:%@",dic);
    NSString *url  = @"/v.php/goods.goods/getGoodsDetailNew";
    if (self.pt == FLYPT_Type_Pdd) {
        url = @"/v.php/goods.pdd/getGoodsDetail";
    }else if (self.pt == FLYPT_Type_JD){
        url = @"/v.php/goods.jd/getGoodsDetail";
    }
       //商品详情
     @weakify(self);
    [PPNetworkHelper POST:URL_Add(url) parameters:dic success:^(id responseObject) {
         @strongify(self);
       NSLog(@"详情responseObject  %@",responseObject);
//        NSLog(@"详情请求完毕");
         NSInteger code = [responseObject[@"code"] integerValue];

        if (code == SucCode) {  //
           GoodDetailInfo *info = [GoodDetailInfo mj_objectWithKeyValues:responseObject[@"data"]];
            info.price = [NSString stringRoundingTwoDigitWithNumber:info.price.doubleValue];
            info.market_price = [NSString stringRoundingTwoDigitWithNumber:info.market_price.doubleValue];
            info.profit = [NSString stringRoundingTwoDigitWithNumber:info.profit.doubleValue];
            info.share_profit = [NSString stringRoundingTwoDigitWithNumber:info.share_profit.doubleValue];
            
             self.detailinfo = info;
            if (self.pt!= FLYPT_Type_Pdd && self.pt!= FLYPT_Type_JD) {//查询推荐商品
                  [self queryTuiJianGood];
            }else{//pdd ,jd
                
                if ([self.delegate respondsToSelector:@selector(detailModel:querySucWithDetailInfo:tuiJianArr:)]) {
                    [self.delegate detailModel:self querySucWithDetailInfo:self.detailinfo tuiJianArr: @[].mutableCopy];
                }
            }
          
        }else{ //code!=2000 显示失效界面
            if ([self.delegate respondsToSelector:@selector(detailModel:queryFail:)]) {
                [self.delegate detailModel:self queryFail:responseObject];
            }
        }

    } failure:^(NSError *error) {
        NSLog(@"error  %@",error);
        if ([self.delegate respondsToSelector:@selector(detailModel:noticeError:)]) {
            [self.delegate detailModel:self noticeError:error];
        }
    }];
    
}

- (void)queryTuiJianGood{
    NSDictionary *dic = @{@"cateid":self.detailinfo.cateid, @"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getGoodsTuijianNew") parameters:dic success:^(id responseObject) {
        
        // NSLog(@"推荐商品responseObject  %@",responseObject);
         NSLog(@"推荐商品请求完毕");
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            self.tuiJianArr =  [SearchResulGoodInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            if ([self.delegate respondsToSelector:@selector(detailModel:querySucWithDetailInfo:tuiJianArr:)]) {
                [self.delegate detailModel:self querySucWithDetailInfo:self.detailinfo tuiJianArr: self.tuiJianArr];
            }
        }
        
    } failure:^(NSError *error) {
        
        //NSLog(@"推荐商品 error  %@",error);
        if ([self.delegate respondsToSelector:@selector(detailModel:noticeError:)]) {
            [self.delegate detailModel:self noticeError:error];
        }
    }];
}


- (void)queryViewPeople{
    NSDictionary *para = @{@"sku":self.sku, @"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getGoodsShow") parameters:para success:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
//        NSLog(@"弹幕 %@",responseObject);
        if (code == SucCode) {
            NSMutableArray *list =   [GoodDetailViewInfo mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSMutableArray *temp = [NSMutableArray array];
            for (GoodDetailViewInfo *info in list) {
                NSString *str = [NSString stringWithFormat:@"%@  %@",info.name, info.title];
                [temp addObject:str];
            }
            [self.delegate detailModel:self viewPeople:temp];
        }
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}


+ (void)handleDownloadActionWith:(GoodDetailBannerInfo *)info{
    if (info.videoUrl) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSURL *urlNew = [NSURL URLWithString:info.videoUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
       NSURLSessionDownloadTask *task  =  [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
         //设置下载路径，并将文件写入沙盒，最后返回NSURL对象
          NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
          NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
           
          return [NSURL fileURLWithPath:path];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([filePath path]);
            NSLog(@"下载视频 %d",compatible);
            if (compatible) {
                UISaveVideoAtPathToSavedPhotosAlbum([filePath path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
        [task resume];
    }
    if (info.pic) {
         NSLog(@"下载图片");
        UIImageView *tempIV = [UIImageView new];
        [tempIV sd_setImageWithURL:[NSURL URLWithString:info.pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                // 保存图片
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
    }
}

+(void)pddGetYouhuiQuanWithsku:(NSString*)sku CallBack:(VEBlock)callBack{
    NSDictionary *para = @{@"sku":sku,@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper GET:URL_Add(@"/v.php/goods.pdd/getCoupon") parameters:para success:^(id responseObject) {
        NSLog(@"pdd/getCoupon %@",responseObject);
          NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode && ![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
            NSDictionary *dic = responseObject[@"data"];
            callBack(dic);
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        callBack(nil);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}

+ (void)jdGetYouhuiQuanWithsku:(NSString *)sku couponUrl:(NSString *)couponUrl CallBack:(VEBlock)callBack{
    NSDictionary *para = @{@"sku":sku,@"couponUrl":couponUrl,@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper GET:URL_Add(@"/v.php/goods.jd/getCoupon") parameters:para success:^(id responseObject) {
        NSLog(@"jd/getCoupon %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode && ![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
            NSDictionary *dic = responseObject[@"data"];
            callBack(dic);
        }else{
            [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        callBack(nil);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}

#pragma mark - private
+ (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }else{
         [YJProgressHUD showMsgWithoutView:@"视频保存成功"];
    }
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"图片保存失败";
    }else{
        msg = @"图片保存成功";
    }
     [YJProgressHUD showMsgWithoutView:msg];
}


@end


@implementation GoodDetailInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"recommendlist":[SearchResulGoodInfo class]};
}

@end

@implementation GoodDetailBannerInfo


@end
@implementation GoodDetailViewInfo



@end
