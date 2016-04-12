//
//  CountDetailController.h
//  趣账本
//
//  Created by wengYQ on 15/12/27.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^reloadDataBlock)(void);
@interface CountDetailController : UIViewController
@property (nonatomic,strong) NSArray *headerArray;
@property (nonatomic,copy) reloadDataBlock reloadBlock;
@property (nonatomic,strong) NSString *userID;
@end
