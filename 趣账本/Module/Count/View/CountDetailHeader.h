//
//  CountDetailHeader.h
//  趣账本
//
//  Created by wengYQ on 15/12/28.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDetailHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *PercentLb;
@property (weak, nonatomic) IBOutlet UILabel *FeeNameLb;
@property (weak, nonatomic) IBOutlet UILabel *FeeSumLb;

@end
