//
//  AddRecordViewController.h
//  趣账本
//
//  Created by wengYQ on 15/12/15.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface AddRecordViewController : UIViewController
- (instancetype)initWithRootUser:(UserModel *)rootUser;
@property (nonatomic,copy) UserModel *rootUserModel;
@end
