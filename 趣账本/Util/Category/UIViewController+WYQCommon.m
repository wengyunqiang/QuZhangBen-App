//
//  UIViewController+WYQCommon.m
//  趣账本
//
//  Created by wengYQ on 15/12/15.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "UIViewController+WYQCommon.h"

@implementation UIViewController (WYQCommon)
- (void)setDefaultNavigationBar {
    NSShadow *shadow    = [[NSShadow alloc] init];
    shadow.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : [UIColor colorWithRed:0.961 green:1.000 blue:0.984 alpha:1.000],
                                                           NSShadowAttributeName : shadow,
                                                           NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0]}];
    //[UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.494 green:0.757 blue:0.765 alpha:1.000];
    [UINavigationBar appearance].tintColor    = [UIColor whiteColor];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"LoginBackGround.jpg"] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].barStyle     = UIBarStyleDefault;
}
@end
