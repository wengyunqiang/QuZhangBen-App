//
//  RecordView.h
//  趣账本
//
//  Created by wengYQ on 15/12/16.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
typedef void (^reloadDataBlock)(void);
typedef void (^FinishEditBlock)(void);
@interface RecordView : UIView
@property (nonatomic,copy) NSMutableArray *myRecords;
- (instancetype)initWithRecordData:(NSMutableArray *)RecordData;
@property (nonatomic,copy) reloadDataBlock reloadBlock;
@property (nonatomic,strong) UserModel *rootUser;
@property (nonatomic,copy) FinishEditBlock finishEditBlock;
@end
