//
//  NSString+IMCCommon.h
//  iMacheng-iOS
//
//  Created by Wensj on 6/16/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IMCCommon)

- (NSString *)imc_URLEncoding;
- (NSString *)imc_URLDecoding;
- (NSString *)imc_md5String;
- (NSString*)imc_sha1String;
- (BOOL)imc_isEmail;
+ (NSString *)imc_randomWithLength:(int)length;

@end
