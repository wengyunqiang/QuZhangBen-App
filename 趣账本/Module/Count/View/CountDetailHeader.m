//
//  CountDetailHeader.m
//  趣账本
//
//  Created by wengYQ on 15/12/28.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "CountDetailHeader.h"

@implementation CountDetailHeader

- (void)awakeFromNib {
    // Initialization code
            self.FeeSumLb.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16];
            self.PercentLb.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
