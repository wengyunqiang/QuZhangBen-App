//
//  UILabel+IMCCommon.m
//  iMacheng-iOS
//
//  Created by Wensj on 6/1/15.
//  Copyright (c) 2015 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "UILabel+IMCCommon.h"
#import <objc/runtime.h>

@implementation UILabel (IMCCommon)

+ (void)load {
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(imcInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)imcInitWithCoder:(NSCoder*)aDecode {
    [self imcInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = [UIFont fontWithName:kFontPrimary size:fontSize];
    }
    return self;
}

@end
