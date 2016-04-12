//
//  EssayModel.m
//  趣账本
//
//  Created by wengYQ on 15/12/23.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "EssayModel.h"

@implementation EssayModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"essayID"            : @"essayID",
             @"title"         : @"title",
             @"essay"       : @"essay",
             @"imagePath"            : @"image",
             @"createTime"            : @"createTime"
             };
}
@end
