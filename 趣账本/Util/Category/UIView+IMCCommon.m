//
//  UIView+IMCCommon.m
//  iMacheng-iOS
//
//  Created by Wensj on 6/15/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "UIView+IMCCommon.h"
#import <objc/runtime.h>

#define kDuration 0.4f
@implementation UIView (IMCCommon)
- (void)imc_setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)imc_setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)imc_setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (void)imc_setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)imc_setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)imc_setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

- (UIViewController *)imc_viewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]]) {
        responder = responder.nextResponder;
    }
    return (UIViewController *)responder;
}

- (UINavigationController *)imc_navigationController {
    UIViewController *vc = [self imc_viewController];
    if (vc) {
        UINavigationController *navVC = vc.navigationController;
        if (navVC) {
            return navVC;
        }
    }
    return nil;
}


- (void)showPopupContentView:(UIView *)popupContentView {
    if (!self.popupMaskView) {
        self.popupMaskView = [[UIView alloc] initWithFrame:self.bounds];
        self.popupMaskView.backgroundColor = [[UIColor imc_colorWithRGBHex:kColorMaskView] colorWithAlphaComponent:0.5];
        [self.popupMaskView bk_whenTapped:^{
            [self hidePopupContentView];
        }];
    }
    self.popupContentView = popupContentView;
    
    if ([self.subviews containsObject:self.popupMaskView]) return;
    self.popupMaskView.alpha = 0;
    [self addSubview:self.popupMaskView];
    [self.popupContentView imc_setY:CGRectGetMaxY(self.frame)];
    [self addSubview:self.popupContentView];
    [UIView animateWithDuration:kDuration animations:^{
        self.popupMaskView.alpha = 1.0;
        [self.popupContentView imc_setY:(CGRectGetHeight(self.frame) - CGRectGetHeight(self.popupContentView.frame))];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePopupContentView {
    if ([self.subviews containsObject:self.popupMaskView]) {
        [UIView animateWithDuration:kDuration animations:^{
            self.popupMaskView.alpha = 0;
            [self.popupContentView imc_setY:CGRectGetMaxY(self.frame)];
        } completion:^(BOOL finished) {
            [self.popupMaskView removeFromSuperview];
            [self.popupContentView removeFromSuperview];
        }];
    }
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
