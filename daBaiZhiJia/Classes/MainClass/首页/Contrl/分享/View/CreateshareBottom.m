//
//  CreateshareBottom.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "CreateshareBottom.h"
#import "JSHAREService.h"
#import "CreateShare_Model.h"
#import "DBZJ_CommunityModel.h"
#import "UIImageView+WebCache.h"

@interface CreateshareBottom ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn3LeadCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn3TrainCons;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UILabel *wxLb;

@property (weak, nonatomic) IBOutlet UIButton *frendBtn;
@property (weak, nonatomic) IBOutlet UILabel *frendLb;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UILabel *qqLb;

@property (weak, nonatomic) IBOutlet UIButton *qZonBtn;
@property (weak, nonatomic) IBOutlet UILabel *qzLb;


@end
@implementation CreateshareBottom

- (void)awakeFromNib{
    [super awakeFromNib];
    CGFloat wd = 60 * SCREEN_WIDTH/375;
    NSLog(@"wd %.f",wd);
    self.imageW.constant = wd;
    CGFloat gap = ( SCREEN_WIDTH - wd*5 - 10*2) /4;

    self.btn3LeadCons.constant =  self.btn3LeadCons.constant = gap;
   /* if (![JSHAREService isWeChatInstalled]) {
        self.wxLb.hidden = YES;
        self.wxBtn.hidden = YES;
        self.frendLb.hidden = YES;
        self.frendBtn.hidden = YES;
    }
    if (![JSHAREService isQQInstalled]) {
        self.qqLb.hidden = YES;
        self.qqBtn.hidden = YES;
        self.qZonBtn.hidden = YES;
        self.qzLb.hidden = YES;
    }*/
}

- (IBAction)wxChatAction:(UIButton *)sender {
    if (self.isFrom_sheQu) {
        [self handelSheQuShareWithtype:JSHAREPlatformWechatSession];
    }else if (self.isFrom_haiBao){
        [self handleHaiBaoWithtype:JSHAREPlatformWechatSession];
    }else{
        [self shareWithPlatform:JSHAREPlatformWechatSession];
    }
}

- (IBAction)wxSession:(UIButton *)sender {

    if (self.isFrom_sheQu) {
        [self handelSheQuShareWithtype:JSHAREPlatformWechatTimeLine];
    }else if (self.isFrom_haiBao){
        [self handleHaiBaoWithtype:JSHAREPlatformWechatTimeLine];
    }else{
        [self shareWithPlatform:JSHAREPlatformWechatTimeLine];
    }
}


- (IBAction)qqAction:(UIButton *)sender {
    if (self.isFrom_sheQu) {
        [self handelSheQuShareWithtype:JSHAREPlatformQQ];
    }else if (self.isFrom_haiBao){
        [self handleHaiBaoWithtype:JSHAREPlatformQQ];
    }else{
        [self shareWithPlatform:JSHAREPlatformQQ];
    }
}

- (IBAction)qZoneAction:(UIButton *)sender {
    if (self.isFrom_sheQu) {
        [self handelSheQuShareWithtype:JSHAREPlatformQzone];
    }else if (self.isFrom_haiBao){
        [self handleHaiBaoWithtype:JSHAREPlatformQzone];
    }else{
        [self shareWithPlatform:JSHAREPlatformQzone];
    }
}

- (IBAction)saveMesAction:(UIButton *)sender {
    if (self.isFrom_sheQu) {
        [self handleSheQu_SaveImages];
    }else if(self.isFrom_haiBao){
        [self handleHaiPaoSave_image];
    }else{
        [self handleCreateShareSaveImage];
    }
}

#pragma mark - hanlde
//创建分享
- (void)shareWithPlatform:(JSHAREPlatform)platform{
    if (self.selectedInfo == nil||[self.selectedInfo isKindOfClass:[NSNull class]]) {
        [YJProgressHUD showMsgWithoutView:@"请选中一张图片"];
        return;
    }
    JSHAREMessage *message = [JSHAREMessage message];
    message.platform = platform;
    message.mediaType = JSHAREImage;
    if (self.selectedInfo.isPoster) { //分享的是文案
          NSData *data = UIImageJPEGRepresentation(self.selectedInfo.image, 1);
        message.image = data;
        NSLog(@" %lu",(unsigned long)data.length);
    }else{//分享的是普通图片
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.selectedInfo.imageStr]];
        message.image = data;
    }
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        NSLog(@"分享回调 state= %lu error =%@",(unsigned long)state, error);
    }];
}

//社区
- (void)handelSheQuShareWithtype:(JSHAREPlatform)platform{
    
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSString *imgurl in self.comInfo.pics ) {
        UIImageView *tempIV = [UIImageView new];
        [tempIV sd_setImageWithURL:[NSURL URLWithString:imgurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                
                  [imageArr addObject:image];
            }
        }];
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:imageArr applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop, UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo,UIActivityTypeMessage,UIActivityTypeMail];
    if (self.block) {
        self.block();
    }
    [self.cur_vc presentViewController:activityVC animated:YES completion:^{
      
    }];
}

//保存创建分享的图片（一张）
- (void)handleCreateShareSaveImage{
    if (self.selectedInfo == nil||[self.selectedInfo isKindOfClass:[NSNull class]]) {
        [YJProgressHUD showMsgWithoutView:@"请选中一张图片"];
        return;
    }
    UIImage *saveImage = nil;
    if (self.selectedInfo.isPoster) {//保存的是文案
        saveImage = self.selectedInfo.image;
         UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        UIImageView *tempIV = [UIImageView new];
        [tempIV sd_setImageWithURL:[NSURL URLWithString:self.selectedInfo.imageStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                // 保存图片
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
    }
   
}

- (void)handleHaiBaoWithtype:(JSHAREPlatform)platform{
    
    JSHAREMessage *message = [JSHAREMessage message];
    message.platform = platform;
    message.mediaType = JSHAREImage;
    message.image =     UIImageJPEGRepresentation(self.model, .5);
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        NSLog(@"分享回调 state= %lu error =%@",(unsigned long)state, error);
    }];
}

//保存多张图片(社区)
- (void)handleSheQu_SaveImages{
    for (NSString *imageUrl in self.comInfo.pics) {
        UIImageView *tempIV = [UIImageView new];
        [tempIV sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                // 保存图片
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
    }
    [self delayDoWork:0.5 WithBlock:^{
         [YJProgressHUD showMsgWithoutView:@"保存图片成功"];
    }];
}

- (void)handleHaiPaoSave_image{
    if (!self.model) {
        [YJProgressHUD showMsgWithoutView:@"图片为空"];
        return;
    }
      UIImageWriteToSavedPhotosAlbum(self.model, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"msg %@",msg);
    if (!self.isFrom_sheQu) {
         [YJProgressHUD showMsgWithoutView:msg];
    }
   
}
@end
