//
//  CountListCell.h
//  趣账本
//
//  Created by wengYQ on 15/12/19.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *FeeNameLb;
@property (weak, nonatomic) IBOutlet UILabel *FeeValueLb;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *RateLb;

@end
