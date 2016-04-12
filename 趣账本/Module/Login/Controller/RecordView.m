//
//  RecordView.m
//  趣账本
//
//  Created by wengYQ on 15/12/16.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "RecordView.h"
#import "RecordListCell.h"
#import "IMCNetAPIManager.h"
#import "RecordHeaderCell.h"
#import "RecordDetailController.h"
#import "UserModel.h"
#import <MJRefresh.h>
@interface RecordView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGFloat MonthCostSum;
@property (nonatomic,assign) CGFloat MonthInComeSum;
@property (nonatomic,strong) RecordDetailController *RecordDetailVC;
@property (nonatomic,strong) UIView *EmptyView;
@end

@implementation RecordView
- (instancetype)initWithRecordData:(NSMutableArray *)RecordData{
    if (self == [super init]) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height - 50 -64;
        _myRecords = RecordData;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        _tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecordListCell class]) bundle:nil] forCellReuseIdentifier:@"RecordListCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecordHeaderCell class]) bundle:nil] forCellReuseIdentifier:@"RecordHeaderCell"];
        MCSelf(weakSelf);
        
        _EmptyView = [[UIView alloc]init];
        [_tableView addSubview:_EmptyView];
        [_EmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.tableView);
            make.centerY.equalTo(weakSelf.tableView).offset(-20);
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(160);
        }];
        
        UILabel *emptyTitle = [[UILabel alloc]init];
        [_EmptyView addSubview:emptyTitle];
        [emptyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.EmptyView);
            make.top.right.left.equalTo(weakSelf.EmptyView);
            make.height.mas_equalTo(30);
        }];
        emptyTitle.textAlignment = NSTextAlignmentCenter;
        emptyTitle.text = @"您还没有账单记录哦~";
        emptyTitle.font = [UIFont systemFontOfSize:15];
        emptyTitle.textColor = [UIColor blackColor];
        
        UIImageView *emptyImage = [[UIImageView alloc]init];
        [_EmptyView addSubview:emptyImage];
        [emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(emptyTitle.mas_bottom).offset(10);
            make.width.mas_equalTo(230);
            make.centerX.equalTo(weakSelf.EmptyView);
            make.height.mas_equalTo(170);
        }];
        emptyImage.image = [UIImage imageNamed:@"emptyPic.jpg"];
        _EmptyView.hidden = YES;
        
        self.reloadBlock = ^{
            CGFloat costSum = 0;
            CGFloat inComeSum = 0;
            for (int i =0; i<weakSelf.myRecords.count; i++) {
                costSum = costSum + [weakSelf.myRecords[i][@"costSum"] floatValue];
                inComeSum = inComeSum + [weakSelf.myRecords[i][@"inComeSum"] floatValue];
            }
            
            if (costSum == 0 && inComeSum==0) {
                weakSelf.EmptyView.hidden = NO;
            }else{
                weakSelf.EmptyView.hidden = YES;
            }
            
            weakSelf.MonthCostSum = costSum;
            weakSelf.MonthInComeSum = inComeSum;
            [weakSelf.tableView reloadData];
        };
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开手刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
        _tableView.mj_header = header;
    }
    return self;
}

