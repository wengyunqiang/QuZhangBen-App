//
//  CountViewController.m
//  趣账本
//
//  Created by wengYQ on 15/12/19.
//--------------------------------------------------------------------------------------------------------------------------------------------------------  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "CountViewController.h"
#import "XYPieChart.h"
#import "CountListView.h"
#import "YQSelectBtnView.h"
@interface CountViewController ()<XYPieChartDelegate,XYPieChartDataSource>
@property (weak, nonatomic) IBOutlet XYPieChart *ChartView;
@property(nonatomic, copy) NSArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (nonatomic,copy) NSArray *currentArray;
@property (nonatomic,strong) CountListView *countListView;
@property (weak, nonatomic) IBOutlet UIView *TitleView;
@property (weak, nonatomic) IBOutlet UILabel *SumLb;
@property (nonatomic,assign) float currentSum;
@property (nonatomic,strong) YQSelectBtnView *selectBtnView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLb;
@property (nonatomic,strong) NSDictionary *CostLstDic;
@property (nonatomic,strong) NSDictionary *InComeListDic;
@property (nonatomic,assign) float CostSum;
@property (nonatomic,assign) float InComeSum;
@end

@implementation CountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat BtnWidth = 120;
    
    CGFloat Sx = (self.view.bounds.size.width - BtnWidth)*0.5;
    _selectBtnView = [[YQSelectBtnView alloc]initWithBtnName1:@"支出" Name2:@"收入" withFrame:CGRectMake(Sx, 8, BtnWidth, 30) withStringColor:[UIColor colorWithRed:0.939 green:0.574 blue:0.155 alpha:1.000]];
    [self.view addSubview:_selectBtnView];
    
    [self dataSet];
    
    //添加分割线
    UIView *line = [[UIView alloc]init];
    [_ChartView addSubview:line];
    [self.navigationItem setTitle:@"账单统计"];
    MCSelf(weakSelf);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.ChartView).offset(-23);
        make.height.mas_equalTo(1);
        make.left.right.equalTo(weakSelf.ChartView);
    }];
    line.backgroundColor = [UIColor colorWithWhite:0.788 alpha:1.000];
    _ChartView.delegate  = self;
    _ChartView.dataSource = self;
    
    [_ChartView setStartPieAngle:M_PI_2];
    [_ChartView setAnimationSpeed:1.0];
    [_ChartView setPieRadius:120];
    [_ChartView setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:12]];
    [_ChartView setLabelRadius:90];
    [_ChartView setShowLabel:NO];
    //[_ChartView setShowPercentage:NO]; //显示百分比
    [_ChartView setPieCenter:CGPointMake(self.view.bounds.size.width*0.5, 170)];
    [_ChartView setUserInteractionEnabled:NO];
    [_ChartView setLabelColor:[UIColor blackColor]];
    [self.TitleView.layer setCornerRadius:self.TitleView.bounds.size.width*0.5];
    self.TitleView.clipsToBounds = YES;
   
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:0.944 green:0.288 blue:0.922 alpha:1.000],
                       [UIColor colorWithRed:0.944 green:1.000 blue:0.147 alpha:1.000],
                       [UIColor colorWithRed:0.893 green:0.705 blue:0.432 alpha:1.000],
                       [UIColor colorWithRed:0.008 green:0.886 blue:1.000 alpha:1.000],
                       [UIColor colorWithRed:0.298 green:1.000 blue:0.332 alpha:1.000],
                       [UIColor colorWithRed:1.000 green:0.498 blue:0.388 alpha:1.000],
                       [UIColor colorWithRed:1.000 green:0.607 blue:0.187 alpha:1.000],
                       [UIColor colorWithRed:0.260 green:0.573 blue:1.000 alpha:1.000],nil];
  

    
    //创建CountListView
    CGFloat Y = CGRectGetMaxX(_ChartView.frame);
    CGFloat H = self.view.bounds.size.height - Y;
    _countListView = [[CountListView alloc]initWithCostDic:_CostLstDic withInComeDic:_InComeListDic withColorArray:self.sliceColors withFrame:CGRectMake(0, Y, self.view.bounds.size.width, H)];
    _countListView.userID = _userID;
    [self.view addSubview:_countListView];
    
    self.SumLb.font =[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14];
    //根据需要切换currentSum
    _selectBtnView.block1 = ^{
        weakSelf.TitleLb.text = @"总支出";
        weakSelf.currentArray = [weakSelf.CostLstDic allValues];
        weakSelf.slices = weakSelf.currentArray;
        weakSelf.currentSum = weakSelf.CostSum;
        weakSelf.SumLb.text = [NSString stringWithFormat:@"%.2f",weakSelf.currentSum];
        weakSelf.countListView.reloadForCostBlock();
        [weakSelf.ChartView reloadData];
    };
    
    _selectBtnView.block2 = ^{
        weakSelf.TitleLb.text = @"总收入";
        weakSelf.currentArray = [weakSelf.InComeListDic allValues];
        weakSelf.slices = weakSelf.currentArray;
        weakSelf.currentSum = weakSelf.InComeSum;
        weakSelf.SumLb.text = [NSString stringWithFormat:@"%.2f",weakSelf.currentSum];
        weakSelf.countListView.reloadForInComeBlock();
        [weakSelf.ChartView reloadData];
    };
    
    //刷新的Block
    self.reloadBlock = ^{
        [weakSelf dataSet];
        weakSelf.countListView.CostKeysArray = [weakSelf.CostLstDic allKeys];
        weakSelf.countListView.CostValuesArray = [weakSelf.CostLstDic allValues];
        weakSelf.countListView.InComeKeysArray = [weakSelf.InComeListDic allKeys];
        weakSelf.countListView.InComeValuesArray = [weakSelf.InComeListDic allValues];
        weakSelf.countListView.CostSum = weakSelf.CostSum;
        weakSelf.countListView.InComeSum = weakSelf.InComeSum;
        weakSelf.selectBtnView.block1();
        [weakSelf.ChartView reloadData];
    };
    
}

