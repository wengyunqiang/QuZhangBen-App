//
//  NSUserDefaults+IMCCommon.h
//  iMacheng-iOS
//
//  Created by Wensj on 11/5/15.
//  Copyright © 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (IMCCommon)

+ (void)imc_setObject:(id)obj forKey:(NSString *)key;
+ (id)imc_objectForKey:(NSString *)key;
+ (void)imc_removeObjectForKey:(NSString *)key;

@end
