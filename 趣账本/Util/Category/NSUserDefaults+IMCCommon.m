//
//  NSUserDefaults+IMCCommon.m
//  iMacheng-iOS
//
//  Created by Wensj on 11/5/15.
//  Copyright © 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "NSUserDefaults+IMCCommon.h"

@implementation NSUserDefaults (IMCCommon)

+ (void)imc_setObject:(id)obj forKey:(NSString *)key {
    if (obj && key.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id)imc_objectForKey:(NSString *)key {
    if (key.length > 0) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+ (void)imc_removeObjectForKey:(NSString *)key {
    if (key.length > 0) {
        return [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

@end
