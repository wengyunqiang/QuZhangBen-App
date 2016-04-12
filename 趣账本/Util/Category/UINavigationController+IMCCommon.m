//
//  UINavigationController+IMCCommon.m
//  iMacheng-iOS
//
//  Created by Wensj on 7/16/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "UINavigationController+IMCCommon.h"
#import <objc/runtime.h>

#define kDuration 0.4f

@implementation UINavigationController (IMCCommon)

- (void)showPopupContentView:(UIView *)popupContentView {
    if (!self.popupMaskView) {
        self.popupMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.popupMaskView.backgroundColor = [[UIColor imc_colorWithRGBHex:kColorMaskView] colorWithAlphaComponent:0.5];
        [self.popupMaskView bk_whenTapped:^{
            [self hidePopupContentView];
        }];
    }
    self.popupContentView = popupContentView;
    
    if ([self.view.subviews containsObject:self.popupMaskView]) return;
    self.popupMaskView.alpha = 0;
    [self.view addSubview:self.popupMaskView];
    [self.popupContentView imc_setY:CGRectGetMaxY(self.view.frame)];
    [self.view addSubview:self.popupContentView];
    [UIView animateWithDuration:kDuration animations:^{
        self.popupMaskView.alpha = 1.0;
        [self.popupContentView imc_setY:(CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.popupContentView.frame))];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePopupContentView {
    if ([self.view.subviews containsObject:self.popupMaskView]) {
        [UIView animateWithDuration:kDuration animations:^{
            self.popupMaskView.alpha = 0;
            [self.popupContentView imc_setY:CGRectGetMaxY(self.view.frame)];
        } completion:^(BOOL finished) {
            [self.popupMaskView removeFromSuperview];
            [self.popupContentView removeFromSuperview];
        }];
    }
}

+ (UINavigationController *)commonNavigationControllerWithRootViewController:(UIViewController *)viewController {
    if (viewController) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"nav_back_down"] style:UIBarButtonItemStylePlain handler:^(id sender) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
        }];
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
        return navigationController;
    }
    return nil;
}

#pragma mark - Setter/Getter
- (UIView *)popupMaskView {
    return objc_getAssociatedObject(self, @selector(popupMaskView));
}

- (void)setPopupMaskView:(UIView *)popupMaskView {
    objc_setAssociatedObject(self, @selector(popupMaskView), popupMaskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)popupContentView {
    return objc_getAssociatedObject(self, @selector(popupContentView));
}

- (void)setPopupContentView:(UIView *)popupContentView {
    objc_setAssociatedObject(self, @selector(popupContentView), popupContentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
