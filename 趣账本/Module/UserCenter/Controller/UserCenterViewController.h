//
//  UserCenterViewController.h
//  趣账本
//
//  Created by wengYQ on 15/12/25.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
typedef void (^ChangeUserNameBlock)(void);
@interface UserCenterViewController : UIViewController
- (instancetype)initWithRootUser:(UserModel *)rootUser;
@property (nonatomic,copy) ChangeUserNameBlock changeUserNameBlock;
@property (nonatomic,copy) NSString *userName;
@end
