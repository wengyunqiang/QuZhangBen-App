//
//  YQSelectBtnView.h
//  趣账本
//
//  Created by wengYQ on 15/12/21.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedBlock)(void);
typedef void (^DefaultStatusBlock)(void);
@interface YQSelectBtnView : UIView

-(instancetype) initWithBtnName1:(NSString *)Name1 Name2:(NSString *)Name2 withFrame:(CGRect)frame withStringColor:(UIColor *)stringColor;
@property (nonatomic,strong) SelectedBlock block1;
@property (nonatomic,strong) SelectedBlock block2;
@property (nonatomic,strong) DefaultStatusBlock defaultStatusBlock;
@end
