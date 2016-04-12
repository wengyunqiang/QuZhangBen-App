//
//  Response.m
//  Sky
//
//  Created by wengYQ on 15/12/8.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "Response.h"

@interface Response()
@property (nonatomic,assign,readwrite) NSInteger code;
@property (nonatomic,strong,readwrite) NSString *message;
@property (nonatomic,assign,readwrite) BOOL isSuccess;
@property (nonatomic,strong,readwrite) id data;
@end

@implementation Response
+ (instancetype)responseWithJsonData:(id)jsonData{
    NSError *error = nil;
    Response *response;
    if (jsonData != nil) {
        NSDictionary *objDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            response = [MTLJSONAdapter modelOfClass:[Response class] fromJSONDictionary:objDic error:&error];
            if (!error) {
                return response;
            }
        }
    }
    response.code = ResponseCodeJsonError;
    response.isSuccess = NO;
    response.message = [NSString stringWithFormat:@"Error json format:%lu%@",(unsigned long)((NSData *)jsonData).length,jsonData];
    response.data = nil;
    
    return response;
}

+ (instancetype)responseWithResponseCode:(ResponseCode)code message:(NSString *)message{
    Response *response = [[Response alloc] init];
    response.code = code;
    response.message = message;
    response.isSuccess = NO;
    return response;
}

- (void) setData:(id)data{
    if (_data != data) {
        _data = data;
    }
}

- (DataType)dataTypeWithKey:(NSString *)key{
    id data = _data[key];
    DataType dataType = DataTypeNil;
    if ([data isKindOfClass:[NSArray class]]) {
        dataType = DataTypeEmptyArray;
        if ([data performSelector:@selector(count)] > 0) {
            dataType = DataTypeNotEmptyArray;
        }
    }else if ([data isKindOfClass:[NSDictionary class]]){
        dataType = DataTypeEmptyDictionary;
        if ([data performSelector:@selector(count)] > 0) {
            dataType = DataTypeNotEmptyDictionary;
        }
    }else if ([data isKindOfClass:[NSString class]]) {
        dataType = DataTypeEmptyString;
        if ([data performSelector:@selector(length)] > 0) {
            dataType = DataTypeNotEmptyString;
        }
    }else if ([data isKindOfClass:[NSNull class]]){
        dataType = DataTypeNull;
    }else{
        dataType = DataTypeNil;
    }
    return dataType;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code"            : @"code",
             @"message"         : @"msg",
             @"isSuccess"       : @"success",
             @"data"            : @"data"
             };
}

+ (NSValueTransformer *)isSuccessJSONTransformer{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Response:\ncode:%ld | isSuccess:%u | message:%@ | data:%@",(long)self.code, self.isSuccess, self.message, self.data];
}

@end
