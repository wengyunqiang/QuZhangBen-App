//
//  NSFileManager+IMCCommon.m
//  iMacheng-iOS
//
//  Created by Wensj on 6/10/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "NSFileManager+IMCCommon.h"

@implementation NSFileManager (IMCCommon)

+ (NSString *)imc_appPath {
    return NSHomeDirectory();
}
+ (NSString *)imc_documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)imc_libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)imc_cachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

@end
