//
//  userCenterCell.m
//  趣账本
//
//  Created by wengYQ on 15/12/26.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "userCenterCell.h"

@implementation userCenterCell

- (void)awakeFromNib {
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    MCSelf(weakSelf);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = [UIColor colorWithWhite:0.903 alpha:1.000];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
