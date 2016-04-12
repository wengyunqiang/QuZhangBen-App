//
//  CountViewController.h
//  趣账本
//
//  Created by wengYQ on 15/12/19.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChartViewRelodata)(void);

@interface CountViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *RecordData;
@property (nonatomic,copy) ChartViewRelodata reloadBlock;
@property (nonatomic,strong) NSString *userID;
@end