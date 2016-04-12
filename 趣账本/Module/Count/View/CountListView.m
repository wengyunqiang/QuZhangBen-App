//
//  CountListView.m
//  趣账本
//
//  Created by wengYQ on 15/12/19.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "CountListView.h"
#import "CountListCell.h"
#import "CountDetailController.h"
@interface CountListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *CountList;
@property (nonatomic,copy) NSDictionary *CostListDic;
@property (nonatomic,copy) NSDictionary *InComeListDic;
@property (nonatomic,copy) NSArray *currentKeysArray;
@property (nonatomic,copy) NSArray *currentValuesArray;
@property (nonatomic,strong) NSArray *colorArray;
@property (nonatomic,strong) CountDetailController *CountDetailVC;

@property (nonatomic,assign) float currentSum;
@end

@implementation CountListView

- (instancetype) initWithCostDic:(NSDictionary *)CostDic withInComeDic:(NSDictionary *)InComeDic withColorArray:(NSArray*)colors withFrame:(CGRect)Frame{
    if (self == [super initWithFrame:Frame]) {
        _CountList = [[UITableView alloc]initWithFrame:self.bounds];
        [_CountList imc_setHeight:self.bounds.size.height - 64];
        [_CountList setShowsVerticalScrollIndicator:NO];
        _CountList.delegate = self;
        _CountList.dataSource = self;
        
        _CountList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _colorArray = colors;
        
        _CostListDic = CostDic;
        _InComeListDic = InComeDic;
        
        _CostKeysArray = [_CostListDic allKeys];
        _InComeKeysArray = [_InComeListDic allKeys];
        
        _CostValuesArray = [_CostListDic allValues];
        _InComeValuesArray = [_InComeListDic allValues];
        
//把当前的key,value数组根据需要指向支出或者收入
        _currentKeysArray = _CostKeysArray;
        _currentValuesArray = _CostValuesArray;
        
        [_CountList registerNib:[UINib nibWithNibName:NSStringFromClass([CountListCell class]) bundle:nil] forCellReuseIdentifier:@"CountListCell"];
        
        _CostSum = 0;
        _InComeSum = 0;
        
        for (int i = 0; i<_CostValuesArray.count; i++) {
            _CostSum = _CostSum + [_CostValuesArray[i] floatValue];
        }
        
        for (int a = 0; a<_InComeValuesArray.count; a++) {
            _InComeSum = _InComeSum + [_InComeValuesArray[a] floatValue];
        }
        
        _currentSum = _CostSum;
        
        [self addSubview:_CountList];
        MCSelf(weakSelf);
        self.reloadForInComeBlock = ^{
            weakSelf.currentKeysArray = weakSelf.InComeKeysArray;
            weakSelf.currentValuesArray = weakSelf.InComeValuesArray;
            weakSelf.currentSum = weakSelf.InComeSum;
            [weakSelf.CountList reloadData];
        };
        self.reloadForCostBlock = ^{
            weakSelf.currentKeysArray = weakSelf.CostKeysArray;
            weakSelf.currentValuesArray = weakSelf.CostValuesArray;
            weakSelf.currentSum = weakSelf.CostSum;
            [weakSelf.CountList reloadData];
        };
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _currentKeysArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CountListCell";
    CountListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CountListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.FeeNameLb.text = _currentKeysArray[indexPath.row];
    cell.FeeValueLb.text = [NSString stringWithFormat:@"%@", _currentValuesArray[indexPath.row]];
    
    CGFloat Rate = ([_currentValuesArray[indexPath.row] floatValue]/_currentSum)*100;
    NSString *str = [NSString stringWithFormat:@"%.2f",Rate];
    
    if (_currentSum == 0) {
        str = @"0.00";
    }else{
       str = [NSString stringWithFormat:@"%.2f",Rate];
    }
    
    cell.RateLb.text = [str stringByAppendingString:@"%"];
    
    cell.colorView.backgroundColor = [_colorArray objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CountListCell *cell = (CountListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString *Percent = cell.RateLb.text;
    NSString *FeeName = cell.FeeNameLb.text;
    NSString *FeeSum = cell.FeeValueLb.text;
    
    NSArray *array = @[Percent,FeeName,FeeSum];
    
    if (_CountDetailVC == nil) {
        _CountDetailVC = [[CountDetailController alloc]init];
        _CountDetailVC.userID = _userID;
    }
    _CountDetailVC.headerArray = array;
    if (_CountDetailVC.reloadBlock) {
        _CountDetailVC.reloadBlock();
    }
    UINavigationController *rootNav = [self imc_navigationController];
    [rootNav pushViewController:_CountDetailVC animated:YES];
}
@end
