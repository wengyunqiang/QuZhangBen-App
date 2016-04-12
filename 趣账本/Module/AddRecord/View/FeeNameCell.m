//
//  FeeNameCell.m
//  趣账本
//
//  Created by wengYQ on 15/12/22.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "FeeNameCell.h"

@interface FeeNameCell()
@property (nonatomic,strong) UILabel *label;
@end

@implementation FeeNameCell
- (void)drawRect:(CGRect)rect {
    self.layer.shouldRasterize = YES;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5f;
}

- (void)setFeeName:(NSString *)FeeName {
    if (_FeeName != FeeName) {
        _FeeName = FeeName;
    }
    if (!_label) {
        _label = ({
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor imc_colorWithRGBHex:0x3d3d3d];
            label.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:label];
            label;
        });
    }
    
    self.backgroundColor = [UIColor clearColor];
    _label.text = _FeeName;
}

- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
    }
    if (_isSelected) {
        _label.textColor = [UIColor orangeColor];
        self.layer.borderColor = [UIColor orangeColor].CGColor;
    } else {
        self.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor imc_colorWithRGBHex:0x3d3d3d];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}
@end