- (void) refresh{
    self.finishEditBlock();
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - UITableViewDelegate & DataResource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myRecords.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    NSDictionary *costList = _myRecords[section-1][@"costList"];
    NSDictionary *inComeList = _myRecords[section-1][@"inComeList"];
    int count = (int)(costList.allKeys.count + inComeList.allKeys.count);
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"RecordHeaderCell";
       RecordHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[RecordHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.CostSumLb.text = [NSString stringWithFormat:@"%.2f",_MonthCostSum ];
        cell.inComeSumLb.text = [NSString stringWithFormat:@"%.2f",_MonthInComeSum];
        return cell;
    }
    
    static NSString *identifier = @"RecordListCell";
    RecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RecordListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *costList = _myRecords[indexPath.section-1][@"costList"];
    NSArray *costKeys = costList.allKeys;
    NSArray *costvalues = costList.allValues;
   
    NSDictionary *inComeList = _myRecords[indexPath.section-1][@"inComeList"];
    NSArray *inComekeys = inComeList.allKeys;
    NSArray *inComevalues = inComeList.allValues;
    
    int costCount = (int)costKeys.count;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < costCount) {
        cell.FeeNameLb.text = costKeys[indexPath.row];
        cell.FeeValueLb.text =[ NSString stringWithFormat:@"%@",costvalues[indexPath.row]];
        cell.FeeValueLb.textColor = [UIColor blackColor];
    }else
    {
        cell.FeeNameLb.text = inComekeys[indexPath.row-costCount];
        cell.FeeValueLb.text =[ NSString stringWithFormat:@"%@",inComevalues[indexPath.row-costCount]];
        cell.FeeValueLb.textColor = [UIColor colorWithRed:0.000 green:0.665 blue:0.000 alpha:1.000];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 25)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.959 alpha:1.000];
    
    //设置headerView上的三个lable。
    UILabel *dateLb = [[UILabel alloc]init];
    UILabel *costLb = [[UILabel alloc]init];
    UILabel *inCome = [[UILabel alloc]init];
    [headerView addSubview:dateLb];
    [headerView addSubview:costLb];
    [headerView addSubview:inCome];
    [dateLb setFont:[UIFont systemFontOfSize:10]];
    [costLb setFont:[UIFont systemFontOfSize:10]];
    [inCome setFont:[UIFont systemFontOfSize:10]];
    [dateLb setTextAlignment:NSTextAlignmentLeft];
    [costLb setTextAlignment:NSTextAlignmentRight];
    [inCome setTextAlignment:NSTextAlignmentRight];
    [dateLb setTextColor:[UIColor colorWithWhite:0.525 alpha:1.000]];
    [costLb setTextColor:[UIColor colorWithWhite:0.525 alpha:1.000]];
    [inCome setTextColor:[UIColor colorWithWhite:0.525 alpha:1.000]];
    [dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(22);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(headerView);
    }];
   
    [costLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-22);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(headerView);
    }];

    [inCome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(costLb.mas_left).offset(-5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(headerView);
    }];
    
     NSString *createTime = _myRecords[section - 1][@"createTime"];
    NSString *costSum;
    NSString *inComeSum;
    if (!_myRecords[section - 1][@"costSum"]) {
        costSum = @"支出:0";
    }else{
        costSum = [NSString stringWithFormat:@"支出:%@",_myRecords[section - 1][@"costSum"]];}
    if (!_myRecords[section - 1][@"inComeSum"]) {
        inComeSum = @"收入:0";
    }else{
        inComeSum = [NSString stringWithFormat:@"收入:%@",_myRecords[section - 1][@"inComeSum"]];}
    
     dateLb.text = createTime;
     costLb.text = costSum;
     inCome.text = inComeSum;
    
     return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 74;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section > 0) {
        
        RecordListCell *cell = (RecordListCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (_RecordDetailVC == nil) {
            _RecordDetailVC = [[RecordDetailController alloc]init];
            _RecordDetailVC.userID = self.rootUser.userID;
        }
        
        MCSelf(weakSelf);
        NSString *date = _myRecords[indexPath.section - 1][@"createTime"];
        
        NSString *money = cell.FeeValueLb.text;
        
        NSString *FeeName = cell.FeeNameLb.text;
        
        _RecordDetailVC.valuesArray = @[money,FeeName,date];
        
        _RecordDetailVC.finishEditBlock =^{
            weakSelf.finishEditBlock();
        };

        
        if (_RecordDetailVC.reloadDataBlock) {
            _RecordDetailVC.reloadDataBlock();
            
        }
        
        UINavigationController *rootNav = [self imc_navigationController];
        
        [rootNav pushViewController:_RecordDetailVC animated:YES];
    }
}
@end
