//
//  UIImage+IMCCommon.h
//  iMacheng-iOS
//
//  Created by Wensj on 6/12/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (IMCCommon)

+ (UIImage *)imc_imageWithColor:(UIColor *)aColor;
+ (UIImage *)imc_imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
+ (UIImage *)imc_fullResolutionImageFromALAsset:(ALAsset *)asset;
+ (UIImage *)imc_fullScreenImageALAsset:(ALAsset *)asset;
- (UIImage *)imc_scaledToSize:(CGSize)targetSize;
- (UIImage *)imc_scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
- (UIImage *)imc_scaledToMaxSize:(CGSize )size;
@end
