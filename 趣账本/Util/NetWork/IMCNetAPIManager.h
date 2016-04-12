//
//  IMCNetAPIManager.h
//  Sky
//
//  Created by wengYQ on 15/12/8.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
/**
 *      网络请求
 */
@interface IMCNetAPIManager : NSObject
/**
 *      单例
 */
+ (instancetype) share;

//请求用户数据
- (void) requestUserWithAccount:(id)params GetParams:(id)pathParams andBlock:(void(^)(Response *response))block;


//上传头像到服务器
- (void) RequestUpLoadAvatar:(id)params andBlock:(void(^)(Response *response))block;

//用户注册
- (void) RequestRegisterUser:(id)params pathParams:(id)pathParams andBlock:(void(^)(Response *response))block;

//请求账单
- (void) requestUserRecordsByUserID:(id)pathParams andBlock:(void(^)(Response *response))block;

//上传账单
- (void) RequestUpLoadRecord:(id)params andBlock:(void(^)(Response *response))block;

//请求文章列表
- (void) requestEssaysList:(id)pathParams andBlock:(void(^)(Response *response))block;

//个人中心更新属性
- (void) RequestUserProperty:(id)params andBlock:(void(^)(Response *response))block;

//账单明细编辑
- (void) RequestChangeRecord:(id)params andBlock:(void(^)(Response *response))block;

//账单统计明细
- (void) RequestDetailRecord:(id)params andBlock:(void(^)(Response *response))block;

//用户修改密码
- (void) RequestChangePassWord:(id)params andBlock:(void(^)(Response *response))block;
@end
