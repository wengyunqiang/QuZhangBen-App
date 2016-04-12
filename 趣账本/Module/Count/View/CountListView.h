//
//  CountListView.h
//  趣账本
//
//  Created by wengYQ on 15/12/19.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChartListRelodata)(void);

@interface CountListView : UIView
- (instancetype) initWithCostDic:(NSDictionary *)CostDic withInComeDic:(NSDictionary *)InComeDic withColorArray:(NSArray*)colors withFrame:(CGRect)Frame;
@property (nonatomic,copy) ChartListRelodata reloadForInComeBlock;
@property (nonatomic,copy) ChartListRelodata reloadForCostBlock;
@property (nonatomic,strong) NSArray *CostKeysArray;
@property (nonatomic,strong) NSArray *CostValuesArray;
@property (nonatomic,strong) NSArray *InComeKeysArray;
@property (nonatomic,strong) NSArray *InComeValuesArray;
@property (nonatomic,assign) float CostSum;
@property (nonatomic,assign) float InComeSum;
@property (nonatomic,strong) NSString *userID;
@end
