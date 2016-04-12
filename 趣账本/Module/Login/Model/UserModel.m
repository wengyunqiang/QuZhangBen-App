//
//  UserModel.m
//  趣账本
//
//  Created by wengYQ on 15/12/14.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"userID" : @"userID",
    @"userAccount" : @"userAccount",
    @"userName" : @"userName",
    @"password" : @"password",
    @"createTime" : @"createTime",
    @"avatarURL" : @"avatarURL",
    @"sex" : @"sex",
    @"birthday" : @"birthday"
  };
}

@end
