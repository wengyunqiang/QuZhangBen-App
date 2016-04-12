//
//  UINavigationController+IMCCommon.h
//  iMacheng-iOS
//
//  Created by Wensj on 7/16/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (IMCCommon)

@property (nonatomic, strong) UIView *popupMaskView;
@property (nonatomic, strong) UIView *popupContentView;
- (void)showPopupContentView:(UIView *)popupContentView;
- (void)hidePopupContentView;
+ (UINavigationController *)commonNavigationControllerWithRootViewController:(UIViewController *)viewController;
@end
