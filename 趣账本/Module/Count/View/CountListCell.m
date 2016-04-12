//
//  CountListCell.m
//  趣账本
//
//  Created by wengYQ on 15/12/19.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "CountListCell.h"

@implementation CountListCell

- (void)awakeFromNib {
    self.colorView.layer.cornerRadius = 15*0.5;
        self.FeeValueLb.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16];
        self.RateLb.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16];
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.width.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = Color_Line;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
