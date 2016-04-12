//
//  AvatarCell.m
//  趣账本
//
//  Created by wengYQ on 15/12/14.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "AvatarCell.h"
@interface AvatarCell()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIButton *ChangeAvatarBtn;
@property (nonatomic,strong) NSData *avatarImageData;
@end
@implementation AvatarCell

- (void)awakeFromNib {
    UIImage *image = [UIImage imageNamed:@"LoginBackGround.jpg"];
    [_ChangeAvatarBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_ChangeAvatarBtn.layer setCornerRadius:5];
    _ChangeAvatarBtn.clipsToBounds = YES;
    [_ChangeAvatarBtn setTitle:@"设置头像" forState:UIControlStateNormal];

//设置头像
    _avatarImage.userInteractionEnabled = YES;
    _avatarImage.layer.cornerRadius = _avatarImage.bounds.size.width/2.0;
    _avatarImage.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75].CGColor;
    _avatarImage.layer.borderWidth = 2.0;
    _avatarImage.clipsToBounds = YES;
    _avatarImage.contentMode = UIViewContentModeScaleAspectFit;
    [_ChangeAvatarBtn addTarget:self action:@selector(ClickChangeAvatarBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //给imageDataBlock赋值
    MCSelf(weakSelf);
    self.imageDataBlock = ^{
        NSData *avatarData = UIImageJPEGRepresentation(weakSelf.avatarImage.image, 0.3);
        return avatarData;
    };
}

- (void) ClickChangeAvatarBtn{
    if (self.tapBlock) {
        self.tapBlock();
    }
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"现在拍一张照片",@"从相册中选一张照片", nil];
    UIViewController *rootVC = [self imc_viewController];
    [sheet showInView:rootVC.view];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    _avatarImage.image = [UIImage imageWithData:UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.5)];
    self.avatarImageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.2);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    UIViewController *rootVC = [self imc_viewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}
@end
