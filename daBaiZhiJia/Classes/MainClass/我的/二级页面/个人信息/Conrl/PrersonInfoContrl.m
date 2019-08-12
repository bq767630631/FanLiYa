//
//  PrersonInfoContrl.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/11.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PrersonInfoContrl.h"
#import "KLSwitch.h"
#import "ChangePersonContrl.h"
#import "LoginContrl.h"
#import "PrersonInfoModel.h"
#import "UIImageView+WebCache.h"
#import <AlibabaAuthSDK/albbsdk.h>
#import "DetailWebContrl.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>


@interface PrersonInfoContrl ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containTop;
@property (weak, nonatomic) IBOutlet UIImageView *headimageView;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *wxNum;

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet KLSwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, assign) BOOL  isAuthFail; //是否 是授权失败 默认no
@property (nonatomic, strong) PrersonInfoMsg *info;
@property (nonatomic, copy) NSString *authUrl;
@end

@implementation PrersonInfoContrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self initMethod];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar navBarBackGroundColor:ThemeColor image:nil isOpaque:YES];
}

- (void)initMethod{
    
    self.containTop.constant = NavigationBarBottom(self.navigationController.navigationBar);
    ViewBorderRadius(self.loginBtn, 20, ThemeColor);
    ViewBorderRadius(self.headimageView, self.headimageView.width /2,  RGBColor(227, 227, 227));
    self.switchBtn.tintColor = RGBColor(220, 220, 220);
    self.switchBtn.onTintColor = RGBColor(241, 152, 51);
    
    [self.switchBtn setDidChangeHandler:^(BOOL isOn) {
        NSLog(@"switchBtn is on =%d",isOn); 
        if (isOn) {
            if (self.info.relation_id!=0) {
                return ;
            }
            [[ALBBSDK sharedInstance] setAuthOption:NormalAuth];
            [[ALBBSDK sharedInstance] auth:self successCallback:^(ALBBSession *session) {
                
                [self openTbWithUrl:self.authUrl];

            } failureCallback:^(ALBBSession *session, NSError *error) {
                 self.isAuthFail = YES;
                [self.switchBtn setOn:NO animated:YES];
            }];
        }else{
            if (self.isAuthFail) { //如果是授权失败 不执行下面代码
                self.isAuthFail = NO;
            }else{
                [[ALBBSDK sharedInstance] logoutWithCallback:^{
                    self.switchBtn.on = NO;
                    self.info.relation_id = 0;
                    [YJProgressHUD showMsgWithoutView:@"授权取消"];
                    NSLog(@"logoutWithCallback");
                }];
            }
           
        }
    }];
    
    [PrersonInfoModel queryPersonWithBlock:^(PrersonInfoMsg * info) {
        if (info) {
            self.info = info;
            [self.headimageView setPlaceholderImageWithFullPath:info.wechat_image placeholderImage:@"img_head_moren"];
            self.userName.text = info.wechat_name;
            self.sex.text = info.sex ==1?@"男":@"女";
            self.wxNum.text = info.wechat_account;
            self.phoneNum.text = info.phone;
            self.switchBtn.on = !(info.relation_id == 0);
        }
    }];
    
    [PrersonInfoModel queryTaboBaoAuthUrlWithCallBack:^(NSString *url) {
        self.authUrl = url;
    }];
}

- (void)openTbWithUrl:(NSString *)url{    
    id<AlibcTradePage> page = [AlibcTradePageFactory page:url];
    
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeH5;
    showParam.backUrl = @"tbopen27546131://";
    [[AlibcTradeSDK sharedInstance].tradeService show:self page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        NSLog(@"result %@",result);
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        NSLog(@"error %@", error);
    }];
}

#pragma mark -  UIImagePickerControllerDelegate
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSLog(@"选择照片=%@",info);
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];

        self.headimageView.image = image;
        [PrersonInfoModel modifyHeadImageWithimage:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)openCameraOrChosePicWithType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.navigationBar.translucent = NO;//去除毛玻璃效果
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11){
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")])
    {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
             if (obj.frame.size.width < 42){
                 [viewController.view sendSubviewToBack:obj];
                 *stop = YES;
             }
         }];
    }
}

#pragma mark - IBAction
- (IBAction)changeHeadPic:(UIButton *)sender {
     NSLog(@"");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet] ;
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            [self openCameraOrChosePicWithType:sourceType];
        }else
        {
            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"从相册中选择");
        [self openCameraOrChosePicWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)changeNichen:(UIButton *)sender {
     NSLog(@"");
    ChangePersonContrl *changeInfo = [[ChangePersonContrl alloc] initWithType:ChangeInfoType_niChen text:self.userName.text];
    [self.navigationController pushViewController:changeInfo animated:YES];
    @weakify(self);
    changeInfo.block = ^(NSString *str) {
        @strongify(self);
        self.userName.text = str;
    };
}

- (IBAction)changeSex:(UIButton *)sender {
     NSLog(@"");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet] ;
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sex.text = @"男";
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self modifySex:1];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          self.sex.text = @"女";
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self modifySex:2];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action4];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)changeWxNum:(UIButton *)sender {
    ChangePersonContrl *changeInfo = [[ChangePersonContrl alloc] initWithType:ChangeInfoType_wxNum text:self.wxNum.text];
    [self.navigationController pushViewController:changeInfo animated:YES];
    @weakify(self);
    changeInfo.block = ^(NSString *str) {
        @strongify(self);
        self.wxNum.text = str;
    };
}


- (IBAction)loginOutAction:(UIButton *)sender {
    NSLog(@"");
    [BlockAlertView showAlertWithAString:@"确定退出当前账号吗?" cancleTitle:@"取消" sureTitle:@"确认" complete:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            
            //清空登录数据
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //回到首页
            self.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
            self.navigationController.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - private
- (void)modifySex:(NSInteger)sex{
    NSDictionary *para =  @{@"token":ToKen, @"sex":@(sex),@"v":APP_Version};
    
    [PPNetworkHelper POST:URL_Add(@"/v.php/user.user/updUser")    parameters:para success:^(id responseObject) {
        NSLog(@"responseObject  %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [YJProgressHUD showMsgWithoutView:@"修改成功"];
            });
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}

@end
