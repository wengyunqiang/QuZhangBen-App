//
//  AddRecordViewController.m
//  趣账本
//
//  Created by wengYQ on 15/12/15.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "AddRecordViewController.h"
#import "UserModel.h"
#import "IMCNetAPIManager.h"
#import "RecordView.h"
#import "CountViewController.h"
#import "SelectAddController.h"
#import "EssayViewController.h"
#import "UserCenterViewController.h"
#import <MJRefresh.h>
@interface AddRecordViewController ()
@property (nonatomic,strong) UIButton *CountBtn;
@property (nonatomic,strong) UIButton *WriteBtn;
@property (nonatomic,strong) UIButton *EssayBtn;
@property (nonatomic,strong) UIButton *UserCenterBtn;
@property (nonatomic,strong) UIView *BottomView;
@property (nonatomic,strong) RecordView *recordView;
@property (nonatomic,strong) NSMutableArray *recordData;
@property (nonatomic,strong) CountViewController *CountVC;
@property (nonatomic,strong) SelectAddController *AddVC;
@property (nonatomic,strong) EssayViewController *EssaysVC;
@property (nonatomic,strong) UserCenterViewController *UserCenterVC;
@end

@implementation AddRecordViewController

- (instancetype)initWithRootUser:(UserModel *)rootUser{
    if (self == [super init]) {
        _rootUserModel = rootUser;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton = YES;//隐藏返回按钮
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",self.rootUserModel.userName]];
    MCSelf(weakSelf);
    [self sendRequest];
    _recordView = [[RecordView alloc]initWithRecordData:_recordData];
    _recordView.rootUser = _rootUserModel;
    [_recordView setFrame:self.view.bounds];
    [_recordView imc_setHeight:self.view.bounds.size.height - 50];
    [self.view addSubview:_recordView];
    _recordView.finishEditBlock = ^{
        [weakSelf sendRequest];
    };
    
    _BottomView = [[UIView alloc]init];
    [self.view addSubview:_BottomView];
    [_BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(50);
    }];
    [_BottomView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *line = [[UIView alloc]init];
    [_BottomView addSubview:line];
    line.backgroundColor = Color_Line;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(_BottomView);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat L = (self.view.bounds.size.width - (50*2+80))/3;
    
    //创建底部的四个按钮
    _CountBtn = [[UIButton alloc]init];
    [_BottomView addSubview:_CountBtn];
    [_CountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(weakSelf.BottomView);
        make.left.equalTo(weakSelf.BottomView).offset(10);
    }];
    [_CountBtn setBackgroundImage:[UIImage imageNamed:@"Chart.png"] forState:UIControlStateNormal];
    
    _WriteBtn = [[UIButton alloc]init];
    [_BottomView addSubview:_WriteBtn];
    [_WriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.CountBtn.mas_right).offset(L);
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(weakSelf.BottomView);
    }];
    [_WriteBtn setBackgroundImage:[UIImage imageNamed:@"Pencil0.png"] forState:UIControlStateNormal];
    
    _EssayBtn = [[UIButton alloc]init];
    [_BottomView addSubview:_EssayBtn];
    [_EssayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.WriteBtn.mas_right).offset(L);
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(weakSelf.BottomView);
    }];
    [_EssayBtn setBackgroundImage:[UIImage imageNamed:@"Book.png"] forState:UIControlStateNormal];
    
    _UserCenterBtn = [[UIButton alloc]init];
    [_BottomView addSubview:_UserCenterBtn];
    [_UserCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.EssayBtn.mas_right).offset(L);
        make.width.height.mas_equalTo(40);
        make.centerY.equalTo(weakSelf.BottomView);
    }];
    [_UserCenterBtn setBackgroundImage:[UIImage imageNamed:@"UserCenter.png"] forState:UIControlStateNormal];
    
    [_CountBtn addTarget:self action:@selector(ClickCountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_WriteBtn addTarget:self action:@selector(ClickWriteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_EssayBtn addTarget:self action:@selector(ClickEssayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_UserCenterBtn addTarget:self action:@selector(ClickUserCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
}

//点击统计按钮
- (void)ClickCountBtn:(id)sender {
    if (_CountVC == nil) {
        _CountVC = MCInitViewControllerFromStoryboard(@"Main", @"CountViewController.m");
        _CountVC.userID = _rootUserModel.userID;
    }
    //如果有数据改变，则重新加载数据
    _CountVC.RecordData = self.recordData;
    if (_CountVC.reloadBlock) {
        _CountVC.reloadBlock();
    }
    [self.navigationController pushViewController:_CountVC animated:YES];
}

//点击记账按钮
- (void)ClickWriteBtn:(id)sender {
    if (_AddVC == nil) {
        _AddVC = [[SelectAddController alloc]init];
        MCSelf(weakSelf);
        _AddVC.finishAddBlock = ^{
            [weakSelf sendRequest];
        };
        _AddVC.rootUser = self.rootUserModel;
    }
    [self.navigationController pushViewController:_AddVC animated:YES];
}

//点击省钱攻略按钮
- (void)ClickEssayBtn:(id)sender {
    if (_EssaysVC == nil) {
        _EssaysVC = [[EssayViewController alloc]init];
    }
    [self.navigationController pushViewController:_EssaysVC animated:YES];
}

//点击个人中心按钮
- (void)ClickUserCenterBtn:(id)sender {
    if (_UserCenterVC == nil) {
        MCSelf(weakSelf);
        _UserCenterVC = [[UserCenterViewController alloc]initWithRootUser:_rootUserModel];
        _UserCenterVC.changeUserNameBlock = ^{
            [weakSelf.navigationItem setTitle:weakSelf.UserCenterVC.userName];
        };
    }
    [self.navigationController pushViewController:_UserCenterVC animated:YES];
}

- (void) sendRequest{
    MCSelf(weakSelf);
    NSString *userID = self.rootUserModel.userID;
    NSDictionary *param = @{
                            @"userID" : userID
                            };
    [[IMCNetAPIManager share]requestUserRecordsByUserID:param andBlock:^(Response *response) {
        if (response.isSuccess) {
            weakSelf.recordData = response.data;
            weakSelf.recordView.myRecords = weakSelf.recordData;
            weakSelf.recordView.reloadBlock();
            [SVProgressHUD dismiss];
        }
        if (response.code == 202){
            weakSelf.recordData = response.data;
            weakSelf.recordView.myRecords = weakSelf.recordData;
            weakSelf.recordView.reloadBlock();
            [SVProgressHUD showImage:nil status:@"您暂无账单记录"];
        
        }
        
        if(!response.isSuccess){
            [SVProgressHUD showInfoWithStatus:@"网络好像有点不给力哦，请尝试再次刷新"];
        }
    }];
}
@end
