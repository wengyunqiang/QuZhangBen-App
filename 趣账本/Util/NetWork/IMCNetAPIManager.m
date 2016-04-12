//
//  IMCNetAPIManager.m
//  Sky
//
//  Created by wengYQ on 15/12/8.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "IMCNetAPIManager.h"
#import "IMCHttpClient.h"

#define CallBlock(block, responseObj) if (block) { block(responseObj); }

NSString *const IMCURLUserInfo             = @"User/GetUser/userAccount/[userAccount]";

NSString *const IMCURLUserAvatar               =@"User/uploadImage";

NSString *const IMCURLUserRegister               =@"User/Register";

NSString *const IMCURLUserRecords             = @"User/GetRecord/userID/[userID]";

NSString *const IMCURLUploadRecord       =@"User/uploadRecord";

NSString *const IMCURLGetEssays       =@"User/GetEssays";

NSString *const IMCURLChangeUserProperty       =@"User/ChangeUserProperty";

NSString *const IMCURLEditRecord       =@"User/ChangeRecord";

NSString *const IMCURLCountDetail      =@"User/CountDetail";

NSString *const IMCURLChangePassWord      =@"User/ChangePassWord";

@implementation IMCNetAPIManager

//      单例
SYNTHESIZE_SINGLETON_FOR_CLASS(IMCNetAPIManager);

/**
 *      请求用户信息
 */
- (void) requestUserWithAccount:(id)params GetParams:(id)pathParams andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:[self realPathWithFakePath:IMCURLUserInfo pathParams:pathParams]
                                     method:IMCHttpRequestGet
                                 parameters:params
                        prepareExecuteBlock:^{
                            [SVProgressHUD showWithStatus:nil];
                        } resultBlock:^(Response *responseObj) {
                            CallBlock(block, responseObj);
                        }];
}

/**
 *
 *  @param block  头像上传
 */
- (void) RequestUpLoadAvatar:(id)params andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:IMCURLUserAvatar
                                    method:IMCHttpRequestFormData
                                parameters:params
                       prepareExecuteBlock:^{
        } resultBlock:^(Response *responseObj) {
                    CallBlock(block, responseObj);
    }];
}


/**
 *  用户注册
 */
- (void) RequestRegisterUser:(id)params pathParams:(id)pathParams andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:IMCURLUserRegister method:IMCHttpRequestPOST parameters:params prepareExecuteBlock:^{
    } resultBlock:^(Response *responseObj) {
        CallBlock(block, responseObj);
    }];
}

//请求账单
- (void) requestUserRecordsByUserID:(id)pathParams andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:[self realPathWithFakePath:IMCURLUserRecords pathParams:pathParams]
                                    method:IMCHttpRequestGet
                                parameters:nil
                       prepareExecuteBlock:^{
                       } resultBlock:^(Response *responseObj) {
                           CallBlock(block, responseObj);
                       }];
    
}
//上传账单
- (void) RequestUpLoadRecord:(id)params andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:IMCURLUploadRecord method:IMCHttpRequestPOST parameters:params prepareExecuteBlock:^{
    } resultBlock:^(Response *responseObj) {
        CallBlock(block, responseObj);
    }];
}

//请求文章列表
- (void) requestEssaysList:(id)pathParams andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:[self realPathWithFakePath:IMCURLGetEssays pathParams:pathParams]
                                    method:IMCHttpRequestGet
                                parameters:nil
                       prepareExecuteBlock:^{
                           
                       } resultBlock:^(Response *responseObj) {
                           CallBlock(block, responseObj);
                       }];
}

//个人中心更新属性
- (void) RequestUserProperty:(id)params andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:IMCURLChangeUserProperty method:IMCHttpRequestPOST parameters:params prepareExecuteBlock:^{
    } resultBlock:^(Response *responseObj) {
        CallBlock(block, responseObj);
    }];
}

//账单明细编辑
- (void) RequestChangeRecord:(id)params andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:IMCURLEditRecord method:IMCHttpRequestPOST parameters:params prepareExecuteBlock:^{
    } resultBlock:^(Response *responseObj) {
        CallBlock(block, responseObj);
    }];
}

//账单统计明细
- (void) RequestDetailRecord:(id)params andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:IMCURLCountDetail method:IMCHttpRequestPOST parameters:params prepareExecuteBlock:^{
    } resultBlock:^(Response *responseObj) {
        CallBlock(block, responseObj);
    }];
}

//用户修改密码
- (void) RequestChangePassWord:(id)params andBlock:(void(^)(Response *response))block{
    [[IMCHttpClient share] requestWithPath:IMCURLChangePassWord method:IMCHttpRequestPOST parameters:params prepareExecuteBlock:^{
    } resultBlock:^(Response *responseObj) {
        CallBlock(block, responseObj);
    }];
}


#pragma mark - private methods
- (NSString *)realPathWithFakePath:(NSString *)fakePath pathParams:(NSDictionary *)pathParams {
    if (fakePath.length > 0) {
        NSString * pattern=@"\\[.*\\]";
        NSError *error;
        NSRegularExpression * reg=[[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:&error];
        NSArray * fakeParams = [reg matchesInString:fakePath options:NSMatchingReportCompletion range:NSMakeRange(0, [fakePath length])];
        NSMutableString *realPath = [NSMutableString stringWithString:fakePath];
        for (NSTextCheckingResult * result in fakeParams) {
            NSString *fakeParam = [fakePath substringWithRange:result.range];
            NSString *key = [fakeParam substringWithRange:NSMakeRange(1, fakeParam.length - 2)];
            NSString *convertToString = @"";
            id obj = pathParams[key];
            if (obj) {
                if ([obj isKindOfClass:[NSString class]]) {
                    convertToString = obj;
                } else {
                    convertToString = [obj stringValue];
                }
            }
            realPath = [[realPath stringByReplacingOccurrencesOfString:fakeParam withString:convertToString] mutableCopy];
        }
        return realPath;
    }
    return fakePath;
}

@end
