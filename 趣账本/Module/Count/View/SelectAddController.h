//
//  SelectAddController.h
//  趣账本
//
//  Created by wengYQ on 15/12/22.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
typedef void (^FinishAddBlock)(void);
@interface SelectAddController : UIViewController
@property (nonatomic,strong) UserModel *rootUser;
@property (nonatomic,copy) FinishAddBlock finishAddBlock;
@end
