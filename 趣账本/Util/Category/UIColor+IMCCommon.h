//
//  UIColor+IMCCommon.h
//  iMacheng-iOS
//
//  Created by Wensj on 6/1/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (IMCCommon)

+ (UIColor *)imc_colorWithRGBHex:(UInt32)hex;
+ (UIColor *)imc_colorWithHexString:(NSString *)stringToConvert;

@end
