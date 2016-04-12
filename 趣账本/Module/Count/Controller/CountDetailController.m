//
//  CountDetailController.m
//  趣账本
//
//  Created by wengYQ on 15/12/27.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "CountDetailController.h"
#import "CountDetailHeader.h"
#import "CountDetailCell.h"
#import "IMCNetAPIManager.h"
@interface CountDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dateArrays;
@property (nonatomic,strong) NSArray *valueArray;
@end

@implementation CountDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
     [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CountDetailHeader class]) bundle:nil] forCellReuseIdentifier:@"CountDetailHeader"];
     [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CountDetailCell class]) bundle:nil] forCellReuseIdentifier:@"CountDetailCell"];
    MCSelf(weakSelf);
    self.navigationItem.title = _headerArray[1];
    
    self.reloadBlock = ^{
        
        [weakSelf clearList];
         [weakSelf sendRequest];
        weakSelf.navigationItem.title = weakSelf.headerArray[1];
        [weakSelf.tableView reloadData];
    };
    [self sendRequest];
}

//清空数据操作
- (void) clearList{
    self.dateArrays = nil;
    self.valueArray = nil;
    [self.tableView reloadData];
    }

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return _dateArrays.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"CountDetailHeader";
        CountDetailHeader *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[CountDetailHeader alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.PercentLb.text = self.headerArray[0];
        cell.FeeNameLb.text = self.headerArray[1];
        cell.FeeSumLb.text = self.headerArray[2];
        return cell;
    }
    else{
        static NSString *identifier = @"CountDetailCell";
        CountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[CountDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.DateLb.text = _dateArrays[indexPath.row];
        cell.FeeValueLb.text = _valueArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 116;
    }
    return 44;
}

-(void)sendRequest{
    NSString *userID = self.userID;
    NSString *FeeName = self.headerArray[1];
    
    NSDictionary *param = @{
                            @"userID" : userID,
                            @"FeeName": FeeName
                            };
    MCSelf(weakSelf);
    [[IMCNetAPIManager share]RequestDetailRecord:param andBlock:^(Response *response){
        if (response.code == 200) {
            weakSelf.dateArrays = response.data[@"date"];
            weakSelf.valueArray = response.data[@"value"];
            [weakSelf.tableView reloadData];
        }else if (response.code == 202){
            [SVProgressHUD showImage:nil status:@"该分类记账金额为0"];
        }
        
        if (!response.isSuccess) {
            [SVProgressHUD showInfoWithStatus:@"网络好像有点不给力。"];
        }
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 25)];
        headerView.backgroundColor = [UIColor colorWithWhite:0.974 alpha:1.000];
        
        //设置headerView上的三个lable。
        UILabel *dateLb = [[UILabel alloc]init];
        UILabel *costLb = [[UILabel alloc]init];
            [headerView addSubview:dateLb];
        [headerView addSubview:costLb];

        [dateLb setFont:[UIFont systemFontOfSize:10]];
        [costLb setFont:[UIFont systemFontOfSize:10]];
             [dateLb setTextAlignment:NSTextAlignmentLeft];
        [costLb setTextAlignment:NSTextAlignmentRight];
               [dateLb setTextColor:[UIColor colorWithWhite:0.525 alpha:1.000]];
        [costLb setTextColor:[UIColor colorWithWhite:0.525 alpha:1.000]];
      
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
        
        dateLb.text = @"日期";
        costLb.text = @"金额";
        
        return headerView;
    }
    return NULL;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }
    return 0;
}
@end
