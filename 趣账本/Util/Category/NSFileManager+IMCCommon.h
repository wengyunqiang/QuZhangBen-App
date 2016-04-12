//
//  NSFileManager+IMCCommon.h
//  iMacheng-iOS
//
//  Created by Wensj on 6/10/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (IMCCommon)

+ (NSString *)imc_appPath;
+ (NSString *)imc_documentPath;
+ (NSString *)imc_libraryPath;
+ (NSString *)imc_cachePath;

@end
