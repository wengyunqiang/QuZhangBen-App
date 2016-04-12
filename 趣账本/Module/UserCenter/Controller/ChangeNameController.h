//
//  ChangeNameController.h
//  趣账本
//
//  Created by wengYQ on 15/12/26.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
typedef void (^ClickSaveBlock)(void);
@interface ChangeNameController : UIViewController
@property (nonatomic,strong) UserModel *RootUser;
@property (nonatomic,copy) ClickSaveBlock saveBlock;
@property (nonatomic,copy) NSString *name;
@end
