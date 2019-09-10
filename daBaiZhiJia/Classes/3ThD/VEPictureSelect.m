//
//  VEPictureSelect.m
//  VocationalEducation
//
//  Created by WH-JS on 2019/7/24.
//  Copyright © 2019 liu. All rights reserved.
//

#import "VEPictureSelect.h"

@interface VEPictureSelect()<UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong) UIViewController * rootViewController;

@property(nonatomic,strong) UIImagePickerController * photoVC;

@end

@implementation VEPictureSelect

- (instancetype)initWithView:(UIViewController*)viewControll{
    self.rootViewController = viewControll;
    return [super init];
}

-(void)changeIcon:(NSString *)title{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [actionSheet showInView:self.rootViewController.view];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 250;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.photoVC==nil) {
        self.photoVC=[[UIImagePickerController alloc]init];
        self.photoVC.delegate = (id)self;
        self.photoVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.photoVC.allowsEditing = YES;
        self.photoVC.navigationBar.translucent = NO;//去除毛玻璃效果
    }
    if (buttonIndex == 0){
        self.photoVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.rootViewController presentViewController:self.photoVC animated:YES completion:^{
            
        }];
    }else if(buttonIndex == 1){//调用相册
        self.photoVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.rootViewController presentViewController:self.photoVC animated:YES completion:^{
        }];
    }else{
        [actionSheet dismissWithClickedButtonIndex:2 animated:NO];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:^(void){
        [self.delegate iconChooseFinish:aImage];
    }];
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

@end
