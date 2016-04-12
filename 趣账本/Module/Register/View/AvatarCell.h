//
//  AvatarCell.h
//  趣账本
//
//  Created by wengYQ on 15/12/14.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TapBlock)(void);
typedef NSData* (^ImageDataBlock)(void);
@interface AvatarCell : UITableViewCell
@property (nonatomic,copy) TapBlock tapBlock;
@property (nonatomic,copy) ImageDataBlock imageDataBlock;

@end
