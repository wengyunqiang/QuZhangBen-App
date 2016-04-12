//
//  UserCenterAvatarCell.m
//  趣账本
//
//  Created by wengYQ on 15/12/26.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "UserCenterAvatarCell.h"
#import "IMCNetAPIManager.h"
#import "UserModel.h"
#import<SDWebImage/UIImageView+WebCache.h>
@interface UserCenterAvatarCell()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) NSData *avatarImageData;
@end

@implementation UserCenterAvatarCell

- (void)awakeFromNib {
    _avatarImageView.userInteractionEnabled = YES;
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width/2.0;
    _avatarImageView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75].CGColor;
    _avatarImageView.layer.borderWidth = 2.0;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    MCSelf(weakSelf);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = [UIColor colorWithWhite:0.903 alpha:1.000];
    
    [self bk_whenTapped:^{
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"现在拍一张照片",@"从相册中选一张照片", nil];
        UIViewController *rootVC = [self imc_viewController];
        [sheet showInView:rootVC.view];
    }];
}

#pragma mark - UIActionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self openCamera];
        }
        
    } else if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self openPhotoLibrary];
        }
    }
}

/**
 *  打开相机
 */
- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    UIViewController *rootVC = [self imc_viewController];
    [rootVC presentViewController:ipc animated:YES completion:nil];
}

/**
 *  打开相册
 */
- (void)openPhotoLibrary
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    UIViewController *rootVC = [self imc_viewController];
    [rootVC presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - 图片选择控制器的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.avatarImageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.2);
    NSDictionary *ImageParams = @{
                                  @"userAccount" : self.rootUser.userAccount,
                                  @"image"       : self.avatarImageData
                                  };
    MCSelf(weakSelf);
    [[SDImageCache sharedImageCache] removeImageForKey:_rootUser.avatarURL fromDisk:YES];
    
    [SVProgressHUD showWithStatus:@"正在上传，请稍候..."];
    
    [[IMCNetAPIManager share] RequestUpLoadAvatar:ImageParams andBlock:^(Response *response) {
        if (response.isSuccess) {
            weakSelf.avatarImageView.image = [UIImage imageWithData:UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.5)];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"网络好像有点不给力，请重新再试"];
        }
        [SVProgressHUD dismiss];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    UIViewController *rootVC = [self imc_viewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

@end
