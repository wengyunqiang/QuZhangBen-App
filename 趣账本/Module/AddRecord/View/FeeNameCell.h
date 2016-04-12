//
//  FeeNameCell.h
//  趣账本
//
//  Created by wengYQ on 15/12/22.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCCellIdentifierFeeCell @"FeeNameCell"
@interface FeeNameCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSString *FeeName;
@end
