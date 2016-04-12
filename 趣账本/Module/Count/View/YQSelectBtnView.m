//
//  YQSelectBtnView.m
//  趣账本
//
//  Created by wengYQ on 15/12/21.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "YQSelectBtnView.h"
@interface YQSelectBtnView()

@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIColor *stringColor;

@end
@implementation YQSelectBtnView

-(instancetype) initWithBtnName1:(NSString *)Name1 Name2:(NSString *)Name2 withFrame:(CGRect)frame withStringColor:(UIColor *)stringColor{
    if (self == [super initWithFrame:frame]) {
    _stringColor = stringColor;
        _button1 = [[UIButton alloc]init];
        [self addSubview:_button1];
        MCSelf(weakSelf);
        [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.height.equalTo(weakSelf);
            make.width.mas_equalTo(frame.size.width*0.5);
            make.left.equalTo(weakSelf);
        }];
        _button2 = [[UIButton alloc]init];
        [self addSubview:_button2];
        [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.height.equalTo(weakSelf);
            make.width.mas_equalTo(frame.size.width*0.5);
            make.left.mas_equalTo(weakSelf.button1.mas_right);
        }];
        [_button1 setTitle:Name1 forState:UIControlStateNormal];
        [_button2 setTitle:Name2 forState:UIControlStateNormal];
        [_button1 setTitleColor:stringColor forState:UIControlStateNormal];
        [_button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithWhite:0.721 alpha:1.000].CGColor;
        self.layer.cornerRadius = 5;
        [_button1 addTarget:self action:@selector(ClickBtn1) forControlEvents:UIControlEventTouchUpInside];
        [_button2 addTarget:self action:@selector(ClickBtn2) forControlEvents:UIControlEventTouchUpInside];
        [_button1.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_button2.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithWhite:0.721 alpha:1.000];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.mas_equalTo(weakSelf.button1.mas_right);
            make.width.mas_equalTo(1);
            make.height.equalTo(weakSelf);
        }];
        self.defaultStatusBlock = ^{
            [weakSelf.button1 setTitleColor:weakSelf.stringColor forState:UIControlStateNormal];
            [weakSelf.button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        };
    }
    return self;
}

-(void)ClickBtn1{
    [_button1 setTitleColor:_stringColor forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if (self.block1){
        self.block1();
    }
}

-(void)ClickBtn2{
    [_button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_button2 setTitleColor:_stringColor forState:UIControlStateNormal];
    if (self.block2){
        self.block2();
    }
}
@end
