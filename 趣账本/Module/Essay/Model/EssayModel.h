//
//  EssayModel.h
//  趣账本
//
//  Created by wengYQ on 15/12/23.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "BaseModel.h"

@interface EssayModel : BaseModel
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *essayID;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *essay;
@property (nonatomic,strong) NSString *imagePath;
@end
