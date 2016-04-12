//
//  UserModel.h
//  趣账本
//
//  Created by wengYQ on 15/12/14.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *userAccount;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *avatarURL;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *birthday;
@end
