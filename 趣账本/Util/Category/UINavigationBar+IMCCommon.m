//
//  UINavigationBar+IMCCommon.m
//  iMacheng-iOS
//
//  Created by Wensj on 6/19/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "UINavigationBar+IMCCommon.h"
#import <objc/runtime.h>

#define kStaticBarHeight 20.0f

@implementation UINavigationBar (IMCCommon)
static char newBackgroundViewKey;

- (void)imc_setBackgroundViewColor:(UIColor *)color {
    UIView *newBackgroundView = (UIView *)objc_getAssociatedObject(self, &newBackgroundViewKey);
    if (!newBackgroundView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        newBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -kStaticBarHeight, self.bounds.size.width, self.bounds.size.height + kStaticBarHeight)];
        newBackgroundView.userInteractionEnabled = NO;
        newBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.shadowImage = [UIImage imc_imageWithColor:[UIColor clearColor]];
        objc_setAssociatedObject(self, &newBackgroundViewKey, newBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self insertSubview:newBackgroundView atIndex:0];
    }
    newBackgroundView.backgroundColor = color;
}

- (void)imc_resetBackgroundView {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = nil;
    [((UIView *)objc_getAssociatedObject(self, &newBackgroundViewKey)) removeFromSuperview];
    objc_setAssociatedObject(self, &newBackgroundViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
