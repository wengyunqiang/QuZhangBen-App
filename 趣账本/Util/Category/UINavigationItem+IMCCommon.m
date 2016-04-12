//
//  UINavigationItem+IMCCommon.m
//  iMacheng-iOS
//
//  Created by Wensj on 6/5/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "UINavigationItem+IMCCommon.h"
#import <objc/runtime.h>

static char kCustomBackButtonKey;

@implementation UINavigationItem (IMCCommon)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method imp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method myImp = class_getInstanceMethod(self, @selector(imcBackBarButtonItem));
        method_exchangeImplementations(imp, myImp);
    });
}

-(UIBarButtonItem *)imcBackBarButtonItem {
    UIBarButtonItem *item = [self imcBackBarButtonItem];
    if (item) {
        return item;
    }
    item = objc_getAssociatedObject(self, &kCustomBackButtonKey);
    if (!item) {
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:NULL];
        objc_setAssociatedObject(self, &kCustomBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

- (void)dealloc {
    objc_removeAssociatedObjects(self);
}

@end
