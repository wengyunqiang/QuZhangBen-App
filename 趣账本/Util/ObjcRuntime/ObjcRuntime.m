//
//  ObjcRuntime.m
//  iMacheng-iOS
//
//  Created by Wensj on 6/3/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "ObjcRuntime.h"
#import <objc/runtime.h>

void Swizzle(Class c, SEL originalSEL, SEL newSEL) {
    Method originalMethod = class_getInstanceMethod(c, originalSEL);
    Method newMethod = nil;
    if (!originalMethod) {
        originalMethod = class_getClassMethod(c, originalSEL);
        if (!originalMethod) return;
        newMethod = class_getClassMethod(c, newSEL);
        if (!newMethod) return;
    } else {
        newMethod = class_getInstanceMethod(c, newSEL);
        if (!newMethod) return;
    }
    if (class_addMethod(c, originalSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, newSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}
