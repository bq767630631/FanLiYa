//
//  CreateShare_Model.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/3.
//  Copyright © 2019 包强. All rights reserved.
//

#import "CreateShare_Model.h"
#import "GoToAuth_View.h"
@implementation CreateShare_Model


+ (void)queryDetailInfoWithSku:(NSString *)sku  pt:(FLYPT_Type)pt Blcok:(detailInfo_Block)block{
    
    NSString *url  = @"/v.php/goods.goods/getGoodsDetailNew"; //默认淘宝
    if (pt == FLYPT_Type_Pdd) {//拼多多
        url = @"/v.php/goods.pdd/getGoodsDetail";
    }else if (pt == FLYPT_Type_JD){//京东
        url = @"/v.php/goods.jd/getGoodsDetail";
    }
    
    [PPNetworkHelper POST:URL_Add(url) parameters:@{@"sku":sku,@"token":ToKen,@"v":APP_Version} success:^(id responseObject) {
       // NSLog(@"详情responseObject  %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {  //
              GoodDetailInfo *info = [GoodDetailInfo mj_objectWithKeyValues:responseObject[@"data"]];
            block(info,nil);
        }
    } failure:^(NSError *error) {
         block(nil,error);
    }];
}
/*
 title
【原价】market_price
【券后价】price
shop_title+short_title
【下单地址】shorturl （可选）isAdd
【下载返利鸭再省】 profit （可选）isDown
---------
注册邀请码 code （可选） isRegisterCode
---------
长按復至£tao£，➡[掏✔寳]即可抢购 （可选）isTkl
 
 */
+ (NSString*)geneRateWenanWithDetail:(GoodDetailInfo*)info isAdd:(BOOL)isAdd isDown:(BOOL)isDown isRegisCode:(BOOL)isRegisCode isTkl:(BOOL)isTkl pt:(FLYPT_Type)pt
{
    
NSMutableString *wenanStr= [NSMutableString stringWithFormat:@"%@\n【原价】%@元\n【券后价】%@元",info.title,info.market_price,info.price];
    
    if (info.desc.length) {
         [wenanStr appendString:[NSString stringWithFormat:@"\n【推荐理由】%@",info.desc]];
    }
   
    if (isAdd) {
        [wenanStr appendString:[NSString stringWithFormat:@"\n【下单地址】%@",info.shorturl]];
    }
    if (isDown) {
         [wenanStr appendString:[NSString stringWithFormat:@"\n【下载返利鸭再省】%@元",info.profit]];
    }
    if (isRegisCode) {
        [wenanStr appendString:[NSString stringWithFormat:@"\n---------\n注册邀请码 %@\n---------",info.code]];
    }
    if (isTkl) {
        if (pt == FLYPT_Type_TM|| pt==FLYPT_Type_TB) {//天猫和淘宝才有
             [wenanStr appendString:[NSString stringWithFormat:@"\n长按復至£%@£，➡[掏✔寳]即可抢购",info.tkl]];
        }
    }
    
    if (pt == FLYPT_Type_Pdd|| pt==FLYPT_Type_JD) {//下载app地址
         [wenanStr appendString:[NSString stringWithFormat:@"\n【返利鸭下载地址】%@",info.downurl]];
    }
    
    //NSLog(@"wenanStr =%@",wenanStr);
    info.wenAnStr = wenanStr;
    CGFloat maxW = SCREEN_WIDTH - 22*2;
    CGFloat  strH = [wenanStr textHeightWithFont:[UIFont systemFontOfSize:13] maxWidth:maxW];
    if (pt == FLYPT_Type_TM|| pt==FLYPT_Type_TB) {
         info.shareContent_H = strH + 35 + 132 + 83 + (40 + 45 + 50) + 83 + 40;
    }else{
         info.shareContent_H = strH + 35 + 132 + 83 + (40 + 45 + 50) + 50;
    }
    
    NSLog(@"shareContent_H =%.f",info.shareContent_H);
    return wenanStr;
}

+ (void)geneRateTaoKlWithSku:(NSString*)sku vc:(UIViewController*)curVc navi_vc:(UINavigationController*)navi_vc block:(tklBlock)block  {
    NSDictionary *para = @{@"sku":sku,@"token":ToKen,@"v":APP_Version};
    NSLog(@"para =%@",para);
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getTao") parameters:para success:^(id responseObject) {
        NSLog(@"tkl res=%@", responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        
        if (code == SucCode) {
            NSDictionary *data = responseObject[@"data"];
            if (block) {
                block(data[@"tkl"],data[@"code"],data[@"shorturl"]);
            }
        }
        if (code == UnauthCode) {
            block(nil,nil,nil);
            GoToAuth_View *auth = [GoToAuth_View viewFromXib];
            [auth setAuthInfo];
            auth.cur_vc = curVc;
            auth.navi_vc = navi_vc;
            [auth showInWindowWithBackgoundTapDismissEnable:NO];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
          block(nil,nil,nil);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
    
}

+ (void)pddAndJdGetYouhuiQuanWithsku:(NSString *)sku pt:(FLYPT_Type)pt couponUrl:(NSString*)couponUrl CallBack:(VEBlock)callBack{
    NSDictionary *para = @{@"sku":sku,@"token":ToKen,@"v":APP_Version};
    if (pt == FLYPT_Type_JD) {
      para = @{@"sku":sku,@"couponUrl":couponUrl,@"token":ToKen,@"v":APP_Version};
    }
    NSString *url = (pt == FLYPT_Type_Pdd)?@"/v.php/goods.pdd/getCoupon":@"/v.php/goods.jd/getCoupon";
    [PPNetworkHelper GET:URL_Add(url) parameters:para success:^(id responseObject) {
        NSLog(@"getCoupon %@",responseObject);
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
@end


@implementation CreateShare_CellInfo

@end
