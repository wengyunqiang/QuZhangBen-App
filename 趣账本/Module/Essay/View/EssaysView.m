//
//  EssaysView.m
//  趣账本
//
//  Created by wengYQ on 15/12/23.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "EssaysView.h"
#import "EssaysCell.h"
#import "EssayModel.h"
#import "IMCNetAPIManager.h"
#import "EssayDetailController.h"
#import <MJRefresh.h>
@interface EssaysView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *essaysArray;
@property (nonatomic,strong) EssayDetailController *essayDetailVC;
@end

@implementation EssaysView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EssaysCell class]) bundle:nil] forCellReuseIdentifier:@"EssaysCell"];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开手刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
        _tableView.mj_header = header;
        [self refresh];
        [self scrollTableToFoot:NO];
    }
    return self;
}

- (void) refresh{
    MCSelf(weakSelf);
    [[IMCNetAPIManager share]requestEssaysList:nil andBlock:^(Response *response) {
        if (response.isSuccess) {
            NSError *error = nil;
            weakSelf.essaysArray = [MTLJSONAdapter modelsOfClass:[EssayModel class] fromJSONArray:response.data error:&error];
            [weakSelf.tableView reloadData];
           
             [weakSelf.tableView.mj_header endRefreshing];
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"网络好像有点不给力，请重新刷新"];
            [weakSelf.tableView.mj_header endRefreshing];}
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _essaysArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *identifier = @"EssaysCell";
    EssaysCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[EssaysCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.essayModel = _essaysArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MCSelf(weakSelf);
    UINavigationController *rootNav = [self imc_navigationController];
    cell.clickBlock = ^{
        if (weakSelf.essayDetailVC == nil) {
            weakSelf.essayDetailVC =[[EssayDetailController alloc]init];
        }
        if (weakSelf.essayDetailVC.scroll2TopBlock) {
            weakSelf.essayDetailVC.scroll2TopBlock();
        }
        weakSelf.essayDetailVC.essayModel = weakSelf.essaysArray[indexPath.row];
        [rootNav pushViewController:weakSelf.essayDetailVC animated:YES];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 309;
}

#pragma mark -- scrollToFoot
- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [_tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [_tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

@end
