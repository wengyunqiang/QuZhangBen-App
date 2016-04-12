//
//  NSDate+IMCCommon.h
//  iMacheng-iOS
//
//  Created by Wensj on 10/28/15.
//  Copyright © 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (IMCCommon)

+ (NSString *)imc_getUTCFormateLocalDate:(NSString *)localDate;
+ (NSString *)imc_getLocalDateFormateUTCDate:(NSString *)utcDate;
+ (NSString *)imc_getUTCFormatDate:(NSDate *)localDate;
+ (NSDate *)imc_getLocalFromUTC:(NSString *)utc;

@end
