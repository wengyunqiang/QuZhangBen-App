//
//  UIView+IMCCommon.h
//  iMacheng-iOS
//
//  Created by Wensj on 6/15/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IMCCommon)

@property (nonatomic, strong) UIView *popupMaskView;
@property (nonatomic, strong) UIView *popupContentView;
- (void)showPopupContentView:(UIView *)popupContentView;
- (void)hidePopupContentView;

- (void)imc_setY:(CGFloat)y;
- (void)imc_setX:(CGFloat)x;
- (void)imc_setOrigin:(CGPoint)origin;
- (void)imc_setHeight:(CGFloat)height;
- (void)imc_setWidth:(CGFloat)width;
- (void)imc_setSize:(CGSize)size;

- (UIViewController *)imc_viewController;
- (UINavigationController *)imc_navigationController;
@end
