//
//  IMCHttpClient.m
//  Sky
//
//  Created by wengYQ on 15/12/7.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "IMCHttpClient.h"
#import <AFNetworking.h>

#define CallBlock(block, response) if (block) { block(response); }

@interface IMCHttpClient ()
@property(nonatomic, strong) AFHTTPSessionManager *httpSectionManager;
@end

@implementation IMCHttpClient
- (id)init{
    if (self = [super init]){
        self.httpSectionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:IMCApiBaseURLString]];
        self.httpSectionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.httpSectionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil];
        self.httpSectionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return self;
}
/**
 *  单例化
 */
SYNTHESIZE_SINGLETON_FOR_CLASS(IMCHttpClient);


- (void)requestWithPath:(NSString *)path
                 method:(IMCHttpRequestType)method
             parameters:(NSDictionary *)params
    prepareExecuteBlock:(PrepareExecuteBlock)prepareBlock
            resultBlock:(void (^)(Response *responseObj))resultBlock{
    if (path && path.length > 0) {
        if (prepareBlock) {
            prepareBlock();
        }
        path =  [NSString stringWithString:[path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (!params) {
            params = @{};
        }
        MCSelf(weakSelf);
        DLog(@"\n===================== request =====================\n%@ %@%@:\n%@", kTimeStampString, self.httpSectionManager.baseURL, path, params);
        switch (method) {
            case IMCHttpRequestGet:{
                [self.httpSectionManager GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                    [weakSelf doRequestFinishedSuccess:YES path:path responseObject:responseObject error:nil resultBlock:resultBlock];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [weakSelf doRequestFinishedSuccess:NO path:path responseObject:nil error:error resultBlock:resultBlock];
                }];
            }
                break;
            case IMCHttpRequestPOST:{
                [self.httpSectionManager POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                   [weakSelf doRequestFinishedSuccess:YES path:path responseObject:responseObject error:nil resultBlock:resultBlock];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                   [weakSelf doRequestFinishedSuccess:NO path:path responseObject:nil error:error resultBlock:resultBlock];
                }];
            }
                break;
            case IMCHttpRequestFormData:{
                [self.httpSectionManager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileData:[NSData dataWithData:params[@"image"]] name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                } success:^(NSURLSessionDataTask *task, id responseObject) {
                    [weakSelf doRequestFinishedSuccess:YES path:path responseObject:responseObject error:nil resultBlock:resultBlock];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                      [weakSelf doRequestFinishedSuccess:NO path:path responseObject:nil error:error resultBlock:resultBlock];
                }];
            }
                break;
            default:
                break;
        }
    }else{
        DLog(@"Request path can not be nil.");
    }
}

- (void)doRequestFinishedSuccess:(BOOL) isSuccess
                            path:(NSString *)path
                  responseObject:(id)responseObject
                           error:(NSError *) error
                     resultBlock:(void (^)(Response *))resultBlock{
    Response *response = nil;
    if (isSuccess){
        response = [Response responseWithJsonData:responseObject];
    } else {
        response = [Response responseWithResponseCode:ResponseCodeNetWorkError message:error.localizedDescription];
    }
    DLog(@"\n===================== response =====================\n%@ %@%@:\n%@", kTimeStampString, self.httpSectionManager.baseURL, path, response.description);
    CallBlock(resultBlock, response);
}
@end
