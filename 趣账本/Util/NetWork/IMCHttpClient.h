//
//  IMCHttpClient.h
//  Sky
//
//  Created by wengYQ on 15/12/7.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
/**
 *  Http请求方式
 */
typedef NS_ENUM(NSInteger,IMCHttpRequestType){
    /**
     *  GET方式
     */
    IMCHttpRequestGet,
    
    /**
     *  POST方式
     */
    IMCHttpRequestPOST,
    
    /**
     *  图片上传
     */
    IMCHttpRequestFormData
};

/**
 *  请求网络前的预处理block
 */
typedef void (^PrepareExecuteBlock)(void);

@interface IMCHttpClient : NSObject

/**
 *  IMCHttpClient 单例类
 *
 *  @return IMCHttpClient
 */
+ (instancetype) share;

/**
 *  网络请求入口
 *
 *  @param path         api路径，不需要带上 domain
 *  @param method       请求类型，详细见`IMCHttpRequestType`
 *  @param params       请求参数，只是 data 层的数据
 *  @param prepareBlock 发送请求前要执行的 block
 *  @param resultBlock  请求成功后执行的 block
 */
- (void)requestWithPath:(NSString *)path
                 method:(IMCHttpRequestType)method
             parameters:(NSDictionary *)params
    prepareExecuteBlock:(PrepareExecuteBlock)prepareBlock
            resultBlock:(void (^)(Response *responseObj))resultBlock;

@end
