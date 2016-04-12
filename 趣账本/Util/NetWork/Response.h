//
//  Response.h
//  Sky
//
//  Created by wengYQ on 15/12/8.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger,ResponseCode) {
    //成功码
    ResponseCodeSuccess = 200,
    
    //未知错误码
    ResponseCodeUnknownError = 40000,
    
    //Json错误码
    ResponseCodeJsonError = 40001,
    
    //网络错误码
    ResponseCodeNetWorkError = 50000,
};

typedef NS_ENUM(NSInteger,DataType){
    DataTypeEmptyArray,
    DataTypeNotEmptyArray,
    DataTypeEmptyDictionary,
    DataTypeNotEmptyDictionary,
    DataTypeEmptyString,
    DataTypeNotEmptyString,
    DataTypeNull,
    DataTypeNil
};

@interface Response : BaseModel

@property (nonatomic,assign,readonly) NSInteger code;
@property (nonatomic,strong,readonly) NSString *message;
@property (nonatomic,assign,readonly) BOOL isSuccess;
@property (nonatomic,strong,readonly) id data;

+ (instancetype)responseWithResponseCode:(ResponseCode)code message:(NSString *) message;
+ (instancetype)responseWithJsonData:(id)jsonData;
- (DataType)dataTypeWithKey:(NSString *)key;
@end
