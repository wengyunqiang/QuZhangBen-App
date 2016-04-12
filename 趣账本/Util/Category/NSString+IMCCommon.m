//
//  NSString+IMCCommon.m
//  iMacheng-iOS
//
//  Created by Wensj on 6/16/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "NSString+IMCCommon.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"

@implementation NSString (IMCCommon)

- (NSString *)imc_URLEncoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}

- (NSString *)imc_URLDecoding {
    NSMutableString *string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (NSString *)imc_md5String {
    const char *cString = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];;
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString*)imc_sha1String {
    const char *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cString length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (BOOL)imc_isEmail {
    NSString *emailRegex = @"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+ (NSString *)imc_randomWithLength:(int)length {
    NSAssert(length > 0 && length < 33, @"Random length must between 0~32.");
    NSUInteger randomInteger = arc4random_uniform(10000);
    long long timeStamp = kTimeStamp;
    NSString *md5String = [[NSString stringWithFormat:@"%lu%lld", (unsigned long)randomInteger, timeStamp] imc_md5String];
    NSMutableString *resultString = [[NSMutableString alloc] initWithCapacity:length];
    for (int i = 0; i<length; i++) {
        [resultString appendString:[md5String substringWithRange:NSMakeRange(arc4random()%32, 1)]];
    }
    return [resultString copy];
}

@end
