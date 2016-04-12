//
//  RecordHeaderCell.m
//  趣账本
//
//  Created by wengYQ on 15/12/18.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "RecordHeaderCell.h"

@interface RecordHeaderCell()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation RecordHeaderCell

- (void)awakeFromNib {
    _view1.layer.cornerRadius = 5;
    _view2.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