- (void)viewDidUnload
{
    [self setChartView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.ChartView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:index];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    //NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    //NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    //NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    //NSLog(@"did select slice at index %lu",(unsigned long)index);
}


#pragma mark - 数据处理方法
- (void) dataSet{
    
    _selectBtnView.defaultStatusBlock();
    
    //cost相关
    CGFloat playCost = 0;
    CGFloat eatCost = 0;
    CGFloat clothesCost = 0;
    CGFloat trafficCost = 0;
    CGFloat dailyCost = 0;
    CGFloat digitalCost = 0;
    CGFloat phoneCost = 0;
    CGFloat utilities = 0;
    
    //inCome相关
    CGFloat salary = 0;
    CGFloat reward = 0;
    CGFloat partTimeJob = 0;
    CGFloat luckyMoney = 0;
    
    for (int i =0; i<self.RecordData.count; i++) {
        NSDictionary *costList = _RecordData[i][@"costList"];
        NSDictionary *inComeList = _RecordData[i][@"inComeList"];
        NSArray *costKeys = [costList allKeys];
        NSArray *inComeKeys = [inComeList allKeys];
        
        if ([costKeys containsObject:@"娱乐"]) {
            playCost = playCost + [costList[@"娱乐"] floatValue];
        }
        if([costKeys containsObject:@"餐饮"]){
            eatCost = eatCost + [costList[@"餐饮"] floatValue];
        }
        if([costKeys containsObject:@"服装"]){
            clothesCost = clothesCost + [costList[@"服装"] floatValue];
        }
        if([costKeys containsObject:@"交通"]){
            trafficCost = trafficCost + [costList[@"交通"] floatValue];
        }
        if([costKeys containsObject:@"日用品"]){
            dailyCost = dailyCost + [costList[@"日用品"] floatValue];
        }
        if([costKeys containsObject:@"数码"]){
            digitalCost = digitalCost + [costList[@"数码"] floatValue];
        }
        if([costKeys containsObject:@"话费"]){
            phoneCost = phoneCost + [costList[@"话费"] floatValue];
        }
        if([costKeys containsObject:@"水电费"]){
            utilities = utilities + [costList[@"水电费"] floatValue];
        }
        
        if ([inComeKeys containsObject:@"工资"]) {
            salary = salary + [inComeList[@"工资"] floatValue];
        }
        if ([inComeKeys containsObject:@"奖金"]){
            reward = reward + [inComeList[@"奖金"] floatValue];
        }
        if ([inComeKeys containsObject:@"兼职"]){
            partTimeJob = partTimeJob + [inComeList[@"兼职"] floatValue];
        }
        if ([inComeKeys containsObject:@"红包"]){
            luckyMoney = luckyMoney + [inComeList[@"红包"] floatValue];
        }
    }
    
    NSNumber *play = [[NSNumber alloc]initWithFloat:playCost];
    NSNumber *eat = [[NSNumber alloc]initWithFloat:eatCost];
    NSNumber *clothes = [[NSNumber alloc]initWithFloat:clothesCost];
    NSNumber *traffic = [[NSNumber alloc]initWithFloat:trafficCost];
    NSNumber *daily = [[NSNumber alloc]initWithFloat:dailyCost];
    NSNumber *digital = [[NSNumber alloc]initWithFloat:digitalCost];
    NSNumber *phone = [[NSNumber alloc]initWithFloat:phoneCost];
    NSNumber *utilitiesCost = [[NSNumber alloc]initWithFloat:utilities];
    
    NSNumber *salaryCome = [[NSNumber alloc]initWithFloat:salary];
    NSNumber *rewardCome = [[NSNumber alloc]initWithFloat:reward];
    NSNumber *partTimeJobCome = [[NSNumber alloc]initWithFloat:partTimeJob];
    NSNumber *luckMoneyCome = [[NSNumber alloc]initWithFloat:luckyMoney];
    //创建Cost列表字典
    _CostLstDic = @{
                                 @"娱乐" : play,
                                 @"餐饮" : eat,
                                 @"服装" : clothes,
                                 @"交通" : traffic,
                                 @"日用品" : daily,
                                 @"数码" : digital,
                                 @"话费" : phone,
                                 @"水电费":utilitiesCost,
                                 };
    
    //创建InCome列表字典
    _InComeListDic = @{
                                    @"工资" : salaryCome,
                                    @"奖金" : rewardCome,
                                    @"兼职" : partTimeJobCome,
                                    @"红包" : luckMoneyCome,
                                    };
    //设置金额总数
    
    NSArray *CostValuesArray = [_CostLstDic allValues];
    _CostSum = 0;
    for (int i = 0; i<CostValuesArray.count; i++) {
        _CostSum = _CostSum + [CostValuesArray[i] floatValue];
    }
    NSArray *InComeValuesArray = [_InComeListDic allValues];
    _InComeSum = 0;
    for (int a = 0; a<InComeValuesArray.count; a++) {
        _InComeSum = _InComeSum + [InComeValuesArray[a] floatValue];
    }
    self.SumLb.font =[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14];
    _currentArray = [_CostLstDic allValues];
    _slices = _currentArray;
    _currentSum = _CostSum;
    _SumLb.text = [NSString stringWithFormat:@"%.2f",_currentSum];
    
}

@end
