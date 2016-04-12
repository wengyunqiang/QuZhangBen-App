//
//  RecordDetailController.h
//  趣账本
//
//  Created by wengYQ on 15/12/27.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^reloadBlock)(void);
typedef void (^FinishEditBlock)(void);
@interface RecordDetailController : UIViewController
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,copy) NSArray *valuesArray;
@property (nonatomic,copy) reloadBlock reloadDataBlock;
@property (nonatomic,copy) FinishEditBlock finishEditBlock;
@end
