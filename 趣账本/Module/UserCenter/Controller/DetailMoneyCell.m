//
//  DetailMoneyCell.m
//  趣账本
//
//  Created by wengYQ on 15/12/27.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "DetailMoneyCell.h"

@implementation DetailMoneyCell

- (void)awakeFromNib {
    // Initialization code
        self.moneyField.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
