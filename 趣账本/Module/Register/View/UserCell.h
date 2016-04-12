//
//  UserCell.h
//  趣账本
//
//  Created by wengYQ on 15/12/14.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
typedef NSData * (^BringImageDataBlock)(void);
@interface UserCell : UITableViewCell
@property (nonatomic,copy) UserModel *CellUser;
@property (nonatomic,copy) BringImageDataBlock imageDataBlock;
@end
